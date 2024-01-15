drop proc if exists proc_ThemBacSi
GO
create proc proc_ThemBacSi
@fullName char(255), 
@username char(255) ,
@password char (255) 
As 
Begin 
	Begin tran
	Insert into Account Values (@username, @password, 'Dentist')
	Insert into Staff Values ( @fullName, @username , @password) 
	
	waitfor delay '00:00:03'
	if ( len(@password) < 6)
	Begin
		print 'Mat khau phai lon hon bang 6';
		rollback tran
	End 
	Commit tran
End 
Go
drop proc if exists proc_LayDanhSachBacSi
Go 
create proc proc_LayDanhSachBacSi
As 
BEgin 
SElect * from Dentist 
End 
