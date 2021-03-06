if exists( select * from sys.views where OBJECT_ID = object_id('Security_Tuple1')) drop view Security_Tuple1
if exists( select * from sys.views where OBJECT_ID = object_id('__Security_Tuple1')) drop view __Security_Tuple1
if exists( select * from sys.views where OBJECT_ID = object_id('_Security_Tuple1')) drop view _Security_Tuple1
if exists( select * from sys.views where OBJECT_ID = object_id('Security_Tuple2')) drop view Security_Tuple2
if exists( select * from sys.views where OBJECT_ID = object_id('__Security_Tuple2')) drop view __Security_Tuple2
if exists( select * from sys.views where OBJECT_ID = object_id('_Security_Tuple2')) drop view _Security_Tuple2
if exists( select * from sys.views where OBJECT_ID = object_id('Security_Tuple3')) drop view Security_Tuple3
if exists( select * from sys.views where OBJECT_ID = object_id('__Security_Tuple3')) drop view __Security_Tuple3
if exists( select * from sys.views where OBJECT_ID = object_id('_Security_Tuple3')) drop view _Security_Tuple3
if exists( select * from sys.views where OBJECT_ID = object_id('Security_Tuple4')) drop view Security_Tuple4
if exists( select * from sys.views where OBJECT_ID = object_id('__Security_Tuple4')) drop view __Security_Tuple4
if exists( select * from sys.views where OBJECT_ID = object_id('_Security_Tuple4')) drop view _Security_Tuple4
if exists( select * from sys.views where OBJECT_ID = object_id('Security_Tuple5')) drop view Security_Tuple5
if exists( select * from sys.views where OBJECT_ID = object_id('__Security_Tuple5')) drop view __Security_Tuple5
if exists( select * from sys.views where OBJECT_ID = object_id('_Security_Tuple5')) drop view _Security_Tuple5
if exists( select * from sys.tables where OBJECT_ID = object_id('_Security_Ten')) drop table _Security_Ten
if exists( select * from sys.tables where OBJECT_ID = object_id('_Security_SecurityObjectsColumns')) drop table _Security_SecurityObjectsColumns
if exists( select * from sys.tables where OBJECT_ID = object_id('_Security_Ten')) drop table _Security_Ten
go

if exists( select * from sys.triggers where parent_id = object_id('SecurityObjects') and name='SecurityObjects_MakeCopy_Insert' ) drop trigger SecurityObjects_MakeCopy_Insert
if exists( select * from sys.triggers where parent_id = object_id('SecurityObjects') and name='SecurityObjects_MakeCopy_Update' ) drop trigger SecurityObjects_MakeCopy_Update
if exists( select * from sys.triggers where parent_id = object_id('SecurityObjects') and name='SecurityObjects_MakeCopy_Delete' ) drop trigger SecurityObjects_MakeCopy_Delete
go

if exists( select * from sys.triggers where parent_id = object_id('SecurityObjects') and name='SecurityObjects_Insert' ) drop trigger SecurityObjects_Insert
if exists( select * from sys.triggers where parent_id = object_id('SecurityObjects') and name='SecurityObjects_Update' ) drop trigger SecurityObjects_Update
if exists( select * from sys.triggers where parent_id = object_id('SecurityObjects') and name='SecurityObjects_Delete' ) drop trigger SecurityObjects_Delete
go

if exists( select * from sys.views where object_id = object_id( '_vwSecurityObjectsWithParents') ) drop view _vwSecurityObjectsWithParents
go

if exists( select * from sys.tables where object_id = object_id('SecurityObjects2') ) drop table SecurityObjects2
go

if exists( select * from sys.triggers where name = 'SecurityTargets_MakeSureObjectsExist' and parent_id = object_id('SecurityTargets') )
	drop trigger SecurityTargets_MakeSureObjectsExist
go

if exists( select * from sys.procedures where object_id = object_id('SecurityObjects_InitializeIndexesForInserted') )
	drop proc SecurityObjects_InitializeIndexesForInserted
go

if exists( select * from sys.procedures where object_id = object_id('SecurityObjects_NullOutHive') )
	drop proc SecurityObjects_NullOutHive
go

if exists( select * from sys.procedures where object_id = object_id('SecurityObjects_ShiftIndexesAfterHiveDeletion') )
	drop proc SecurityObjects_ShiftIndexesAfterHiveDeletion
go

create table SecurityObjects2( Id uniqueidentifier not null, LeftIndex int, RightIndex int, TreeTag uniqueidentifier )
go

create clustered index TreeTag on securityobjects2(TreeTag, LeftIndex desc)
create unique index securityobjects2_PK_IX on securityobjects2(Id)
go

alter table SecurityObjects2 add constraint SecurityObjects2_PK primary key(Id)
go

insert into SecurityObjects2( Id, LeftIndex, RightIndex, TreeTag ) select Id, LeftIndex, RightIndex, TreeTag from SecurityObjects
go

CREATE procedure [SecurityObjects_InitializeIndexesForInserted] as
	-- Repeat the following until all inserted nodes are assigned a tree tag and indexes
	while 1 = 1 begin

		-- Get one object that has a child which is not assigned a tree yet
		declare @parentId uniqueidentifier, @parentTree uniqueidentifier, @parentRightIndex int; set @parentId = null
		select top 1 @parentId = p.Id, @parentTree = p.TreeTag, @parentRightIndex = p.RightIndex
		from SecurityObjects i inner join SecurityObjects p on i.ParentId = p.Id
		where i.TreeTag is null and p.TreeTag is not null

		if @parentId is null return -- Didn't find any such objects => the end

		-- "shift" right indexes of all nodes to the right of the current parent (including the parent itself)
		declare @childrenCount int
		select @childrenCount = COUNT(*) from SecurityObjects where ParentId = @parentId and TreeTag is null
		update SecurityObjects set 
			RightIndex = RightIndex + @childrenCount*2,
			LeftIndex = case when LeftIndex >= @parentRightIndex then LeftIndex + @childrenCount*2 else LeftIndex end
		where RightIndex >= @parentRightIndex and TreeTag = @parentTree
		update SecurityObjects2 set 
			RightIndex = RightIndex + @childrenCount*2,
			LeftIndex = case when LeftIndex >= @parentRightIndex then LeftIndex + @childrenCount*2 else LeftIndex end
		where RightIndex >= @parentRightIndex and TreeTag = @parentTree

		-- Set indexes and tree tag for all just-inserted children of the current parent
		update SecurityObjects
		set LeftIndex = @parentRightIndex + [index]*2, RightIndex = @parentRightIndex + [index]*2 + 1, TreeTag = @parentTree
		from (
			select Id, (row_number() over (order by Id)) - 1 as [index]
			from SecurityObjects
			where ParentId = @parentId and TreeTag is null
		) i
		where i.Id = SecurityObjects.Id

		update SecurityObjects2
		set LeftIndex = @parentRightIndex + [index]*2, RightIndex = @parentRightIndex + [index]*2 + 1, TreeTag = @parentTree
		from (
			select Id, (row_number() over (order by Id)) - 1 as [index]
			from SecurityObjects
			where ParentId = @parentId and TreeTag is null
		) i
		where i.Id = SecurityObjects2.Id
	end
GO

create procedure [SecurityObjects_NullOutHive]
	@tree uniqueidentifier,
	@li int, @ri int
as
	update SecurityObjects set TreeTag = null
	where TreeTag = @tree and LeftIndex between @li and @ri
	update SecurityObjects2 set TreeTag = null
	where TreeTag = @tree and LeftIndex between @li and @ri
GO

create procedure [SecurityObjects_ShiftIndexesAfterHiveDeletion] 
	@tree uniqueidentifier,
	@li int, @ri int
as
	-- "Shift" indexes of all nodes to the right of this deleted node
	update SecurityObjects 
	set 
		RightIndex = RightIndex - (@ri-@li+1),
		LeftIndex = case when LeftIndex < @li then LeftIndex else LeftIndex - (@ri-@li+1) end
	where RightIndex > @ri and TreeTag = @tree
	update SecurityObjects2
	set 
		RightIndex = RightIndex - (@ri-@li+1),
		LeftIndex = case when LeftIndex < @li then LeftIndex else LeftIndex - (@ri-@li+1) end
	where RightIndex > @ri and TreeTag = @tree
GO

CREATE trigger [SecurityObjects_Update] on [SecurityObjects] after update as
	if not update(ParentId) return -- This should prevent recursion
	declare @dummy uniqueidentifier; set @dummy = [dbo].[NewSqlGuid]()

	declare c cursor for 
		select i.Id, i.ParentId, d.ParentId, d.LeftIndex, d.RightIndex, d.TreeTag
		from inserted i inner join deleted d on i.Id = d.Id
		where isnull( i.ParentId, @dummy ) <> isnull( d.ParentId, @dummy )
	open c

	declare @id uniqueidentifier, @newParentId uniqueidentifier, @oldParentId uniqueidentifier, @li int, @ri int, @tree uniqueidentifier
	fetch next from c into @id, @newParentId, @oldParentId, @li, @ri, @tree
	while @@fetch_status = 0 begin

		declare @oldTree uniqueidentifier; select @oldTree = TreeTag from SecurityObjects where Id = @oldParentId
		declare @newTree uniqueidentifier, @newParentRi int
		select @newTree = TreeTag, @newParentRi = RightIndex from SecurityObjects where Id = @newParentId

		if @newParentId is null -- The object has been moved out of a tree to become its own tree
		begin
			set @newTree = [dbo].[NewSqlGuid]()
			update SecurityObjects set TreeTag = @newTree, LeftIndex = LeftIndex - @li, RightIndex = RightIndex - @li
			where TreeTag = @tree and LeftIndex between @li and @ri
			update SecurityObjects2 set TreeTag = @newTree, LeftIndex = LeftIndex - @li, RightIndex = RightIndex - @li
			where TreeTag = @tree and LeftIndex between @li and @ri

			update SecurityObjects set 
				LeftIndex = case when LeftIndex >= @ri then LeftIndex - (@ri-@li+1) else LeftIndex end,
				RightIndex = RightIndex - (@ri-@li+1)
			where RightIndex > @ri and TreeTag = @tree
			update SecurityObjects2 set 
				LeftIndex = case when LeftIndex >= @ri then LeftIndex - (@ri-@li+1) else LeftIndex end,
				RightIndex = RightIndex - (@ri-@li+1)
			where RightIndex > @ri and TreeTag = @tree

		end else begin 
			-- The object has been moved into a tree OR
		    -- The object has been moved between trees OR
		    -- The object has been moved to a new location within the same tree
			exec SecurityObjects_NullOutHive @tree, @li, @ri
			if @oldParentId is not null exec SecurityObjects_ShiftIndexesAfterHiveDeletion @oldTree, @li, @ri
			exec SecurityObjects_InitializeIndexesForInserted

		end

		fetch next from c into @id, @newParentId, @oldParentId, @li, @ri, @tree
	end
	
	close c
	deallocate c
GO

create trigger [SecurityObjects_Insert] on [SecurityObjects] after insert as

	update SecurityObjects set LeftIndex = 0, RightIndex = 1, TreeTag = [dbo].[NewSqlGuid]()
	where Id in (select Id from inserted) and ParentId is null

	update SecurityObjects set TreeTag = null
	where Id in (select Id from inserted) and ParentId is not null

	exec SecurityObjects_InitializeIndexesForInserted

	insert into SecurityObjects2(Id, LeftIndex, RightIndex, TreeTag) 
	select Id, LeftIndex, RightIndex, TreeTag from SecurityObjects
	where Id in (select Id from inserted)
GO

create trigger [SecurityObjects_Delete] on [SecurityObjects] after delete as
	declare c cursor for select Id, RightIndex, LeftIndex, TreeTag from deleted
	open c

	declare @id uniqueidentifier, @ri int, @li int, @tree uniqueidentifier
	fetch next from c into @id, @ri, @li, @tree
	while @@fetch_status = 0 begin

		exec SecurityObjects_ShiftIndexesAfterHiveDeletion @tree, @li, @ri

		-- In case the deleted node had any children, make each of them a new hive with new tag
		-- and shift their indexes to make them start at zero
		update SecurityObjects 
		set TreeTag = newTree, LeftIndex = LeftIndex - c.diff, RightIndex = RightIndex - c.diff
		from (
			select c.Id, p.newTree, p.LeftIndex-1 as diff
			from SecurityObjects c
			inner join ( select *, [dbo].[NewSqlGuid]() as newTree from SecurityObjects p where p.ParentId = @id ) p
			on c.TreeTag = @tree and c.LeftIndex between p.LeftIndex and p.RightIndex
		) c
		where c.Id = SecurityObjects.Id

		fetch next from c into @id, @ri, @li, @tree
	end

	close c
	deallocate c

	delete from SecurityObjects2 where Id in (select Id from deleted)
GO

create view _vwSecurityObjectsWithParents
with schemabinding
as
select o.Id, p.Id as ParentId, p.LeftIndex as ParentLeftIndex
from dbo.SecurityObjects o
inner join dbo.SecurityObjects2 p on o.LeftIndex between p.LeftIndex and p.RightIndex and o.TreeTag = p.TreeTag
go

create unique clustered index _vwSecurityObjectsWithParents_PK on _vwSecurityObjectsWithParents(ParentId, Id, ParentLeftIndex)
go

create view Security_Tuple1
as
select 
	Id1, ParentId1,
	SubjectId, PrivilegeId, Allow
from
(
	select 
		o1.Id as Id1, 
		o1.ParentId as ParentId1,
		PrivilegeId, SubjectId, Allow,
		row_number() over( 
			partition by o1.Id, PrivilegeId, SubjectId 
			order by o1.ParentLeftIndex desc, [Order]) 
		as SortedIndex
	from _vwAclEntries e with(noexpand)
	inner join _vwSecurityObjectsWithParents o1 with(noexpand) on e.ObjectId1 = o1.ParentId
	where e.Arity = 1
) x
where SortedIndex = 1
go

create view Security_Tuple2
as
select 
	Id1, Id2, ParentId1, ParentId2,
	SubjectId, PrivilegeId, Allow
from
(
	select 
		o1.Id as Id1, o2.Id as Id2, 
		o1.ParentId as ParentId1, o2.ParentId as ParentId2,
		PrivilegeId, SubjectId, Allow,
		row_number() over( 
			partition by o1.Id, o2.Id, PrivilegeId, SubjectId 
			order by o1.ParentLeftIndex desc, o2.ParentLeftIndex desc, [Order]) 
		as SortedIndex
	from _vwAclEntries e with(noexpand)
	inner join _vwSecurityObjectsWithParents o1 with(noexpand) on e.ObjectId1 = o1.ParentId
inner join _vwSecurityObjectsWithParents o2 with(noexpand) on e.ObjectId2 = o2.ParentId
	where e.Arity = 2
) x
where SortedIndex = 1
go

create view Security_Tuple3
as
select 
	Id1, Id2, Id3, ParentId1, ParentId2, ParentId3,
	SubjectId, PrivilegeId, Allow
from
(
	select 
		o1.Id as Id1, o2.Id as Id2, o3.Id as Id3, 
		o1.ParentId as ParentId1, o2.ParentId as ParentId2, o3.ParentId as ParentId3,
		PrivilegeId, SubjectId, Allow,
		row_number() over( 
			partition by o1.Id, o2.Id, o3.Id, PrivilegeId, SubjectId 
			order by o1.ParentLeftIndex desc, o2.ParentLeftIndex desc, o3.ParentLeftIndex desc, [Order]) 
		as SortedIndex
	from _vwAclEntries e with(noexpand)
	inner join _vwSecurityObjectsWithParents o1 with(noexpand) on e.ObjectId1 = o1.ParentId
inner join _vwSecurityObjectsWithParents o2 with(noexpand) on e.ObjectId2 = o2.ParentId
inner join _vwSecurityObjectsWithParents o3 with(noexpand) on e.ObjectId3 = o3.ParentId
	where e.Arity = 3
) x
where SortedIndex = 1
go

create view Security_Tuple4
as
select 
	Id1, Id2, Id3, Id4, ParentId1, ParentId2, ParentId3, ParentId4,
	SubjectId, PrivilegeId, Allow
from
(
	select 
		o1.Id as Id1, o2.Id as Id2, o3.Id as Id3, o4.Id as Id4, 
		o1.ParentId as ParentId1, o2.ParentId as ParentId2, o3.ParentId as ParentId3, o4.ParentId as ParentId4,
		PrivilegeId, SubjectId, Allow,
		row_number() over( 
			partition by o1.Id, o2.Id, o3.Id, o4.Id, PrivilegeId, SubjectId 
			order by o1.ParentLeftIndex desc, o2.ParentLeftIndex desc, o3.ParentLeftIndex desc, o4.ParentLeftIndex desc, [Order]) 
		as SortedIndex
	from _vwAclEntries e with(noexpand)
	inner join _vwSecurityObjectsWithParents o1 with(noexpand) on e.ObjectId1 = o1.ParentId
inner join _vwSecurityObjectsWithParents o2 with(noexpand) on e.ObjectId2 = o2.ParentId
inner join _vwSecurityObjectsWithParents o3 with(noexpand) on e.ObjectId3 = o3.ParentId
inner join _vwSecurityObjectsWithParents o4 with(noexpand) on e.ObjectId4 = o4.ParentId
	where e.Arity = 4
) x
where SortedIndex = 1
go

create view Security_Tuple5
as
select 
	Id1, Id2, Id3, Id4, Id5, ParentId1, ParentId2, ParentId3, ParentId4, ParentId5,
	SubjectId, PrivilegeId, Allow
from
(
	select 
		o1.Id as Id1, o2.Id as Id2, o3.Id as Id3, o4.Id as Id4, o5.Id as Id5, 
		o1.ParentId as ParentId1, o2.ParentId as ParentId2, o3.ParentId as ParentId3, o4.ParentId as ParentId4, o5.ParentId as ParentId5,
		PrivilegeId, SubjectId, Allow,
		row_number() over( 
			partition by o1.Id, o2.Id, o3.Id, o4.Id, o5.Id, PrivilegeId, SubjectId 
			order by o1.ParentLeftIndex desc, o2.ParentLeftIndex desc, o3.ParentLeftIndex desc, o4.ParentLeftIndex desc, o5.ParentLeftIndex desc, [Order]) 
		as SortedIndex
	from _vwAclEntries e with(noexpand)
	inner join _vwSecurityObjectsWithParents o1 with(noexpand) on e.ObjectId1 = o1.ParentId
inner join _vwSecurityObjectsWithParents o2 with(noexpand) on e.ObjectId2 = o2.ParentId
inner join _vwSecurityObjectsWithParents o3 with(noexpand) on e.ObjectId3 = o3.ParentId
inner join _vwSecurityObjectsWithParents o4 with(noexpand) on e.ObjectId4 = o4.ParentId
inner join _vwSecurityObjectsWithParents o5 with(noexpand) on e.ObjectId5 = o5.ParentId
	where e.Arity = 5
) x
where SortedIndex = 1
go


create trigger SecurityTargets_MakeSureObjectsExist on SecurityTargets after insert, update
as
	declare @empty uniqueidentifier
	set @empty = '00000000-0000-0000-0000-000000000000'

			insert into SecurityObjects(Id,LeftIndex,RightIndex) 
		select distinct ObjectId1, 0, 0 from inserted where ObjectId1 <> @empty and ObjectId1 not in (select Id from SecurityObjects)
			insert into SecurityObjects(Id,LeftIndex,RightIndex) 
		select distinct ObjectId2, 0, 0 from inserted where ObjectId2 <> @empty and ObjectId2 not in (select Id from SecurityObjects)
			insert into SecurityObjects(Id,LeftIndex,RightIndex) 
		select distinct ObjectId3, 0, 0 from inserted where ObjectId3 <> @empty and ObjectId3 not in (select Id from SecurityObjects)
			insert into SecurityObjects(Id,LeftIndex,RightIndex) 
		select distinct ObjectId4, 0, 0 from inserted where ObjectId4 <> @empty and ObjectId4 not in (select Id from SecurityObjects)
			insert into SecurityObjects(Id,LeftIndex,RightIndex) 
		select distinct ObjectId5, 0, 0 from inserted where ObjectId5 <> @empty and ObjectId5 not in (select Id from SecurityObjects)
	go

declare @empty uniqueidentifier
set @empty = '00000000-0000-0000-0000-000000000000'
insert into SecurityObjects(Id,LeftIndex,RightIndex) 
select distinct ObjectId1, 0, 0 from securitytargets where ObjectId1 <> @empty and ObjectId1 not in (select Id from SecurityObjects)
insert into SecurityObjects(Id,LeftIndex,RightIndex) 
select distinct ObjectId2, 0, 0 from securitytargets where ObjectId2 <> @empty and ObjectId2 not in (select Id from SecurityObjects)
insert into SecurityObjects(Id,LeftIndex,RightIndex) 
select distinct ObjectId3, 0, 0 from securitytargets where ObjectId3 <> @empty and ObjectId3 not in (select Id from SecurityObjects)
insert into SecurityObjects(Id,LeftIndex,RightIndex) 
select distinct ObjectId4, 0, 0 from securitytargets where ObjectId4 <> @empty and ObjectId4 not in (select Id from SecurityObjects)
insert into SecurityObjects(Id,LeftIndex,RightIndex) 
select distinct ObjectId5, 0, 0 from securitytargets where ObjectId5 <> @empty and ObjectId5 not in (select Id from SecurityObjects)
go