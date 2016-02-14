update t set 
  t.IsActive = 1
from dbo.country as t
where t.Name in ('Dominican Republic', 'Iceland','India','North Korea','Russia','Thailand','Ukraine','Colombia','Japan','Iran','Norway','Germany','','','','','','','','','','','','',)
select * from dbo.Country as c