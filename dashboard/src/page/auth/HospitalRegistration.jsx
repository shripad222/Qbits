import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useDropzone } from 'react-dropzone';
import toast, { Toaster } from 'react-hot-toast';
import { 
  Hospital, 
  Upload, 
  FileText, 
  MapPin, 
  Navigation,
  CheckCircle,
  Circle,
  Loader2
} from 'lucide-react';
import { geocodeAddress, reverseGeocode, getCurrentPosition } from '../../services/geocoding.js';
import { registerHospital } from '../../services/api';
import './HospitalRegistration.css';

const HospitalRegistration = () => {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [formData, setFormData] = useState({
    name: '',
    licenseNumber: '',
    type: '',
    location: '',
    city: '',
    stateProvince: '',
    pincode: '',
    contactNumber: '',
    emailAddress: '',
    internalBloodBank: false
  });
  
  const [hospitalImage, setHospitalImage] = useState(null);
  const [hospitalImagePreview, setHospitalImagePreview] = useState(null);
  const [registrationPdf, setRegistrationPdf] = useState(null);
  const [coordinates, setCoordinates] = useState(null);
  const [geoLoading, setGeoLoading] = useState(false);

  // Image dropzone
  const { getRootProps: getImageRootProps, getInputProps: getImageInputProps } = useDropzone({
    accept: { 'image/*': ['.jpeg', '.jpg', '.png', '.gif', '.webp'] },
    multiple: false,
    onDrop: (acceptedFiles) => {
      if (acceptedFiles && acceptedFiles.length > 0) {
        const file = acceptedFiles[0];
        setHospitalImage(file);
        setHospitalImagePreview(URL.createObjectURL(file));
        toast.success('Hospital image uploaded!');
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
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  const handleFindCoordinates = async () => {
    const { location, city, stateProvince } = formData;
    if (!location && !city && !stateProvince) {
      toast.error('Please enter at least one address field');
      return;
    }

    setGeoLoading(true);
    try {
      const result = await geocodeAddress(location, city, stateProvince);
      if (result) {
        setCoordinates(result.coordinates);
        if (result.pincode) {
          setFormData(prev => ({ ...prev, pincode: result.pincode }));
        }
        toast.success('Coordinates found!');
      } else {
        toast.error('Could not find coordinates for this address');
      }
    } catch (error) {
      toast.error('Failed to geocode address');
    } finally {
      setGeoLoading(false);
    }
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
      submitData.append('lic_no', formData.licenseNumber);
      submitData.append('type', formData.type);
      submitData.append('contact_no', formData.contactNumber);
      submitData.append('email', formData.emailAddress);
      submitData.append('internal_bb', formData.internalBloodBank.toString());
      
      // Add location as JSON
      const location = {
        street: formData.location,
        city: formData.city,
        state: formData.stateProvince,
        pincode: formData.pincode
      };
      submitData.append('location', JSON.stringify(location));
      
      // Add files if present
      if (hospitalImage) {
        submitData.append('profile_pic', hospitalImage);
      }
      if (registrationPdf) {
        submitData.append('scanned_copy', registrationPdf);
      }
      
      const response = await registerHospital(submitData);
      
      if (response.success) {
        toast.success('Hospital registered successfully!');
        setTimeout(() => {
          navigate('/hospital');
        }, 1500);
      } else {
        toast.error(response.error || 'Registration failed');
      }
    } catch (error) {
      toast.error(error.message || 'Failed to register hospital');
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
    <div className="hospital-registration-container">
      <Toaster position="top-right" />
      
      <div className="registration-content">
        <form onSubmit={handleSubmit} className="registration-form">
          
          {/* Header Section */}
          <div className="form-header">
            <Hospital className="header-icon" size={40} />
            <h1 className="header-title">Hospital Registration</h1>
            <p className="header-subtitle">Join the healthcare network</p>
          </div>

          {/* Hospital Image Section */}
          <div className="image-upload-section">
            <div {...getImageRootProps()} className="image-dropzone">
              <input {...getImageInputProps()} />
              {hospitalImagePreview ? (
                <img 
                  src={hospitalImagePreview} 
                  alt="Hospital" 
                  className="image-preview"
                />
              ) : (
                <div className="upload-placeholder">
                  <Upload className="upload-icon" size={50} />
                  <p>Click or drag hospital image here</p>
                </div>
              )}
            </div>
            {hospitalImage && (
              <p className="file-name">{hospitalImage.name}</p>
            )}
          </div>

          {/* Basic Information */}
          <div className="form-section">
            <h2 className="section-header">Basic Information</h2>
            
            <div className="form-group">
              <label htmlFor="name">Name of Hospital *</label>
              <input
                type="text"
                id="name"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                required
                className="form-input"
                placeholder="Enter hospital name"
              />
            </div>

            <div className="form-group">
              <label htmlFor="licenseNumber">License Number *</label>
              <input
                type="text"
                id="licenseNumber"
                name="licenseNumber"
                value={formData.licenseNumber}
                onChange={handleInputChange}
                required
                className="form-input"
                placeholder="Enter license number"
              />
            </div>

            <div className="form-group">
              <label htmlFor="type">Hospital Type</label>
              <select
                id="type"
                name="type"
                value={formData.type}
                onChange={handleInputChange}
                className="form-input"
              >
                <option value="">Select Type</option>
                <option value="Government">Government</option>
                <option value="Private">Private</option>
              </select>
            </div>
          </div>

          {/* Registration Document */}
          <div className="form-section pdf-section">
            <h2 className="section-header">Registration Document</h2>
            
            <div {...getPdfRootProps()} className="pdf-dropzone">
              <input {...getPdfInputProps()} />
              <FileText className="pdf-icon" size={40} />
              <p>Click or drag PDF here</p>
            </div>

            {registrationPdf && (
              <div className="pdf-info">
                <FileText size={20} />
                <span className="pdf-filename">{registrationPdf.name}</span>
                <button 
                  type="button"
                  className="btn btn-warning-outline"
                  onClick={openPdf}
                >
                  Open PDF
                </button>
              </div>
            )}
          </div>

          {/* Location Information */}
          <div className="form-section">
            <h2 className="section-header">Location Information</h2>
            
            <div className="form-group">
              <label htmlFor="location">Street Address</label>
              <input
                type="text"
                id="location"
                name="location"
                value={formData.location}
                onChange={handleInputChange}
                className="form-input"
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
                  className="form-input"
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
                  className="form-input"
                  placeholder="Enter state"
                />
              </div>
            </div>

            <div className="form-group">
              <label htmlFor="pincode">Pincode</label>
              <input
                type="text"
                id="pincode"
                name="pincode"
                value={formData.pincode}
                onChange={handleInputChange}
                className="form-input"
                placeholder="Enter pincode"
              />
            </div>

            <div className="location-buttons">
              <button 
                type="button"
                className="btn btn-teal"
                onClick={handleFindCoordinates}
                disabled={geoLoading}
              >
                {geoLoading ? <Loader2 className="spin" size={18} /> : <MapPin size={18} />}
                Find Coordinates
              </button>

              <button 
                type="button"
                className="btn btn-teal"
                onClick={handleUseCurrentLocation}
                disabled={geoLoading}
              >
                {geoLoading ? <Loader2 className="spin" size={18} /> : <Navigation size={18} />}
                Current Location
              </button>
            </div>

            {coordinates && (
              <div className="coordinates-display">
                <MapPin size={18} />
                <span>
                  Coordinates: {coordinates.lat.toFixed(6)}, {coordinates.lon.toFixed(6)}
                </span>
              </div>
            )}
          </div>

          {/* Blood Bank Section */}
          <div className="blood-bank-section">
            <label className="checkbox-label">
              <input
                type="checkbox"
                name="internalBloodBank"
                checked={formData.internalBloodBank}
                onChange={handleInputChange}
              />
              <span>Internal Blood Bank Available</span>
              {formData.internalBloodBank ? (
                <CheckCircle className="check-icon" size={20} />
              ) : (
                <Circle className="check-icon" size={20} />
              )}
            </label>
          </div>

          {formData.internalBloodBank && (
            <div className="blood-bank-form">
              <h3 className="blood-bank-title">Blood Bank Details</h3>
              <p className="blood-bank-placeholder">
                Blood Bank registration form will be integrated here
              </p>
            </div>
          )}

          {/* Submit Button */}
          <button 
            type="submit" 
            className="btn btn-submit"
            disabled={loading}
          >
            {loading ? (
              <>
                <Loader2 className="spin" size={20} />
                Registering...
              </>
            ) : (
              'Register Hospital'
            )}
          </button>
        </form>
      </div>
    </div>
  );
};

export default HospitalRegistration;
