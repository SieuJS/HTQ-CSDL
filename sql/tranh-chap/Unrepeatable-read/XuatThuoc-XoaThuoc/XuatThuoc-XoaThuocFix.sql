drop proc if  exists proc_XuatThuoc
GO
create Proc [dbo].[proc_XuatThuoc]
@medicalRecId int ,@drugId int, @quantity int 
AS 
BEGIN 
	if not exists (select * from Drug Where drugId = @drugId ) 
	begin 
		return 1;
	end
	Begin Tran
		if exists ( select * from patientDrugs Where drugId = @drugId 
		and medicalRecordId = @medicalRecId )
		Begin
			Print 'Khong the them'
			Return 1
		End
		
		declare @currentInstock int = 
		(select d.stockNumber from Drug d with (UPDLOCK)   Where d.drugId = @drugID );
		declare @newStock int = @currentInstock - @quantity;
		if (@newStock < 0 ) 
		Begin
			Print 'Khong du thuoc';
			Rollback tran
			Return 1
		End
		Begin try 
			
			Insert into patientDrugs values (@medicalRecId, @drugId, @quantity);
			WAITFOR DELAY '00:00:03';
			Update Drug set stockNumber = @newStock where drugId = @drugID;
			select * from patientDrugs Where drugId = @drugId and  medicalRecordId = @medicalRecId
		End Try
		Begin Catch 
			Print Error_Number();
			Print Error_Message();
			Rollback Tran;
			Return 1
		End Catch
	Commit Tran;
END
Go

Drop proc if exists proc_XoaThuoc 
GO
create proc proc_XoaThuoc
@drugId char(255)
As 
Begin
	Delete patientDrugs 
	Where drugId = @drugId

	Delete from Drug
	Where drugId = @drugId
End 
Go