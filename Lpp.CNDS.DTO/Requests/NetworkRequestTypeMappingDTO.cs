﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using Lpp.Objects;

namespace Lpp.CNDS.DTO
{
    [DataContract]
    public class NetworkRequestTypeMappingDTO : EntityDtoWithID
    {
        [DataMember]
        public Guid NetworkID { get; set; }
        [DataMember]
        public string Network { get; set; }
        [DataMember]
        public Guid ProjectID { get; set; }
        [DataMember]
        public string Project { get; set; }
        [DataMember]
        public Guid RequestTypeID { get; set; }
        [DataMember]
        public string RequestType { get; set; }
        [DataMember]
        public IEnumerable<NetworkRequestTypeDefinitionDTO> Routes { get; set; }
        
    }
}
