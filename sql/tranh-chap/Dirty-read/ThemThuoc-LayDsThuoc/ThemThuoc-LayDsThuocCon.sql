drop proc if exists proc_ThemThuoc
GO
create proc proc_ThemThuoc
@drugName char(255), 
@unit char(255),
@indi char(255), 
@expire date, 
@stock int, 
@price int 
As 
Begin 
	Begin tran 
	INSERT INTO Drug (drugName, unit, indication, expiredDate, stockNumber, price)
  VALUES (@drugName, @unit, @indi, @expire, @stock, @price );
  WAITFOR DELAY '00:00:03';
  if DateDiff(day, GETDATE() , @expire) < 0
  Begin 
	Print 'Thuoc da het han'
	Rollback tran
	Return 1
  End
  Commit tran 
End 

drop proc if exists proc_LayDanhSachThuoc
go 
create proc proc_LayDanhSachThuoc
As
Begin 
	Select * from Drug with (NoLoCk);
End