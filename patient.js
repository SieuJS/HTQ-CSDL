// import { formatDateTime } from "./use-for-all";
// var { formatDateTime } = require('./use-for-all');

// Kiểm tra trạng thái đăng nhập khi truy cập trang


async function displayAvailableDentist(appointmentDate, appointmentTime) { 
  try {
    const response = await fetch('http://localhost:3000/displayAvailableDentist', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({appointmentDate, appointmentTime})
    })
    const data = await response.json()
    // Xử lý dữ liệu nhận được từ server
    const displayAvailableDentist = document.getElementById('displayAvailableDentist');
    displayAvailableDentist.innerHTML = ''; // Xóa nội dung cũ trước khi thêm thông tin mới
    if (response.status === 200) {
      data.forEach(dentist => {
        const option = document.createElement('option');
        option.value = dentist.dentistUserName;
        option.textContent = dentist.dentistFullName;      
        displayAvailableDentist.appendChild(option);
      });
    } else {
       const option = document.createElement('option');
       option.textContent = ' ';
       displayAvailableDentist.appendChild(option);
    }
  } catch(error) {
      console.error('Có lỗi xảy ra:', error);
  };
 
}

async function scheduleAppointment(patientPhoneNumber, appointmentDate, appointmentTime, dentistUserName) {
  try {
    const response = await fetch('http://localhost:3000/scheduleAppointment', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({patientPhoneNumber,appointmentDate,appointmentTime,dentistUserName})
    })
    const data = await response.json();
    const scheduleAppointmentResult = document.getElementById('scheduleAppointmentResult');
    scheduleAppointmentResult.innerHTML = '';
    if (response.status === 200) {
      scheduleAppointmentResult.innerHTML = data.message;
    } else if (response.status === 401) {
      const date = new Date(data.appointmentDate);
      const formattedDate = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`;
      const time = new Date(data.appointmentTime); 
      const formattedTime = `${time.getUTCHours().toString().padStart(2, '0')}:${time.getUTCMinutes().toString().padStart(2, '0')}`;
      scheduleAppointmentResult.innerHTML = `  
                                        <h3>Bạn đã có lịch hẹn vào thời gian này:</h3>
                                        <p>Appointment ID: ${data.appointmentId}</p>
                                        <p>Patient phone number: ${data.patientPhoneNumber}</p>
                                        <p>Appointment date: ${formattedDate}</p>
                                        <p>Appointment time: ${formattedTime}</p>
                                        <p>Dentist full name: ${data.dentistFullName}</p>
                                        `;
    } else if (response.status === 500) {
      scheduleAppointmentResult.innerHTML = data.message;
    }
  } catch(error) {
        console.error('Có lỗi xảy ra:', error);
  };     
}

async function getAllAppointmentsInfo(patientPhoneNumber) {
  try {
    const response = await fetch('http://localhost:3000/getAllAppointmentsInfo', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ patientPhoneNumber }) 
    })
    const data = await response.json();
    const getAllAppointmentsInfoResult = document.getElementById('getAllAppointmentsInfoResult');
    getAllAppointmentsInfoResult.innerHTML = '';
    if (response.status === 200) {
      data.forEach(appointment => {
      const date = new Date(appointment.appointmentDate);
      const formattedDate = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`;
      const time = new Date(appointment.appointmentTime); 
      const formattedTime = `${time.getUTCHours().toString().padStart(2, '0')}:${time.getUTCMinutes().toString().padStart(2, '0')}`;
      const getAllAppointmentsInfoDetails = document.createElement('p');
      getAllAppointmentsInfoDetails.textContent = `
                                        Appointment ID: ${appointment.appointmentId},
                                        Patient phone number : ${appointment.patientPhoneNumber}, 
                                        Appointment date: ${formattedDate},
                                        Appointment time: ${formattedTime},
                                        Dentist full name: ${appointment.dentistFullName}
                                        `; 
      getAllAppointmentsInfoResult.appendChild(getAllAppointmentsInfoDetails);
      });
    } else {
      getAllAppointmentsInfoResult.innerHTML = data.message;
    }
  } catch (error)  {
    console.error('Có lỗi xảy ra khi lấy thông tin lịch hẹn', error);
  };
}

module.exports =  { displayAvailableDentist, scheduleAppointment, getAllAppointmentsInfo };
