function formatDateTime(dateTimeString) {
    const dateTime = new Date(dateTimeString);
    const formattedDate = `${dateTime.getDate().toString().padStart(2, '0')}/${(dateTime.getMonth() + 1).toString().padStart(2, '0')}/${dateTime.getFullYear()}`;
    const formattedTime = `${dateTime.getHours().toString().padStart(2, '0')}:${dateTime.getMinutes().toString().padStart(2, '0')}`;
  
    return {
      date: formattedDate,
      time: formattedTime 
    };
  }

// Hàm để lấy thông tin khách hàng từ server dựa trên thông tin xác thực
// async function getCustomerInfo(userUsername, userPassword) {
//     try {
//         await fetch(`http://localhost:3000/teacher/${userUsername}`)
//         .then(response => response.json())
//         .then(data => {
//         // Xử lý dữ liệu nhận được từ server
//         const teacherInfoDiv = document.getElementById('customerInfo');
//         teacherInfoDiv.innerHTML = ''; // Xóa nội dung cũ trước khi thêm thông tin mới

//         teacherIDInfoDiv.innerHTML = `  
//                                         <h3>Thông Tin Giáo Viên</h3>
//                                         <p>Mã Giáo Viên: ${data.MAGV}</p>
//                                         <p>Họ Tên: ${data.HOTEN}</p>
//                                     `;
//         });
//     })
//     .catch(error => {
//         console.error('Có lỗi xảy ra:', error);
//     });
     

    

// function displayCustomerInfo(customerData) {
//     const customerDetailsElement = document.getElementById('customerDetails');
//     const { customerId, customerName, appointmentDate, serviceType, dentist } = customerData;
  
//     const formattedDateTime = formatDateTime(appointmentDate); // Sử dụng hàm formatDateTime() từ ví dụ trước
  
//     const customerInfoHTML = `
//       <strong>ID Khách Hàng:</strong> ${customerId}<br>
//       <strong>Tên Khách Hàng:</strong> ${customerName}<br>
//       <strong>Lịch hẹn:</strong><br>
//       <strong>Ngày:</strong> ${formattedDateTime.date}<br>
//       <strong>Giờ:</strong> ${formattedDateTime.time}<br>
//       <strong>Dịch vụ:</strong> ${serviceType}<br>
//       <strong>Nha Sĩ:</strong> ${dentist}
//     `;
  
//     customerDetailsElement.innerHTML = customerInfoHTML;
//   }
  
//   // Ví dụ về cách sử dụng displayCustomerInfo khi nhận được thông tin từ server
//   const sampleCustomerData = {
//     customerName: 'John Doe',
//     appointmentDate: '2023-12-04T23:25',
//     serviceType: 'Mặt trong',
//     dentist: 'Dr. Smith'
//   };
  
//   displayCustomerInfo(sampleCustomerData); // Hiển thị thông tin khách hàng và lịch hẹn
  
  
module.exports = { formatDateTime };