window.onload = function() {
    if ((!sessionStorage.getItem('loggedInUser')) || (sessionStorage.getItem('accountType') !== 'Admin')) {
        window.location.href = 'login.html'; // Chuyển hướng về trang đăng nhập
    }
};

//staff
async function getAllStaffsInfo() {
    const allStaffsInfo = document.getElementById('allStaffsInfo');
    try {
        const response = await fetch('http://localhost:3000/getAllStaffsInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        const data = await response.json();
        if (response.status === 200) {            
            allStaffsInfo.innerHTML = ''; 
            data.forEach(staff => {
            const allStaffsDetails = document.createElement('p');
            allStaffsDetails.textContent = `
                                            Staff name: ${staff.staffFullName}, 
                                            Staff username: ${staff.staffUserName},
                                            Password: ${staff.staffPassword}`; 
            allStaffsInfo.appendChild(allStaffsDetails);
            });
        } else {
            allStaffsInfo.innerHTML = data.message;
        }
    } catch (error)  {
        allStaffsInfo.innerHTML = data.message;
        console.error('Có lỗi xảy ra khi lấy thông tin nhân viên', error);
    };
}

async function getStaffInfo(staffUserName) {
    const staffInfo = document.getElementById('getStaffInfo');
    try {
        const response = await fetch('http://localhost:3000/getStaffInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ staffUserName }) 
        })
        const data = await response.json();
        if (response.status === 200) {  
            staffInfo.innerHTML = `  
                                    <h3>Staff information</h3>
                                    <p>Staff name: ${data.staffFullName}</p>
                                    <p>Staff username: ${data.staffUserName}</p>
                                    <p>Staff password: ${data.staffPassword}`;
        } else {
            staffInfo.innerHTML = data.message;
        }
    } catch (error) {
        staffInfo.innerHTML = data.message;
        console.error('Có lỗi xảy ra khi lấy thông tin nhân viên', error);
    };
}
  
async function updateStaffInfo() {
    const staffUpdateResult = document.getElementById('staffUpdateResult');
    const enterStaffUserName = document.getElementById('enterStaffUserName').value;
    const staffFullName = document.getElementById('updateStaffFullName').value;
    const updateStaffUserName = document.getElementById('updateStaffUserName').value;
    const staffPassword = document.getElementById('updateStaffPassword').value;

    try {
        const response = await fetch('http://localhost:3000/updateStaffInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ enterStaffUserName, staffFullName, updateStaffUserName, staffPassword })
        })
        const data = await response.json();
        if (response.status === 200) {
            staffUpdateResult.textContent = data.message;
        } else if (response.status === 404 ) {
            staffUpdateResult.textContent = data.message;
        } else if (response.status === 500) {
            staffUpdateResult.textContent = data.message;
        }
    } catch (error) {
        console.error('Có lỗi xảy ra:', error);
    };
}

async function addStaffInfo(staffFullName, staffUserName,  staffPassword) {
    const staffAddResult = document.getElementById('staffAddResult');
    try {
        const response = await fetch('http://localhost:3000/addStaffInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ staffFullName, staffUserName,  staffPassword})
        })
        const data = await response.json();
        if (response.status === 200) {
            staffAddResult.textContent = data.message;
        } else if (response.status === 500) {
            staffAddResult.textContent = data.message;
        }    
    } catch (error) {
        staffAddResult.textContent = data.message;
        console.error('Có lỗi xảy ra:', error);
    }  
}

async function deleteStaffInfo() {
    const staffDeleteResult = document.getElementById('staffDeleteResult');
    const staffUserName = document.getElementById('deleteStaffUserName').value;
    try {
        const response = await fetch(`http://localhost:3000/deleteStaffInfo/${staffUserName}`, {
        method: 'DELETE',
        })
        const data = await response.json();
        if (response.status === 200) {
            staffDeleteResult.textContent = data.message;
        } else {
            staffDeleteResult.textContent = data.message;
        }
    } catch(error) {
        console.error('Có lỗi xảy ra:', error);
    }
}


//dentist
async function getAllDentistsInfo() {
    const allDentistsInfo = document.getElementById('allDentistsInfo');
    try {
        const response = await fetch('http://localhost:3000/getAllDentistsInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        const data = await response.json();
        if (response.status === 200) {            
            allDentistsInfo.innerHTML = ''; 
            data.forEach(dentist => {
            const allDentistsDetails = document.createElement('p');
            allDentistsDetails.textContent = `
                                            Dentist name: ${dentist.dentistFullName}, 
                                            Dentist username: ${dentist.dentistUserName},
                                            Password: ${dentist.dentistPassword}`; 
            allDentistsInfo.appendChild(allDentistsDetails);
            });
        } else {
            allDentistsInfo.innerHTML = data.message;
        }
    } catch (error)  {
        allDentistsInfo.innerHTML = data.message;
        console.error('Có lỗi xảy ra khi lấy thông tin nha sĩ', error);
    };
}

async function getDentistInfo(dentistUserName) {
    const dentistInfo = document.getElementById('getDentistInfo');
    try {
        const response = await fetch('http://localhost:3000/getDentistInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ dentistUserName }) 
        })
        const data = await response.json();
        if (response.status === 200) {  
            dentistInfo.innerHTML = `  
                                    <h3>Dentist information</h3>
                                    <p>Dentist name: ${data.dentistFullName}</p>
                                    <p>Dentist username: ${data.dentistUserName}</p>
                                    <p>Dentist password: ${data.dentistPassword}`;
        } else {
            dentistInfo.innerHTML = data.message;
        }
    } catch (error) {
        dentistInfo.innerHTML = data.message;
        console.error('Có lỗi xảy ra khi lấy thông tin nha sĩ', error);
    };
}
  
async function updateDentistInfo() {
    const dentistUpdateResult = document.getElementById('dentistUpdateResult');
    const enterDentistUserName = document.getElementById('enterDentistUserName').value;
    const dentistFullName = document.getElementById('updateDentistFullName').value;
    const updateDentistUserName = document.getElementById('updateDentistUserName').value;
    const dentistPassword = document.getElementById('updateDentistPassword').value;

    try {
        const response = await fetch('http://localhost:3000/updateDentistInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ enterDentistUserName, dentistFullName, updateDentistUserName, dentistPassword })
        })
        const data = await response.json();
        if (response.status === 200) {
            dentistUpdateResult.textContent = data.message;
        } else if (response.status === 404 ) {
            dentistUpdateResult.textContent = data.message;
        } else if (response.status === 500) {
            dentistUpdateResult.textContent = data.message;
        }
    } catch (error) {
        console.error('Có lỗi xảy ra:', error);
    };
}

async function addDentistInfo(dentistFullName, dentistUserName,  dentistPassword) {
    const dentistAddResult = document.getElementById('dentistAddResult');
    try {
        const response = await fetch('http://localhost:3000/addDentistInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ dentistFullName, dentistUserName,  dentistPassword})
        })
        const data = await response.json();
        if (response.status === 200) {
            dentistAddResult.textContent = data.message;
        } else if (response.status === 500) {
            dentistAddResult.textContent = data.message;
        }    
    } catch (error) {
        dentistAddResult.textContent = data.message;
        console.error('Có lỗi xảy ra:', error);
    }  
}

async function deleteDentistInfo() {
    const dentistDeleteResult = document.getElementById('dentistDeleteResult');
    const dentistUserName = document.getElementById('deleteDentistUserName').value;
    try {
        const response = await fetch(`http://localhost:3000/deleteDentistInfo/${dentistUserName}`, {
        method: 'DELETE',
        })
        const data = await response.json();
        if (response.status === 200) {
            dentistDeleteResult.textContent = data.message;
        } else {
            dentistDeleteResult.textContent = data.message;
        }
    } catch(error) {
        console.error('Có lỗi xảy ra:', error);
    }
}

async function getAllDrugsInfo() {
    const allDrugsInfo = document.getElementById('allDrugsInfo');
    try {
        const response = await fetch('http://localhost:3000/getAllDrugsInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        const data = await response.json();
        if (response.status === 200) {            
            allDrugsInfo.innerHTML = ''; 
            data.forEach(drug => {
            const date = new Date(drug.expiredDate);
            const formattedDate = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`;
            const allDrugsDetails = document.createElement('p');
            allDrugsDetails.textContent = `
                                            Drug Id: ${drug.drugId},
                                            Drug name: ${drug.drugName},
                                            Unit: ${drug.unit},
                                            Indication: ${drug.indication}, 
                                            Expired date: ${formattedDate},
                                            Stock number: ${drug.stockNumber},
                                            Price: ${drug.price}$`; 
            allDrugsInfo.appendChild(allDrugsDetails);
            });
        } else {
            allDrugsInfo.innerHTML = data.message;
        }
    } catch (error)  {
        allDrugsInfo.innerHTML = data.message;
        console.error('Có lỗi xảy ra khi lấy thông tin thuốc', error);
    };
}

async function getDrugInfo(drugId) {
    const drugInfo = document.getElementById('getDrugInfo');
    try {
        const response = await fetch('http://localhost:3000/getDrugInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ drugId }) 
        })
        const data = await response.json();
        if (response.status === 200) {  
            const date = new Date(data.expiredDate);
            const formattedDate = `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth() + 1).toString().padStart(2, '0')}/${date.getFullYear()}`;
            drugInfo.innerHTML = `  
                                    <h3>Drug information</h3>
                                    <p>Drug Id: ${data.drugId}</p>
                                    <p>Drug name: ${data.drugName}</p>
                                    <p>Unit: ${data.unit}</p>
                                    <p>Indication: ${data.indication}</p>
                                    <p>Expired date: ${formattedDate}</p>
                                    <p>Stock number: ${data.stockNumber}</p>
                                    <p>Price: ${data.price}$</p>`;
        } else {
            drugInfo.innerHTML = data.message;
        }
    } catch (error) {
        drugInfo.innerHTML = data.message;
        console.error('Có lỗi xảy ra khi lấy thông tin thuốc', error);
    };
}
  
async function updateDrugInfo() {
    const drugUpdateResult = document.getElementById('drugUpdateResult');
    const enterDrugId = document.getElementById('enterDrugId').value;
    const drugName = document.getElementById('updateDrugName').value;
    const unit = document.getElementById('updateUnit').value;
    const indication = document.getElementById('updateIndication').value;
    const expiredDate = document.getElementById('updateExpiredDate').value;
    const price = document.getElementById('updatePrice').value;

    try {
        const response = await fetch('http://localhost:3000/updateDrugInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ enterDrugId, drugName, unit, indication, expiredDate, price})
        })
        const data = await response.json();
        if (response.status === 200) {
            drugUpdateResult.textContent = data.message;
        } else if (response.status === 404 ) {
            drugUpdateResult.textContent = data.message;
        } else if (response.status === 500) {
            drugUpdateResult.textContent = data.message;
        }
    } catch (error) {
        console.error('Có lỗi xảy ra', error);
    };
}

async function updateStockNumber() {
    const drugStockNumberUpdateResult = document.getElementById('drugStockNumberUpdateResult');
    const drugId = document.getElementById('updateDrugIdStockNumber').value;
    const stockNumber = document.getElementById('updateStockNumber').value;
    try {
        const response = await fetch('http://localhost:3000/updateStockNumber', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ drugId, stockNumber })
        })
        const data = await response.json();
        if (response.status === 200) {
            drugStockNumberUpdateResult.textContent = data.message;
        } else if (response.status === 404) {
            drugStockNumberUpdateResult.textContent = data.message;
        } else if (response.status === 500) {
            drugStockNumberUpdateResult.textContent = data.message;
        }
    } catch (error) {
        console.error('Có lỗi xảy ra', error);
    };
}

async function addDrugInfo(drugName, unit, indication, expiredDate, stockNumber, price) {
    const drugAddResult = document.getElementById('drugAddResult');
    try {
        const response = await fetch('http://localhost:3000/addDrugInfo', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ drugName, unit, indication, expiredDate, stockNumber, price})
        })
        const data = await response.json();
        if (response.status === 200) {
            drugAddResult.textContent = data.message;
        } else if (response.status === 500) {
            drugAddResult.textContent = data.message;
        }    
    } catch (error) {
        drugAddResult.textContent = data.message;
        console.error('Có lỗi xảy ra', error);
    }  
}

async function deleteDrugInfo() {
    const drugDeleteResult = document.getElementById('drugDeleteResult');
    const drugId = document.getElementById('deleteDrugId').value;
    try {
        const response = await fetch(`http://localhost:3000/deleteDrugInfo/${drugId}`, {
        method: 'DELETE',
        })
        const data = await response.json();
        if (response.status === 200) {
            drugDeleteResult.textContent = data.message;
        } else {
            drugDeleteResult.textContent = data.message;
        }
    } catch(error) {
        console.error('Có lỗi xảy ra', error);
    }
}

async function deleteExpiredDrugs() {
    const drugsExpiredDeleteResult = document.getElementById('drugsExpiredDeleteResult');
    try {
        const response = await fetch(`http://localhost:3000/deleteExpiredDrugs`, {
        method: 'DELETE',
        })
        const data = await response.json();
        if (response.status === 200) {
            drugsExpiredDeleteResult.textContent = data.message;
        } else {
            drugsExpiredDeleteResult.textContent = data.message;
        }
    } catch(error) {
        console.error('Có lỗi xảy ra', error);
    }
}

module.exports = { getAllStaffsInfo, getStaffInfo, updateStaffInfo, addStaffInfo, deleteStaffInfo }
module.exports = { getAllDentistsInfo, getDentistInfo, updateDentistInfo, addDentistInfo, deleteDentistInfo};
module.exports = { getAllDrugsInfo, getDrugInfo, updateDrugInfo, updateStockNumber, addDrugInfo, deleteDrugInfo, deleteExpiredDrugs};
