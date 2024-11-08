using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Reflection;
using Lpp.Dns.DataMart.Client.Forms;
namespace Lpp.Dns.DataMart.Client
{
    public partial class AboutForm : Form
    {
        public bool IsOKVisible
        {
            set
            {
                button1.Visible = value;
            }

            get
            {
                return button1.Visible;
            }
        }

        public bool IsStartingUpVisible
        {
            set
            {
                lblStartingUp.Visible = value;
            }

            get
            {
                return lblStartingUp.Visible;
            }
        }

        public AboutForm()
        {
            InitializeComponent();
        }

        private void AboutForm_Load(object sender, EventArgs e)
        {
            lblVersion.Text = Application.ProductVersion;
            lblArch.Text = GetArchitecture();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        /// <summary>
        /// Determines the architecture of the running application's main assembly.
        /// Equivalent to invoking the command "corflags".
        /// </summary>
        /// <returns></returns>
        private string GetArchitecture()
        {
            Assembly assembly = Assembly.GetExecutingAssembly();
            PortableExecutableKinds kinds;
            ImageFileMachine imgFileMachine;
            assembly.ManifestModule.GetPEKind(out kinds, out imgFileMachine);
            return (kinds & PortableExecutableKinds.PE32Plus) > 0 ? "64-bit" : (kinds & PortableExecutableKinds.Required32Bit) > 0 ? "32-bit" : "Any CPU";
        }

        public String LogFilePath { get; set; }
        public String LogLevel { get; set; }
        public String DataMartClientId { get; set; }
 
        private void btnDebug_Click(object sender, EventArgs e)
        {
            DebugForm debugDialog = new DebugForm();
            debugDialog.LogLevel = LogLevel;
            debugDialog.LogFilePath = LogFilePath;
            debugDialog.DataMartClientId = DataMartClientId;
            if (debugDialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                LogLevel = debugDialog.LogLevel;
                LogFilePath = debugDialog.LogFilePath;
            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            System.Diagnostics.Process.Start("http://www.popmednet.org");
        }

        private void btnManagePackages_Click(object sender, EventArgs e)
        {
            using (var frm = new DeletePackagesForm())
            {
                frm.ShowDialog(this);
            }
        }
 
    }
}