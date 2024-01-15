drop proc if exists proc_DangNhapConflict
drop proc if exists proc_DoiMatKhauConflict

create proc  proc_DangNhapConflict @username char(255) , @password char(255)
As
Begin
	-- Kiem tra ton tai tai khong trong he thong hay khong 
	IF (not exists (Select * from Account 
	Where username = @username and password = @password))
	Return 1
	Waitfor Delay '00:00:10';
	
	Select * from Account where username = @username and password = @password
End 
GO

create proc proc_DoiMatKhauConflict
@username char(255) , 
@oldpass char(255),
@newpass char(255)
As 
Begin 
	If not exists (select * from Account 
	Where username = @username and password = @oldpass)
	Return 1 
	Update Account 
		Set password = @newpass 
		where username = @username
End 
GO 

-- Giai quyet : Trong dang nhap thi rut lai con 1 giao tac

create proc proc_XuatThuocConflict
@medicalRecId int ,@drugId int, @quantity int 
AS 
BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
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

-- giai quyet : set isolate lever  read committed

-- Loi dirty read 
create proc proc_TimBacSiRanhConflict
@appointmentDate date,
@appointmentTime time(7)
As 
Begin	
	Set transaction isolation level read uncommitted
	SELECT d.dentistUserName, d.dentistFullName
	FROM Dentist d JOIN workSchedule ws ON d.dentistUserName = ws.dentistUserName
	WHERE ws.workingDate = @appointmentDate
		AND ws.startTime <= @appointmentTime
		AND ws.endTime > @appointmentTime
		AND ws.busyStatus = 'Free'
End 
GO
-- giai quyet : set isolate level read commited