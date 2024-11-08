﻿using System;
using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace Lpp.CNDS.DTO
{
    [DataContract]
    public class NetworkTransferDTO
    {
        /// <summary>
        /// The ID of the Network
        /// </summary>
        [DataMember]
        public Guid ID { get; set; }
        /// <summary>
        /// Name
        /// </summary>
        [DataMember,Required, MaxLength(255)]
        public string Name { get; set; }
        /// <summary>
        /// The URL or The Network API
        /// </summary>
        [DataMember,MaxLength(450)]
        public string Url { get; set; }
        /// <summary>
        /// Gets or sets the url to the networks API.
        /// </summary>
        [DataMember, MaxLength(450)]
        public string ServiceUrl { get; set; }
        /// <summary>
        /// Gets or sets the username to use when accessing the API.
        /// </summary>
        [DataMember, MaxLength(80)]
        public string ServiceUserName { get; set; }
        /// <summary>
        /// Gets or sets the password to use when accessing the API.
        /// </summary>
        [DataMember, MaxLength(255)]
        public string ServicePassword { get; set; }
    }
}
