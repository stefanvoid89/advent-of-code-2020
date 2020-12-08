--part1
declare @ins char(3), @val int, @id int = 1, @acc int = 0
declare @t table (ins char(3), val int ,id int)
set nocount on
while 1=1 begin
if exists ( select 1 from @t where id = @id) begin
select  'acc value is ' + cast(@acc as char(5))
break
end
insert into @t(ins,val,id) select ins,val,id from instructions where id = @id
select @ins = ins, @val = val  from instructions where id = @id
if(@ins = 'acc') begin 
set @id = @id + 1 
set @acc = @acc + @val
end 
else if (@ins = 'jmp') set @id = @id + @val
else set @id = @id + 1 
end


go

--part2

SET NOCOUNT ON
declare @ins char(3), @val int, @id int = 1, @acc int = 0, @c_id int,@break int = 0
declare @t table (ins char(3), val int ,id int)
declare @x table (ins char(3), val int ,id int)


declare @count int

declare c cursor for 
select id from instructions where ins <> 'acc' 
order by id
open c
fetch next from c into @c_id
while @@FETCH_STATUS = 0 and @break = 0 begin

delete from @t
delete from @x
select @id = 1,@acc = 0

insert into @x select * from instructions order by id
update @x set 	ins = case when ins = 'jmp' then 'nop' 
	when ins = 'nop' then 'jmp' else ins end where id = @c_id

while 1=1 begin
if not exists (select 1 from @x where id = @id +1)begin
select  'acc value is ' + cast(@acc as char(5))
select @break = 1
break
end
if exists ( select 1 from @t where id = @id) break
select @ins = ins , @val = val  from @x where id = @id
insert into @t(ins,val,id) select @ins,@val,@id 
if(@ins = 'acc') begin 
set @id = @id + 1 
set @acc = @acc + @val
end 
else if (@ins = 'jmp') set @id = @id + @val
else set @id = @id + 1 
end


fetch next from c into @c_id
end
close c
deallocate c