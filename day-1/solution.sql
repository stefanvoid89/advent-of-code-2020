--part 1
select distinct b.num * q.num  from numbers b cross apply (select * from numbers bb where bb.num + b.num = 2020)q

--part 2
select distinct b.num * bb.num  * bbb.num from numbers b 
cross join numbers bb
cross join numbers bbb
where b.num + bb.num  + bbb.num = 2020