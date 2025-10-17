import React, { useState, useEffect, useRef } from 'react';
import { MapPin, Calendar, Clock, Building2, Save, X, CheckCircle } from 'lucide-react';

// Shadcn UI Components
const Button = ({ children, variant = "default", size = "default", className = "", disabled, onClick, type = "button" }) => {
  const baseStyles = "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50";
  const variants = {
    default: "bg-red-600 text-white hover:bg-red-700",
    outline: "border-2 border-gray-300 text-gray-700 hover:bg-gray-50",
    ghost: "hover:bg-gray-100 text-gray-900",
    destructive: "bg-red-100 text-red-700 hover:bg-red-200"
  };
  const sizes = {
    default: "h-10 px-4 py-2",
    sm: "h-9 px-3 text-sm",
    lg: "h-11 px-8",
    icon: "h-10 w-10"
  };
  
  return (
    <button 
      type={type}
      className={`${baseStyles} ${variants[variant]} ${sizes[size]} ${className}`}
      disabled={disabled}
      onClick={onClick}
    >
      {children}
    </button>
  );
};

const Input = ({ className = "", ...props }) => (
  <input
    className={`flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent disabled:cursor-not-allowed disabled:opacity-50 ${className}`}
    {...props}
  />
);

const Label = ({ children, className = "", htmlFor }) => (
  <label htmlFor={htmlFor} className={`text-sm font-medium text-gray-700 ${className}`}>
    {children}
  </label>
);

const Textarea = ({ className = "", ...props }) => (
  <textarea
    className={`flex min-h-[80px] w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent disabled:cursor-not-allowed disabled:opacity-50 ${className}`}
    {...props}
  />
);

const Card = ({ children, className = "" }) => (
  <div className={`rounded-lg border border-gray-200 bg-white shadow-sm ${className}`}>
    {children}
  </div>
);

const Alert = ({ children, variant = "default", className = "" }) => {
  const variants = {
    default: "bg-blue-50 text-blue-900 border-blue-200",
    success: "bg-green-50 text-green-900 border-green-200",
    error: "bg-red-50 text-red-900 border-red-200"
  };
  
  return (
    <div className={`rounded-lg border p-4 ${variants[variant]} ${className}`}>
      {children}
    </div>
  );
};

// Leaflet Map Component
const LeafletMap = ({ onLocationSelect, selectedLocation }) => {
  const mapRef = useRef(null);
  const mapInstanceRef = useRef(null);
  const markerRef = useRef(null);

  useEffect(() => {
    const loadLeaflet = async () => {
      if (typeof window.L !== 'undefined') {
        initMap();
        return;
      }

      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.css';
      document.head.appendChild(link);

      const script = document.createElement('script');
      script.src = 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.js';
      script.onload = initMap;
      document.body.appendChild(script);
    };

    const initMap = () => {
      if (!mapRef.current || mapInstanceRef.current) return;

      const L = window.L;
      const map = L.map(mapRef.current).setView([20.5937, 78.9629], 5);
      
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors',
        maxZoom: 19
      }).addTo(map);

      const redIcon = L.icon({
        iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
        shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
      });

      map.on('click', (e) => {
        const { lat, lng } = e.latlng;
        
        if (markerRef.current) {
          map.removeLayer(markerRef.current);
        }
        
        markerRef.current = L.marker([lat, lng], { icon: redIcon })
          .addTo(map)
          .bindPopup('<b>Camp Location</b><br>Lat: ' + lat.toFixed(4) + '<br>Lng: ' + lng.toFixed(4))
          .openPopup();
        
        onLocationSelect({ lat, lng });
      });

      if (selectedLocation) {
        markerRef.current = L.marker([selectedLocation.lat, selectedLocation.lng], { icon: redIcon })
          .addTo(map)
          .bindPopup('<b>Camp Location</b>')
          .openPopup();
        map.setView([selectedLocation.lat, selectedLocation.lng], 13);
      }

      mapInstanceRef.current = map;
    };

    loadLeaflet();

    return () => {
      if (mapInstanceRef.current) {
        mapInstanceRef.current.remove();
        mapInstanceRef.current = null;
      }
    };
  }, []);

  useEffect(() => {
    if (mapInstanceRef.current && selectedLocation && window.L) {
      const L = window.L;
      
      if (markerRef.current) {
        mapInstanceRef.current.removeLayer(markerRef.current);
      }

      const redIcon = L.icon({
        iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
        shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41],
        popupAnchor: [1, -34],
        shadowSize: [41, 41]
      });

      markerRef.current = L.marker([selectedLocation.lat, selectedLocation.lng], { icon: redIcon })
        .addTo(mapInstanceRef.current)
        .bindPopup('<b>Camp Location</b>')
        .openPopup();
      
      mapInstanceRef.current.setView([selectedLocation.lat, selectedLocation.lng], 13);
    }
  }, [selectedLocation]);

  return (
    <div 
      ref={mapRef} 
      className="w-full h-full rounded-lg"
      style={{ minHeight: '400px' }}
    />
  );
};

// Main Blood Camp Form Component
const BloodCampForm = () => {
  const [formData, setFormData] = useState({
    organizationName: '',
    campDate: '',
    startTime: '',
    endTime: '',
    address: '',
    description: '',
    contactPerson: '',
    contactPhone: '',
    contactEmail: '',
    expectedDonors: ''
  });

  const [location, setLocation] = useState(null);
  const [submitStatus, setSubmitStatus] = useState(null);
  const [errors, setErrors] = useState({});

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: null }));
    }
  };

  const handleLocationSelect = (loc) => {
    setLocation(loc);
    if (errors.location) {
      setErrors(prev => ({ ...prev, location: null }));
    }
  };

  const validateForm = () => {
    const newErrors = {};

    if (!formData.organizationName.trim()) {
      newErrors.organizationName = 'Organization name is required';
    }
    if (!formData.campDate) {
      newErrors.campDate = 'Camp date is required';
    }
    if (!formData.startTime) {
      newErrors.startTime = 'Start time is required';
    }
    if (!formData.endTime) {
      newErrors.endTime = 'End time is required';
    }
    if (!formData.address.trim()) {
      newErrors.address = 'Address is required';
    }
    if (!location) {
      newErrors.location = 'Please select a location on the map';
    }
    if (!formData.contactPerson.trim()) {
      newErrors.contactPerson = 'Contact person is required';
    }
    if (!formData.contactPhone.trim()) {
      newErrors.contactPhone = 'Contact phone is required';
    }
    if (!formData.contactEmail.trim()) {
      newErrors.contactEmail = 'Contact email is required';
    } else if (!/\S+@\S+\.\S+/.test(formData.contactEmail)) {
      newErrors.contactEmail = 'Invalid email format';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

//  const handleSubmit = async () => {
//    if (!validateForm()) {
//      setSubmitStatus({ type: 'error', message: 'Please fill in all required fields' });
//      return;
//    }
//
//    setSubmitStatus({ type: 'loading', message: 'Submitting...' });
//
//    try {
//      const response = await fetch('http://10.79.215.218:3000/add-camp', {
//        method: 'POST',
//        headers: {
//          'Content-Type': 'application/json',
//        },
//        body: JSON.stringify({
//          ...formData,
//          location: location,
//          coordinates: {
//            latitude: location.lat,
//            longitude: location.lng
//          }
//        })
//      });
//
//      if (!response.ok) {
//        throw new Error('Failed to create camp');
//      }
//
//      const data = await response.json();
//      
//      setSubmitStatus({ 
//        type: 'success', 
//        message: 'Blood donation camp registered successfully!' 
//      });
//
//      setTimeout(() => {
//        setFormData({
//          organizationName: '',
//          campDate: '',
//          startTime: '',
//          endTime: '',
//          address: '',
//          description: '',
//          contactPerson: '',
//          contactPhone: '',
//          contactEmail: '',
//          expectedDonors: ''
//        });
//        setLocation(null);
//        setSubmitStatus(null);
//      }, 2000);
//
//    } catch (error) {
//      console.error('Error submitting form:', error);
//      setSubmitStatus({ 
//        type: 'error', 
//        message: 'Failed to register camp. Please try again.' 
//      });
//    }
//  };

  const handleSubmit = async () => {
  if (!validateForm()) {
    setSubmitStatus({ type: 'error', message: 'Please fill in all required fields' });
    return;
  }

  setSubmitStatus({ type: 'loading', message: 'Submitting...' });

  try {
    // Transform data to match backend expectations
    const campData = {
      organiser: {
        name: formData.organizationName,
        description: formData.description,
        contactPerson: formData.contactPerson,
        contactPhone: formData.contactPhone,
        contactEmail: formData.contactEmail,
        expectedDonors: formData.expectedDonors ? parseInt(formData.expectedDonors) : null
      },
      location: {
        address: formData.address,
        coordinates: {
          latitude: location.lat,
          longitude: location.lng
        }
      },
      time: {
        date: formData.campDate,
        startTime: formData.startTime,
        endTime: formData.endTime
      }
    };

    const response = await fetch('http://10.79.215.218:3000/add-camp', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(campData)
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(errorData.error || 'Failed to create camp');
    }

    const data = await response.json();
    
    setSubmitStatus({ 
      type: 'success', 
      message: 'Blood donation camp registered successfully!' 
    });

    setTimeout(() => {
      setFormData({
        organizationName: '',
        campDate: '',
        startTime: '',
        endTime: '',
        address: '',
        description: '',
        contactPerson: '',
        contactPhone: '',
        contactEmail: '',
        expectedDonors: ''
      });
      setLocation(null);
      setSubmitStatus(null);
    }, 2000);

  } catch (error) {
    console.error('Error submitting form:', error);
    setSubmitStatus({ 
      type: 'error', 
      message: error.message || 'Failed to register camp. Please try again.' 
    });
  }
};

  const handleReset = () => {
    setFormData({
      organizationName: '',
      campDate: '',
      startTime: '',
      endTime: '',
      address: '',
      description: '',
      contactPerson: '',
      contactPhone: '',
      contactEmail: '',
      expectedDonors: ''
    });
    setLocation(null);
    setErrors({});
    setSubmitStatus(null);
  };

  return (
    <div className="min-h-screen bg-gray-50 py-8 px-4 sm:px-6 lg:px-8">
      <div className="max-w-6xl mx-auto">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Register Blood Donation Camp
          </h1>
          <p className="text-gray-600">
            Schedule and organize blood donation camps in your area
          </p>
        </div>

        {submitStatus && (
          <Alert 
            variant={submitStatus.type === 'success' ? 'success' : 'error'} 
            className="mb-6 flex items-center gap-2"
          >
            {submitStatus.type === 'success' ? (
              <CheckCircle className="w-5 h-5" />
            ) : (
              <X className="w-5 h-5" />
            )}
            <span>{submitStatus.message}</span>
          </Alert>
        )}

        <div className="grid lg:grid-cols-2 gap-8">
          <div className="space-y-6">
            <Card className="p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <Building2 className="w-5 h-5 text-red-600" />
                Organization Details
              </h2>
              
              <div className="space-y-4">
                <div>
                  <Label htmlFor="organizationName">
                    Organization Name <span className="text-red-500">*</span>
                  </Label>
                  <Input
                    id="organizationName"
                    name="organizationName"
                    value={formData.organizationName}
                    onChange={handleInputChange}
                    placeholder="Enter organization name"
                    className={errors.organizationName ? 'border-red-500' : ''}
                  />
                  {errors.organizationName && (
                    <p className="text-xs text-red-500 mt-1">{errors.organizationName}</p>
                  )}
                </div>

                <div>
                  <Label htmlFor="description">Description</Label>
                  <Textarea
                    id="description"
                    name="description"
                    value={formData.description}
                    onChange={handleInputChange}
                    placeholder="Brief description about the camp"
                    rows={3}
                  />
                </div>

                <div>
                  <Label htmlFor="expectedDonors">Expected Donors</Label>
                  <Input
                    id="expectedDonors"
                    name="expectedDonors"
                    type="number"
                    value={formData.expectedDonors}
                    onChange={handleInputChange}
                    placeholder="Estimated number of donors"
                    min="1"
                  />
                </div>
              </div>
            </Card>

            <Card className="p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <Calendar className="w-5 h-5 text-red-600" />
                Schedule
              </h2>
              
              <div className="space-y-4">
                <div>
                  <Label htmlFor="campDate">
                    Camp Date <span className="text-red-500">*</span>
                  </Label>
                  <Input
                    id="campDate"
                    name="campDate"
                    type="date"
                    value={formData.campDate}
                    onChange={handleInputChange}
                    min={new Date().toISOString().split('T')[0]}
                    className={errors.campDate ? 'border-red-500' : ''}
                  />
                  {errors.campDate && (
                    <p className="text-xs text-red-500 mt-1">{errors.campDate}</p>
                  )}
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label htmlFor="startTime">
                      Start Time <span className="text-red-500">*</span>
                    </Label>
                    <Input
                      id="startTime"
                      name="startTime"
                      type="time"
                      value={formData.startTime}
                      onChange={handleInputChange}
                      className={errors.startTime ? 'border-red-500' : ''}
                    />
                    {errors.startTime && (
                      <p className="text-xs text-red-500 mt-1">{errors.startTime}</p>
                    )}
                  </div>

                  <div>
                    <Label htmlFor="endTime">
                      End Time <span className="text-red-500">*</span>
                    </Label>
                    <Input
                      id="endTime"
                      name="endTime"
                      type="time"
                      value={formData.endTime}
                      onChange={handleInputChange}
                      className={errors.endTime ? 'border-red-500' : ''}
                    />
                    {errors.endTime && (
                      <p className="text-xs text-red-500 mt-1">{errors.endTime}</p>
                    )}
                  </div>
                </div>
              </div>
            </Card>

            <Card className="p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <MapPin className="w-5 h-5 text-red-600" />
                Location
              </h2>
              
              <div className="space-y-4">
                <div>
                  <Label htmlFor="address">
                    Address <span className="text-red-500">*</span>
                  </Label>
                  <Textarea
                    id="address"
                    name="address"
                    value={formData.address}
                    onChange={handleInputChange}
                    placeholder="Full address of the camp"
                    rows={3}
                    className={errors.address ? 'border-red-500' : ''}
                  />
                  {errors.address && (
                    <p className="text-xs text-red-500 mt-1">{errors.address}</p>
                  )}
                </div>

                {location && (
                  <div className="bg-green-50 border border-green-200 rounded-lg p-3 text-sm">
                    <p className="text-green-800 font-medium">Location Selected:</p>
                    <p className="text-green-700">
                      Lat: {location.lat.toFixed(6)}, Lng: {location.lng.toFixed(6)}
                    </p>
                  </div>
                )}
                {errors.location && (
                  <p className="text-xs text-red-500">{errors.location}</p>
                )}
              </div>
            </Card>

            <Card className="p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4 flex items-center gap-2">
                <Clock className="w-5 h-5 text-red-600" />
                Contact Information
              </h2>
              
              <div className="space-y-4">
                <div>
                  <Label htmlFor="contactPerson">
                    Contact Person <span className="text-red-500">*</span>
                  </Label>
                  <Input
                    id="contactPerson"
                    name="contactPerson"
                    value={formData.contactPerson}
                    onChange={handleInputChange}
                    placeholder="Full name"
                    className={errors.contactPerson ? 'border-red-500' : ''}
                  />
                  {errors.contactPerson && (
                    <p className="text-xs text-red-500 mt-1">{errors.contactPerson}</p>
                  )}
                </div>

                <div>
                  <Label htmlFor="contactPhone">
                    Phone Number <span className="text-red-500">*</span>
                  </Label>
                  <Input
                    id="contactPhone"
                    name="contactPhone"
                    type="tel"
                    value={formData.contactPhone}
                    onChange={handleInputChange}
                    placeholder="+91 98765 43210"
                    className={errors.contactPhone ? 'border-red-500' : ''}
                  />
                  {errors.contactPhone && (
                    <p className="text-xs text-red-500 mt-1">{errors.contactPhone}</p>
                  )}
                </div>

                <div>
                  <Label htmlFor="contactEmail">
                    Email <span className="text-red-500">*</span>
                  </Label>
                  <Input
                    id="contactEmail"
                    name="contactEmail"
                    type="email"
                    value={formData.contactEmail}
                    onChange={handleInputChange}
                    placeholder="email@example.com"
                    className={errors.contactEmail ? 'border-red-500' : ''}
                  />
                  {errors.contactEmail && (
                    <p className="text-xs text-red-500 mt-1">{errors.contactEmail}</p>
                  )}
                </div>
              </div>
            </Card>
          </div>

          <div className="lg:sticky lg:top-8 lg:self-start">
            <Card className="p-6">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">
                Select Camp Location <span className="text-red-500">*</span>
              </h2>
              <p className="text-sm text-gray-600 mb-4">
                Click on the map to pinpoint the exact location of your blood donation camp
              </p>
              <div className="rounded-lg overflow-hidden border border-gray-200">
                <LeafletMap 
                  onLocationSelect={handleLocationSelect}
                  selectedLocation={location}
                />
              </div>
            </Card>
          </div>
        </div>

        <div className="mt-8 flex gap-4 justify-end">
          <Button 
            variant="outline" 
            onClick={handleReset}
          >
            <X className="w-4 h-4 mr-2" />
            Reset
          </Button>
          <Button 
            onClick={handleSubmit}
            disabled={submitStatus?.type === 'loading'}
          >
            <Save className="w-4 h-4 mr-2" />
            {submitStatus?.type === 'loading' ? 'Submitting...' : 'Register Camp'}
          </Button>
        </div>
      </div>
    </div>
  );
};

export default BloodCampForm;
