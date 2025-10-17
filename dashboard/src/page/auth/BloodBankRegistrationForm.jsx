import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useDropzone } from 'react-dropzone';
import toast from 'react-hot-toast';
import { 
  Upload, 
  FileText, 
  MapPin, 
  Navigation,
  Loader2
} from 'lucide-react';
import { geocodeAddress, reverseGeocode, getCurrentPosition } from '../../services/geocoding';
import { registerBloodBank } from '../../services/api';
import './BloodBankRegistrationForm.css';

const BloodBankRegistrationForm = ({ embeddedInHospital = false }) => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    parentOrganization: '',
    licenseNumber: '',
    location: '',
    city: '',
    stateProvince: '',
    pincode: '',
    contactNumber: '',
    contact24x7: '',
    email: '',
    operatingHours: '',
    servicesText: '',
    serviceArea: '',
    organizesDonationCamp: false
  });
  
  const [bloodBankImage, setBloodBankImage] = useState(null);
  const [bloodBankImagePreview, setBloodBankImagePreview] = useState(null);
  const [registrationPdf, setRegistrationPdf] = useState(null);
  const [coordinates, setCoordinates] = useState(null);
  const [geoLoading, setGeoLoading] = useState(false);
  const [selectedAccreditations, setSelectedAccreditations] = useState([]);

  const availableAccreditations = ['AABB', 'NABH', 'ISO', 'Other'];

  // Image dropzone
  const { getRootProps: getImageRootProps, getInputProps: getImageInputProps } = useDropzone({
    accept: { 'image/*': ['.jpeg', '.jpg', '.png', '.gif', '.webp'] },
    multiple: false,
    onDrop: (acceptedFiles) => {
      if (acceptedFiles && acceptedFiles.length > 0) {
        const file = acceptedFiles[0];
        setBloodBankImage(file);
        setBloodBankImagePreview(URL.createObjectURL(file));
        toast.success('Blood bank image uploaded!');
      }
    }
  });

  // PDF dropzone
  const { getRootProps: getPdfRootProps, getInputProps: getPdfInputProps } = useDropzone({
    accept: { 'application/pdf': ['.pdf'] },
    multiple: false,
    onDrop: (acceptedFiles) => {
      if (acceptedFiles && acceptedFiles.length > 0) {
        setRegistrationPdf(acceptedFiles[0]);
        toast.success('Registration PDF uploaded!');
      }
    }
  });

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const toggleAccreditation = (acc) => {
    setSelectedAccreditations(prev => {
      if (prev.includes(acc)) {
        return prev.filter(a => a !== acc);
      } else {
        return [...prev, acc];
      }
    });
  };

  const handleUseCurrentLocation = async () => {
    setGeoLoading(true);
    try {
      const position = await getCurrentPosition();
      setCoordinates({ lat: position.latitude, lon: position.longitude });
      
      const address = await reverseGeocode(position.latitude, position.longitude);
      if (address) {
        setFormData(prev => ({
          ...prev,
          location: address.street || prev.location,
          city: address.city || prev.city,
          stateProvince: address.state || prev.stateProvince,
          pincode: address.pincode || prev.pincode
        }));
        toast.success('Location detected!');
      }
    } catch (error) {
      toast.error(error.message || 'Failed to get current location');
    } finally {
      setGeoLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Basic validation
    if (!formData.name || !formData.licenseNumber) {
      toast.error('Please fill in required fields (Name and License Number)');
      return;
    }

    setLoading(true);
    try {
      const submitData = new FormData();
      
      // Add all form fields
      submitData.append('name', formData.name);
      submitData.append('parent_org', formData.parentOrganization);
      submitData.append('lic_no', formData.licenseNumber);
      submitData.append('contact_no', formData.contactNumber);
      submitData.append('contact_24x7', formData.contact24x7);
      submitData.append('email', formData.email);
      submitData.append('operating_hours', formData.operatingHours);
      submitData.append('organizes_donation_camp', formData.organizesDonationCamp.toString());
      submitData.append('service_area', formData.serviceArea);
      
      // Add location as JSON
      const location = {
        street: formData.location,
        city: formData.city,
        state: formData.stateProvince,
        pincode: formData.pincode
      };
      submitData.append('location', JSON.stringify(location));
      
      // Add accreditations as JSON array
      submitData.append('accreditations', JSON.stringify(selectedAccreditations));
      
      // Add services as JSON array (parsed from comma-separated text)
      const services = formData.servicesText
        .split(',')
        .map(s => s.trim())
        .filter(s => s.length > 0);
      submitData.append('services', JSON.stringify(services));
      
      // Add files if present
      if (bloodBankImage) {
        submitData.append('profile_pic', bloodBankImage);
      }
      if (registrationPdf) {
        submitData.append('scanned_copy', registrationPdf);
      }
      
      const response = await registerBloodBank(submitData);
      
      if (response.success) {
        toast.success('Blood Bank registered successfully!');
        setTimeout(() => {
          navigate('/bloodbank');
        }, 1500);
      } else {
        toast.error(response.error || 'Registration failed');
      }
    } catch (error) {
      toast.error(error.message || 'Failed to register blood bank');
    } finally {
      setLoading(false);
    }
  };

  const openPdf = () => {
    if (registrationPdf) {
      const url = URL.createObjectURL(registrationPdf);
      window.open(url, '_blank');
    }
  };

  return (
    <form onSubmit={handleSubmit} className="bloodbank-form">
      
      {/* Blood Bank Image Section */}
      <div className="form-section image-section-bb">
        <div {...getImageRootProps()} className="image-dropzone-bb">
          <input {...getImageInputProps()} />
          {bloodBankImagePreview ? (
            <img 
              src={bloodBankImagePreview} 
              alt="Blood Bank" 
              className="image-preview"
            />
          ) : (
            <div className="upload-placeholder">
              <Upload className="upload-icon-bb" size={50} />
              <p>Click or drag blood bank image here</p>
            </div>
          )}
        </div>
        {bloodBankImage && (
          <p className="file-name-bb">{bloodBankImage.name}</p>
        )}
      </div>

      {/* Basic Information */}
      <div className="form-section">
        <h2 className="section-header-bb">Basic Information</h2>
        
        {!embeddedInHospital && (
          <>
            <div className="form-group">
              <label htmlFor="name">Blood Bank Name *</label>
              <input
                type="text"
                id="name"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                required
                className="form-input-bb"
                placeholder="Enter blood bank name"
              />
            </div>
          </>
        )}

        <div className="form-group">
          <label htmlFor="parentOrganization">Parent Organization (if any)</label>
          <input
            type="text"
            id="parentOrganization"
            name="parentOrganization"
            value={formData.parentOrganization}
            onChange={handleInputChange}
            className="form-input-bb"
            placeholder="Enter parent organization"
          />
        </div>

        <div className="form-group">
          <label htmlFor="licenseNumber">License / Registration Number *</label>
          <input
            type="text"
            id="licenseNumber"
            name="licenseNumber"
            value={formData.licenseNumber}
            onChange={handleInputChange}
            required
            className="form-input-bb"
            placeholder="Enter license number"
          />
        </div>
      </div>

      {/* Accreditations Section */}
      <div className="form-section">
        <h2 className="section-header-bb">Accreditations</h2>
        
        <div className="accreditations-container">
          {availableAccreditations.map((acc) => {
            const isSelected = selectedAccreditations.includes(acc);
            return (
              <button
                key={acc}
                type="button"
                onClick={() => toggleAccreditation(acc)}
                className={`accreditation-chip ${isSelected ? 'selected' : ''}`}
              >
                {acc}
              </button>
            );
          })}
        </div>
      </div>

      {/* Registration Document */}
      <div className="form-section pdf-section-bb">
        <h2 className="section-header-bb">Registration Document</h2>
        
        <div {...getPdfRootProps()} className="pdf-dropzone-bb">
          <input {...getPdfInputProps()} />
          <FileText className="pdf-icon-bb" size={40} />
          <p>Click or drag PDF here</p>
        </div>

        {registrationPdf && (
          <div className="pdf-info-bb">
            <FileText size={20} />
            <span className="pdf-filename-bb">{registrationPdf.name}</span>
            <button 
              type="button"
              className="btn btn-warning-outline-bb"
              onClick={openPdf}
            >
              Open PDF
            </button>
          </div>
        )}
      </div>

      {/* Location Information (if not embedded) */}
      {!embeddedInHospital && (
        <div className="form-section">
          <h2 className="section-header-bb">Location Information</h2>
          
          <div className="form-group">
            <label htmlFor="location">Street Address</label>
            <input
              type="text"
              id="location"
              name="location"
              value={formData.location}
              onChange={handleInputChange}
              className="form-input-bb"
              placeholder="Enter street address"
            />
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="city">City</label>
              <input
                type="text"
                id="city"
                name="city"
                value={formData.city}
                onChange={handleInputChange}
                className="form-input-bb"
                placeholder="Enter city"
              />
            </div>

            <div className="form-group">
              <label htmlFor="stateProvince">State / Province</label>
              <input
                type="text"
                id="stateProvince"
                name="stateProvince"
                value={formData.stateProvince}
                onChange={handleInputChange}
                className="form-input-bb"
                placeholder="Enter state"
              />
            </div>
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="pincode">Pincode</label>
              <input
                type="text"
                id="pincode"
                name="pincode"
                value={formData.pincode}
                onChange={handleInputChange}
                className="form-input-bb"
                placeholder="Enter pincode"
              />
            </div>

            <div className="form-group">
              <button 
                type="button"
                className="btn btn-teal-bb"
                onClick={handleUseCurrentLocation}
                disabled={geoLoading}
              >
                {geoLoading ? <Loader2 className="spin" size={18} /> : <Navigation size={18} />}
                Get Location
              </button>
            </div>
          </div>

          {coordinates && (
            <div className="coordinates-display-bb">
              <MapPin size={18} />
              <div>
                <p className="coordinates-title">Coordinates</p>
                <p className="coordinates-value">
                  Lat: {coordinates.lat.toFixed(6)} | Lon: {coordinates.lon.toFixed(6)}
                </p>
              </div>
            </div>
          )}
        </div>
      )}

      {/* Contact Information */}
      <div className="form-section">
        <h2 className="section-header-bb">Contact Information</h2>
        
        <div className="form-group">
          <label htmlFor="contactNumber">Contact Number</label>
          <input
            type="tel"
            id="contactNumber"
            name="contactNumber"
            value={formData.contactNumber}
            onChange={handleInputChange}
            className="form-input-bb"
            placeholder="Enter contact number"
          />
        </div>

        <div className="form-group">
          <label htmlFor="contact24x7">24/7 Contact Number (if any)</label>
          <input
            type="tel"
            id="contact24x7"
            name="contact24x7"
            value={formData.contact24x7}
            onChange={handleInputChange}
            className="form-input-bb"
            placeholder="Enter 24/7 contact number"
          />
        </div>

        <div className="form-group">
          <label htmlFor="email">Email Address</label>
          <input
            type="email"
            id="email"
            name="email"
            value={formData.email}
            onChange={handleInputChange}
            className="form-input-bb"
            placeholder="Enter email address"
          />
        </div>

        <div className="form-group">
          <label htmlFor="operatingHours">Operating Hours (e.g., 09:00-18:00)</label>
          <input
            type="text"
            id="operatingHours"
            name="operatingHours"
            value={formData.operatingHours}
            onChange={handleInputChange}
            className="form-input-bb"
            placeholder="e.g., 09:00-18:00"
          />
        </div>
      </div>

      {/* Services Section */}
      <div className="form-section">
        <h2 className="section-header-bb">Services Offered</h2>
        
        <div className="form-group">
          <label htmlFor="servicesText">
            Services (comma separated, e.g., Whole Blood, Platelets, Plasma)
          </label>
          <input
            type="text"
            id="servicesText"
            name="servicesText"
            value={formData.servicesText}
            onChange={handleInputChange}
            className="form-input-bb"
            placeholder="Whole Blood, Platelets, Plasma"
          />
        </div>
      </div>

      {/* Additional Information */}
      <div className="form-section">
        <h2 className="section-header-bb">Additional Information</h2>
        
        <div className="form-group">
          <label className="donation-camp-label">
            Do you organize donation camps?
          </label>
          <div className="donation-camp-buttons">
            <button
              type="button"
              className={`donation-camp-btn ${formData.organizesDonationCamp ? 'yes-selected' : ''}`}
              onClick={() => setFormData(prev => ({ ...prev, organizesDonationCamp: true }))}
            >
              <span className="radio-circle">
                {formData.organizesDonationCamp && <span className="radio-dot"></span>}
              </span>
              Yes
            </button>
            
            <button
              type="button"
              className={`donation-camp-btn ${!formData.organizesDonationCamp ? 'no-selected' : ''}`}
              onClick={() => setFormData(prev => ({ ...prev, organizesDonationCamp: false }))}
            >
              <span className="radio-circle">
                {!formData.organizesDonationCamp && <span className="radio-dot"></span>}
              </span>
              No
            </button>
          </div>
        </div>

        <div className="form-group">
          <label htmlFor="serviceArea">Service Area (comma separated)</label>
          <input
            type="text"
            id="serviceArea"
            name="serviceArea"
            value={formData.serviceArea}
            onChange={handleInputChange}
            className="form-input-bb"
            placeholder="Enter service areas"
          />
        </div>
      </div>

      {/* Submit Button */}
      {!embeddedInHospital && (
        <button 
          type="submit" 
          className="btn btn-submit bloodbank-submit"
          disabled={loading}
        >
          {loading ? (
            <>
              <Loader2 className="spin" size={20} />
              Registering...
            </>
          ) : (
            'Register Blood Bank'
          )}
        </button>
      )}
    </form>
  );
};

export default BloodBankRegistrationForm;
