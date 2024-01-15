drop proc if exists proc_DangNhap
GO
create proc  proc_DangNhap @username char(255) , @password char(255)
As
Begin
	-- Kiem tra ton tai tai khong trong he thong hay khong 
	Waitfor Delay '00:00:3';
	
	Select * from Account where username = @username and password = @password
	and accountType != 'Lock'
End 

Go
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