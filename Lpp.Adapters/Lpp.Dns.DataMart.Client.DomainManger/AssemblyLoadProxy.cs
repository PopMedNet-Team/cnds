﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Reflection;
using ICSharpCode.SharpZipLib.Zip;
using log4net;

namespace Lpp.Dns.DataMart.Client.DomainManger
{
    public class AssemblyLoadProxy : MarshalByRefObject
    {
        ZipFile archive = null;

        public void InitializeLogging(Logging.CrossDomainParentAppender parentAppender)
        {
            Logging.CrossDomainChildLoggingSetup loggingSetup = (Logging.CrossDomainChildLoggingSetup)Activator.CreateInstance(typeof(Logging.CrossDomainChildLoggingSetup));
            loggingSetup.ConfigureAppender(parentAppender);
        }

        static log4net.Core.Level TranslateLogLevel(string level)
        {
            switch (level.Trim().ToUpper())
            {
                case "INFO":
                    return log4net.Core.Level.Info;
                case "DEBUG":
                    return log4net.Core.Level.Debug;
                case "ERROR":
                    return log4net.Core.Level.Error;
                case "FATAL":
                    return log4net.Core.Level.Fatal;
                case "ALL":
                    return log4net.Core.Level.All;
                case "ALERT":
                    return log4net.Core.Level.Alert;
                case "CRITIAL":
                    return log4net.Core.Level.Critical;
                case "EMERGENCY":
                    return log4net.Core.Level.Emergency;
                case "FINE":
                    return log4net.Core.Level.Fine;
                case "FINER":
                    return log4net.Core.Level.Finer;
                case "FINEST":
                    return log4net.Core.Level.Finest;
                case "NOTICE":
                    return log4net.Core.Level.Notice;
                case "OFF":
                    return log4net.Core.Level.Off;
                case "SEVERE":
                    return log4net.Core.Level.Severe;
                case "TRACE":
                    return log4net.Core.Level.Trace;
                case "VERBOSE":
                    return log4net.Core.Level.Verbose;
                case "WARN":
                    return log4net.Core.Level.Warn;

                default:
                    return log4net.Core.Level.Debug;
            }
        }

        public void LoadPackage(string packagePath)
        {
            if (archive != null)
            {
                archive.Close();
                archive = null;
            }

            archive = new ZipFile(packagePath);

            ResolveEventHandler resolveHandler = new ResolveEventHandler((sender, e) => {
                
                string[] filename = e.Name.Split(',');

                var currentAssemblies = AppDomain.CurrentDomain.GetAssemblies();
                var asx = (from a in currentAssemblies where a.GetName().Name == filename[0] select a).FirstOrDefault();
                if (asx != null)
                    return asx;

                var entry = archive.GetEntry(filename[0] + ".dll");
                if (entry == null)
                {
                    return null;
                }

                byte[] buffer = LoadFromArchive(archive, entry);

                Assembly assembly = Assembly.Load(buffer);
                return assembly;
            });

            AppDomain.CurrentDomain.AssemblyResolve += resolveHandler;

            foreach (ZipEntry entry in archive)
            {
                if (!entry.Name.EndsWith(".dll"))
                    continue;

                //redirect to use the most recent version of the assemblies shared with the DMC client
                byte[] buffer;
                if (string.Equals(entry.Name, "Lpp.Dns.DataMart.Model.Interface.dll"))
                {
                    buffer = System.IO.File.ReadAllBytes("Lpp.Dns.DataMart.Model.Interface.dll");
                }
                else if (string.Equals(entry.Name, "log4net.dll"))
                {
                    buffer = System.IO.File.ReadAllBytes("log4net.dll");
                }
                else if (string.Equals(entry.Name, "ICSharpCode.SharpZipLib.dll"))
                {
                    buffer = System.IO.File.ReadAllBytes("ICSharpCode.SharpZipLib.dll");
                }
                else if (string.Equals(entry.Name, "Lpp.Dns.DataMart.Client.DomainManger.dll"))
                {
                    buffer = System.IO.File.ReadAllBytes("Lpp.Dns.DataMart.Client.DomainManger.dll");
                }
                else
                {
                    buffer = LoadFromArchive(archive, entry);
                }

                Assembly.Load(buffer);
            }
        }

        public Lpp.Dns.DataMart.Model.IModelProcessor GetProcessor(Guid processorID)
        {
            var processorTypes = (from a in AppDomain.CurrentDomain.GetAssemblies()
                                  from t in a.GetLoadableTypes()
                                  let interfaces = t.GetInterfaces().DefaultIfEmpty()
                                 where interfaces.Any(i => i == typeof(Lpp.Dns.DataMart.Model.IModelProcessor) || i == typeof(Lpp.Dns.DataMart.Model.IEarlyInitializeModelProcessor))
                                 && t.GetConstructor(Type.EmptyTypes) != null
                                 && !t.IsInterface
                                 && t != typeof(ProxyModelProcessor) && t != typeof(ProxyModelProcessorWithEarlyInitialize)
                                 select interfaces.Any(i => i == typeof(Model.IEarlyInitializeModelProcessor)) ? Activator.CreateInstance(t) as Model.IEarlyInitializeModelProcessor : Activator.CreateInstance(t) as Lpp.Dns.DataMart.Model.IModelProcessor).ToArray();

            var processor = processorTypes.FirstOrDefault(p => p.ModelProcessorId == processorID);
            if (processor == null)
                return null;

            if(processor is Model.IEarlyInitializeModelProcessor)
            {
                return new ProxyModelProcessorWithEarlyInitialize((Model.IEarlyInitializeModelProcessor)processor);
            }

            return new ProxyModelProcessor(processor);
        }

        public IEnumerable<string> LoadedAssemblyNames()
        {
            string[] names = AppDomain.CurrentDomain.GetAssemblies().Select(a => a.FullName + ": " + a.Location).ToArray();
            return names;
        }

        public void Close()
        {
            if (archive != null)
            {
                archive.Close();
                archive = null;
            }
        }

        static byte[] LoadFromArchive(ZipFile archive, ZipEntry entry)
        {
            byte[] buffer = new byte[entry.Size];
            using (var stream = archive.GetInputStream(entry))
            {
                stream.Read(buffer, 0, buffer.Length);
            }
            return buffer;
        }

    }
}
