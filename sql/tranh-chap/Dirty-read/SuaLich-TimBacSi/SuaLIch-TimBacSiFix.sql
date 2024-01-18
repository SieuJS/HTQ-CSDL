drop proc if exists proc_SuaLichHen
GO
create proc proc_SuaLichHen
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
GO
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