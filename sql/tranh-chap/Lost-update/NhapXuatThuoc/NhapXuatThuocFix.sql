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
	Begin Tran;
		declare @currentInstock int = 
		(select stockNumber from Drug WITH (UPDLOCK) Where drugId = @drugID );
		declare @newStock int = @currentInstock + @addNumber;
		WAITFOR DELAY '00:00:05';
		Update Drug set stockNumber = @newStock where drugId = @drugID
	Commit Tran;
End
GO
drop proc if exists proc_XuatThuoc
GO
create proc proc_XuatThuoc
@medicalRecId int ,@drugId int, @quantity int 
AS 
BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	if not exists (select * from Drug Where drugId = @drugId ) 
	begin 
		return 1;
	end
	Begin Tran
	declare @currentInstock int = 
	(select stockNumber from Drug WITH (UPDLOCK) Where drugId = @drugID );
	declare @newStock int = @currentInstock - @quantity;
	Begin try 
		WAITFOR DELAY '00:00:03';
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
