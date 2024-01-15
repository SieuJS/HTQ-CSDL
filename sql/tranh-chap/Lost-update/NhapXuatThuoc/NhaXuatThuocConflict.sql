drop proc if exists proc_XuatThuocConflict
GO
create proc proc_XuatThuocConflict
@medicalRecId int ,@drugId int, @quantity int 
AS 
BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	if not exists (select * from Drug Where drugId = @drugId ) 
	begin 
		return;
	end
	declare @currentInstock int = 
	(select stockNumber from Drug Where drugId = @drugID);
	declare @newStock int = @currentInstock - @quantity;
	Begin try 
		Begin Tran
		Insert into patientDrugs values (@medicalRecId, @drugId, @quantity);  
		Update Drug set stockNumber = @newStock where drugId = @drugID;
		Commit Tran;
	End Try
	Begin Catch 
		Print Error_Number();
		Print Error_Message();
		Rollback Tran;
	End Catch
END

drop proc if exists proc_NhapKhoThuoc
GO
create proc proc_NhapKhoThuoc 
@drugID int , @addNumber int 
AS 
Begin 
	-- kiem tra ton tai cua id thuoc
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	if not exists (select * from Drug Where drugId = @drugId ) 
	begin 
		return;
	end
	declare @currentInstock int = 
	(select stockNumber from Drug Where drugId = @drugID);
	declare @newStock int = @currentInstock + @addNumber;
	Begin try 
		Begin Tran;
		WAITFOR DELAY '00:00:05';
		Update Drug set stockNumber = @newStock where drugId = @drugID;
		Commit Tran;
	End Try
	Begin Catch 
		Print Error_Number();
		Print Error_Message();
		Rollback Tran;
	End Catch
End