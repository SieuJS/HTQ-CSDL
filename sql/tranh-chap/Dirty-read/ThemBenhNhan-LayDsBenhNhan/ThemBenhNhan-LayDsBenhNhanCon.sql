USE [testConflict]
GO

drop proc if exists proc_TaoTaiKhoan
Go
create proc [dbo].[proc_TaoTaiKhoan] @username char(255) , 
@password char(255) , @type char(20) 
AS 
BEGIN 
		If (len(@password) < 6) 
		throw 51000, 'Password must longer than 5', 1
		Begin try
			Begin tran
			insert into Account(username, password, accountType)
			Values (@username , @password, @type);
			Commit tran;
		End try
		Begin catch
			Print N'Lỗi xảy ra khi đăng ký tài khoản: ';
			Print Error_message() ;
			Rollback tran
		End catch
END 

drop proc if exists proc_DangKyThongTinKhachHang
GO

create proc [dbo].[proc_DangKyThongTinKhachHang]
@phoneNum char(255) , 
@fullName char(255) , 
@password char(255), 
@Dob date , 
@address char(255)
as 
begin
	begin try
		-- create customer : 
		Begin tran 
		insert into Patient 
		values (@fullName , @phoneNum ,@password, @Dob, @address);

		-- tao tai
		WAITFOR DELAY '00:00:03';
		Begin try
		exec proc_TaoTaiKhoan @phoneNum , @password , 'Patient';
		End try
		Begin Catch
			Print @@Error;
			Rollback tran
			Return 1;
		End Catch
		commit tran

	end try
	begin catch 
		Print N'Lỗi xảy ra khi đăng ký tài khoản: ';
		Print Error_message() ;
		rollback tran
	end catch
end 

drop proc if not exists proc_LayDanhSachBenhNhan
create proc [dbo].[proc_LayDanhSachBenhNhan]
AS 
BEGIN
	
	SELECT patientFullName , patientPhoneNumber , patientDateOfBirth, patientAddress
	From patient 
END 
