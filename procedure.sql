use testConflict
GO
drop proc if exists proc_XuatThuoc
drop proc if exists proc_NhapKhoThuoc 
drop proc if exists proc_ThanhToanHoaDon
drop proc if exists proc_ThemLichHenBn
drop proc if exists proc_ThemSuaLichHen
drop proc if exists proc_XemCuocHen
drop proc if exists proc_ThemDonThuoc
 drop proc if exists proc_GhiNhanHoSo
drop proc if exists proc_ChinhSuaThongTinKhachHang
drop proc if exists proc_ThongTinCaNhanKhachHang
drop proc if exists proc_DatLichHen_Accounted
drop proc if exists proc_DangKyThongTinKhachHang 
drop proc if exists proc_XemThongTinBenhAn 
drop proc if exists proc_ThemHoaDon
drop proc if exists usp_GetErrorInfo 
drop proc if exists proc_TaoTaiKhoan
drop proc if exists proc_LayDanhSachBenhNhan
drop proc if exists proc_XoaThongTinBenhNhan
drop proc if exists proc_XoaTaiKhoanBenhNhan
Go

create proc proc_XoaTaiKhoan @username char(255)
AS 
Begin 
	Delete From  Account where username  = @username
End 
GO
create proc proc_XoaThongTinBenhNhan 
@phoneNum char(255)
As 
Begin 
	Delete from patient  where patientPhoneNumber = @phoneNum;
End 
GO
create proc proc_TaoTaiKhoan @username char(255) , 
@password char(255) , @type char(20) 
AS 
BEGIN 
	
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
GO
create proc proc_LayDanhSachBenhNhan
AS 
BEGIN
	SELECT patientFullName , patientPhoneNumber , patientDateOfBirth, patientAddress
	From patient 
END 
GO
CREATE PROCEDURE usp_GetErrorInfo  
AS  
    SELECT   
         ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  
GO  

-- Dang ky thong tin khach hang 
-- Vai tro : Khach hang , admin 
create proc proc_DangKyThongTinKhachHang 
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
		commit tran
		exec proc_TaoTaiKhoan @phoneNum , @password , 'Patient';

	end try
	begin catch 
		Print N'Lỗi xảy ra khi đăng ký tài khoản: ';
		Print Error_message() ;
		rollback tran
	end catch
end 

GO 

-- Hệ thống tự động đặt lịch hẹn
create proc proc_DatLichHen_Accounted 
@fullName char(255) = NULL, 
@Dob date = NULL,
@address char(255) = NULL, 
@phoneNum char(20),
@apDate date , 
@apTime time (7),
@dentist char(20) 
as 
BEGIN
	Begin try 
		if not exists (select * from Patient where @phoneNum = patientPhoneNumber) 
		BEGIN 
			exec proc_DangKyThongTinKhachHang @fullName, @phoneNum, '123', @Dob, @address
			Print N'Đã tạo tài khoản với số điện thoại và mật khẩu mặc định là 123'
		END
		insert into scheduleAppointment 
		values (@phoneNum , @apDate, @apTime ,@dentist)
	End try

	Begin catch 
		Print N'Lỗi xảy ra khi đặt lịch hẹn:'
		Print Error_message();
	End catch 
END 
GO
-- Xem thông tin cá nhân 
create proc proc_ThongTinCaNhanKhachHang 
@phoneNum char(20)
AS
BEGIN 
		Select * from Patient Where patientPhoneNumber = @phoneNum ;
END
GO
-- Chỉnh sửa thông tin khách hàng 
create proc proc_ChinhSuaThongTinKhachHang 
@phoneNum char(20),
@fullName char(255) = NULL, 
@Dob char(255) = NULL, 
@patientAddress char(255) = NULL
AS
Begin 
	Update Patient
	set patientFullName = isNull(@fullName, patientFullName),  
	patientDateOfBirth = isNull(@Dob, patientDateOfBirth)
	Where patientPhoneNumber = @phoneNum
end 
GO
-- Xem thông tin bệnh án mà của bệnh nhân mà bác sĩ ghi lại 
create proc proc_XemThongTinBenhAn 
@phoneNum char(20) 
As 
Begin
	Select * From patientMedicalRecords
End 
GO
-- Vai tro nha si : 
-- Quản lý hồ sơ bệnh nhân 
create proc proc_GhiNhanHoSo 
@ngayKham date = NULL, 
@thoiGian time = NULL, 
@nguoiThucHien int = NULL,
@phoneNumber char(255) = NULL,
@medRecId int = NULL 
AS 
Begin
	Begin try
		If @medRecId is Null 
		Begin
			Insert patientMedicalRecords 
			Values (@phoneNumber, @ngayKham, @thoiGian);
		End
		Else
		Begin
			if not exists (select * from patientMedicalRecords where medicalRecordId = @medRecId)
			throw 51000, 'Medical Record Id not found', 1

			Update patientMedicalRecords 
			Set patientPhoneNumber = isNull(@phoneNumber, patientPhoneNumber) ,
				examinationDate = isNull (@ngayKham , examinationDate),
				examinationTime = isNull (@thoiGian, examinationTime)
			Where medicalRecordId = @medRecId
		End
	End try 
	Begin catch 
		Print N'Lỗi khi thao tác quản lý hồ sơ bệnh nhân'
		Print Error_Message()
	End catch
End 

GO 

-- Quan ly them don thuoc 
create proc proc_ThemDonThuoc 
@medRecId int,
@drugId int ,
@quantity int
As 
Begin 
	Begin try
	if not exists (select * from patientMedicalRecords where medicalRecordId = @medRecId)
		throw 51000, 'Medical Record Id not found', 1
	Insert into patientDrugs 
	Values (@medRecId , @drugId , @quantity) 
	End try
	Begin catch
		Print N'Lỗi khi thêm đơn thuốc '
		Print Error_Message()
	End catch
End 
GO
--Quan ly cuoc hen
-- Khong duoc cap nhat lich hen ban
create proc proc_XemCuocHen 
@dentistUserName char(30)
As
Begin 
	Select * from workSchedule
	Where dentistUsername = @dentistUserName;
End
GO

-- Them, sua lich hen 
create proc proc_ThemSuaLichHen
@dentistUsername char(30),
@workingDate date , 
@startTime time,
@endTime time,
@busyStatus char(10)  =NULL,
@scheduleId int = NULL 
As 
Begin
	if @scheduleId is NULL 
	-- Thuc hien them lich hen 
	Begin 
		Insert into workSchedule 
		Values (@dentistUsername , @workingDate, @startTime, @endTime, @busyStatus)
	End
	Else -- Thuc hien update 
	Begin 
		Update workSchedule 
		Set workingDate = IsNull(@workingDate, workingDate ), 
			startTime = IsNull( @startTime , startTime),
			endTime = IsNull(@endTime , endTime), 
			busyStatus = IsNull(@busyStatus, busyStatus)
		Where dentistUserName = @dentistUsername and scheduleId = @scheduleId
	End
End 
GO 

-- Nhan vien 
-- tiep nhan benh nhan 
 -- da co o tren 

-- thêm lịch hẹn cho bệnh nhân 
create proc proc_ThemLichHenBn 
@patientPhoneNumber char(12), 
@appointmentDate date ,
@appointmentTime time ,
@dentistUserName char(20)
As 
Begin 
	Begin try 
	Insert into scheduleAppointment
	values ( @patientPhoneNumber , @appointmentDate, @appointmentTime, @dentistUserName)
	End try
	Begin Catch
		Print N'Lỗi khi thao tác thêm lịch hẹn cho bệnh nhân'
		Print Error_Message()
	End Catch
End
GO 

-- Thanh toán 
-- Thêm một hoá đơn 
create proc proc_ThemHoaDon 
@medicalRecordId int ,
@totalPrice int,
@paymentStatus char (10) = 'Unpaid'
As 
Begin
	Begin try 
	Insert into Receipt
	Values (@medicalRecordId, @totalPrice, @paymentStatus)
	End try
	Begin catch 
		Print N'Lỗi khi thêm một hoá đơn '
		Print Error_Message()
	End catch
End
GO

-- Thuc hien thanh toan
create proc  proc_ThanhToanHoaDon
@receiptId int 
As 
Begin 
	Update Receipt 
	Set paymentStatus = 'Paid'
	Where receiptId = @receiptId
End
GO 

-- Quan tri vien : 
drop proc if exists proc_NhapKhoThuoc 
Go
create Proc proc_NhapKhoThuoc 
@drugID int , @addNumber int 
AS 
Begin 
	-- kiem tra ton tai cua id thuoc
	if not exists (select * from Drug Where drugId = @drugId ) 
	begin 
		return;
	end
	declare @currentInstock int = 
	(select stockNumber from Drug Where drugId = @drugID);
	declare @newStock int = @currentInstock + @addNumber;
	Begin try 
		Begin Tran;
		Update Drug set stockNumber = @newStock where drugId = @drugID;
		select * from drug
		WAITFOR DELAY '00:00:05';
		Commit Tran;
	End Try
	Begin Catch 
		Print Error_Number();
		Print Error_Message();
		Rollback Tran;
	End Catch
End
GO

create Proc proc_XuatThuoc
@drugId int, @quantity int, @medicalRecId int 
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
		Begin Tran;
		Insert into patientDrugs values (@medicalRecId, @drugId, @quantity);  
		Update Drug set stockNumber = @newStock where drugId = @drugID;
		WAITFOR DELAY '00:00:10';
		Commit Tran;
	End Try
	Begin Catch 
		Print Error_Number();
		Print Error_Message();
		Rollback Tran;
	End Catch

END
GO


