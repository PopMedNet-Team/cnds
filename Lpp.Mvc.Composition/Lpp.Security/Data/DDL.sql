CREATE TABLE [SecurityTargets](
	[Id] [int] IDENTITY(1,1) primary key NOT NULL,
	[Arity] int not null default 1,
	[ObjectId1] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId2] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId3] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId4] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId5] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId6] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId7] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId8] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId9] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000',
	[ObjectId10] uniqueidentifier not null default '00000000-0000-0000-0000-000000000000'
)
GO
create index ix_1 on SecurityTargets(ObjectId1)
create index ix_2 on SecurityTargets(ObjectId2)
create index ix_3 on SecurityTargets(ObjectId3)
create index ix_4 on SecurityTargets(ObjectId4)
create index ix_5 on SecurityTargets(ObjectId5)
create index ix_6 on SecurityTargets(ObjectId6)
create index ix_7 on SecurityTargets(ObjectId7)
create index ix_8 on SecurityTargets(ObjectId8)
create index ix_9 on SecurityTargets(ObjectId9)
create index ix_10 on SecurityTargets(ObjectId10)
create index ix_arity on SecurityTargets(Arity)
go

CREATE TABLE [AclEntries](
	[Id] [int] IDENTITY(1,1) primary key nonclustered NOT NULL,
	[TargetId] [int] references SecurityTargets NOT NULL,
	[SubjectId] [uniqueidentifier] NOT NULL,
	[PrivilegeId] [uniqueidentifier] NOT NULL,
	[Order] [int] NOT NULL,
	[Allow] [bit] NOT NULL,
)
GO

CREATE CLUSTERED INDEX [AclEntries_TargetId] ON [dbo].[AclEntries]([TargetId])
GO

create trigger Security_Membership_EnsureAllSubjectsExist on AclEntries after update, insert as
	insert into SecurityMembership( [Start], [End] ) 
	select distinct [SubjectId], [SubjectId] from inserted i
	left join SecurityMembership m on [Start] = i.[SubjectId] and [End] = i.[SubjectId]
	where m.[Start] is null
go