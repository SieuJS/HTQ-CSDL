declare @drugId int;
set @drugId = (select top 1 drugId from Drug Order by drugId desc)
 

 exec proc_XoaThuoc @drugId