drop proc if exists proc_DangNhap
GO
create proc  proc_DangNhap @username char(255) , @password char(255)
As
Begin
	-- Kiem tra ton tai tai khong trong he thong hay khong 
	Begin tran
	
	IF (not exists (Select * from Account  with (UPDLOCK)
	Where username = @username and password = @password))
	Begin
		Print 'Tai khoan khong dung'
		Rollback tran
		Return 1
	End
	IF (not exists (Select * from Account  with (UPDLOCK)
	Where username = @username  and accountType != 'Lock'))
	Begin
		Print 'Tai khoan bi khoa'
		Rollback tran
		Return 1
	End
	Waitfor Delay '00:00:3';
	Select * from Account where username = @username and password = @password
	and accountType != 'Lock'
	Commit tran
End 
Go


drop proc if exists proc_DoiMatKhau
create proc proc_DoiMatKhau
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
