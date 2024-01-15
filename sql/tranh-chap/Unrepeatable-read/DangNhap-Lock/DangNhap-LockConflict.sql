
create proc  proc_DangNhapConflict @username char(255) , @password char(255)
As
Begin
	-- Kiem tra ton tai tai khong trong he thong hay khong 
	IF (not exists (Select * from Account 
	Where username = @username and password = @password and accountType != 'Lock'))
	Begin
		Print 'Tai khoan khong dung'
		Return 1
	End
	Waitfor Delay '00:00:3';
	
	Select * from Account where username = @username and password = @password
	and accountType != 'Lock'
End 

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