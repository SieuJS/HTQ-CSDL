
-- unrepeatable 2 loi
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
	Return 0
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

drop proc if exists proc_KhoaTaiKhoan
GO
create proc proc_KhoaTaiKhoan
@username char(255)
As
Begin
	if not exists (select * from Account where username = @username)
	Begin 
		Print 'Tài khoản không tồn tại'
		Return 1
	End
	Update Account 
	Set accountType = 'Lock'
	Where username = @username
	Print 'Khoá thành công'
	Return 0;
End

create proc proc_KhoaTaiKhoan

-- Giai quyet : Trong dang nhap thi rut lai con 1 giao tac

-- lost update 1 loi 


-- giai quyet : set isolate lever  read committed

-- Loi dirty read 2 loi
drop if exists proc_ThemLichLamViec
create proc proc_ThemLichLamViec 
@dentistUsername char(30),
@workingDate date , 
@startTime time,
@endTime time
As 
Begin

		Begin tran
		insert workSchedule 
		values (@dentistUsername, @workingDate, @startTime, @endTime, 'Free');
		WAITFOR DELAY '00:00:05';
		if (cast(datediff(hh,cast(@startTime as datetime), cast(@endTime as datetime)) as int) > 8)
		Begin
			Print 'không thể làm việc hơn 8 tiếng'
			Rollback tran 
			Return 1
		End
		Commit tran
End 

drop proc if exists proc_SuaLichLamViec
create proc proc_SuaLichLamViec
@dentistUsername char(30),
@scheduleId int = NULL ,
@workingDate date , 
@startTime time,
@endTime time,
@busyStatus char(10)  =NULL
As 
Begin

		Begin tran
		Update workSchedule 
		Set workingDate = IsNull(@workingDate, workingDate ), 
			startTime = IsNull( @startTime , startTime),
			endTime = IsNull(@endTime , endTime), 
			busyStatus = IsNull(@busyStatus, busyStatus)
		Where dentistUserName = @dentistUsername and scheduleId = @scheduleId
		WAITFOR DELAY '00:00:05';
		if (cast(datediff(hh,cast(@startTime as datetime), cast(@endTime as datetime)) as int) > 8)
		Begin
			Print 'không thể làm việc hơn 8 tiếng'
			Rollback tran 
			Return 1
		End
		Commit tran
End 


drop proc if exists proc_TimBacSiRanhConflict
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

