drop proc if exists proc_ThemLichLamViec
GO 
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
Go
drop proc if exists proc_TimBacSiRanh
GO
create proc proc_TimBacSiRanh
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