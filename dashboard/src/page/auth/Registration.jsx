import React, { useState } from 'react';
import { Hospital, Droplet } from 'lucide-react';
import HospitalRegistrationForm from './HospitalRegistrationForm';
import BloodBankRegistrationForm from './BloodBankRegistrationForm';
import './Registration.css';

const Registration = () => {
  const [userType, setUserType] = useState('hospital'); // 'hospital' or 'bloodbank'

  return (
    <div className="registration-page">
      <div className="registration-container">
        
        {/* Toggle Section */}
        <div className="user-type-toggle">
          <button
            className={`toggle-btn ${userType === 'hospital' ? 'active hospital' : ''}`}
            onClick={() => setUserType('hospital')}
          >
            <Hospital size={24} />
            <span>Hospital</span>
          </button>
          
          <button
            className={`toggle-btn ${userType === 'bloodbank' ? 'active bloodbank' : ''}`}
            onClick={() => setUserType('bloodbank')}
          >
            <Droplet size={24} />
            <span>Blood Bank</span>
          </button>
        </div>

        {/* Render appropriate form based on selection */}
        {userType === 'hospital' ? (
          <HospitalRegistrationForm />
        ) : (
          <BloodBankRegistrationForm />
        )}
      </div>
    </div>
  );
};

export default Registration;
