﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Lpp.Dns.DTO.Enums
{
    /// <summary>
    /// The Type of Document for DataMarts
    /// </summary>
    [DataContract]
    public enum RequestDocumentType
    {
        /// <summary>
        /// Input is the Doucments for the DataMart to Consume 
        /// </summary>
        [DataMember]
        Input = 0,
        /// <summary>
        /// Output is the Documents for the DataMarts Response
        /// </summary>
        [DataMember]
        Output = 1
    }
}
