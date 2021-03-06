IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[_vwAclEntries]')) DROP VIEW [dbo].[_vwAclEntries]
GO

set ansi_padding on
go

create view _vwAclEntries
with schemabinding
as 
	select t.Arity, t.ObjectId1, t.ObjectId2, t.ObjectId3, t.ObjectId4, t.ObjectId5, t.ObjectId6, t.ObjectId7, t.ObjectId8, t.ObjectId9, t.ObjectId10,
	       e.PrivilegeId, e.SubjectId, e.Allow, e.[Order], e.Id as EntryId
	from dbo.AclEntries e
	inner join dbo.SecurityTargets t
	on e.TargetId = t.Id
go
	
create unique clustered index ix on _vwAclEntries(
		Arity, 
		ObjectId1, ObjectId2, ObjectId3, ObjectId4, ObjectId5, ObjectId6, ObjectId7, ObjectId8, ObjectId9, ObjectId10,
		PrivilegeId, SubjectId, [Order], Allow, EntryId
		)
go