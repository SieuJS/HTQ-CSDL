
insert into Drug values (  'C', 'D', '1-1-2023', 'C', '100' ,'2')



declare @drugId int;
set @drugId = (select top 1 drugId from Drug Order by drugId desc)

--select * from drug where drugId = @drugId

exec proc_XuatThuoc '2', @drugId, '1';

select * from drug

select * from patientDrugs