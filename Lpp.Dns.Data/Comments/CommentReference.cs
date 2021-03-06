﻿using Lpp.Dns.DTO.Enums;
using Lpp.Objects;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lpp.Dns.Data
{
    [Table("CommentReferences")]
    public class CommentReference : Entity
    {
        [Key, Column(Order = 1)]
        public Guid CommentID { get; set; }
        public virtual Comment Comment {get; set;}

        [Key, Column(Order = 2)]
        public Guid ItemID { get; set; }

        public string ItemTitle {get; set;}

        public CommentItemTypes Type {get; set;}
    }
}
