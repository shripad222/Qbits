import React, { useState } from 'react';
import { MapPin, Clock, Phone, Mail, Building2, X, Heart, ArrowUpRight } from 'lucide-react';


const Button = ({ children, variant = "default", size = "default", className = "", ...props }) => {
  const baseStyles = "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50";
  const variants = {
    default: "bg-red-600 text-white hover:bg-red-700",
    outline: "border border-gray-300 bg-white hover:bg-gray-50 text-gray-900",
    ghost: "hover:bg-gray-100 text-gray-900",
    link: "text-red-600 underline-offset-4 hover:underline"
  };
  const sizes = {
    default: "h-10 px-4 py-2",
    sm: "h-9 px-3 text-sm",
    lg: "h-11 px-8",
    icon: "h-10 w-10"
  };
  
  return (
    <button 
      className={`${baseStyles} ${variants[variant]} ${sizes[size]} ${className}`}
      {...props}
    >
      {children}
    </button>
  );
};

const Dialog = ({ open, onOpenChange, children }) => {
  if (!open) return null;
  
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      <div 
        className="fixed inset-0 bg-black/50 backdrop-blur-sm"
        onClick={() => onOpenChange(false)}
      />
      <div className="relative z-50 w-full max-w-2xl mx-4">
        {children}
      </div>
    </div>
  );
};

const DialogContent = ({ children, onClose }) => (
  <div className="bg-white rounded-lg shadow-xl overflow-hidden animate-in fade-in zoom-in duration-200">
    <button
      onClick={onClose}
      className="absolute right-4 top-4 rounded-sm opacity-70 hover:opacity-100 transition-opacity z-10"
    >
      <X className="h-5 w-5 text-gray-600" />
      <span className="sr-only">Close</span>
    </button>
    {children}
  </div>
);

const Badge = ({ children, variant = "default", className = "" }) => {
  const variants = {
    default: "bg-gray-100 text-gray-800",
    success: "bg-green-100 text-green-800",
    warning: "bg-amber-100 text-amber-800",
    danger: "bg-red-100 text-red-800",
    blue: "bg-blue-100 text-blue-800"
  };
  
  return (
    <span className={`inline-flex items-center rounded-full px-3 py-1 text-xs font-medium ${variants[variant]} ${className}`}>
      {children}
    </span>
  );
};

// Blood Popup Card Component
const BloodPopupCard = ({ bloodBank, onClose }) => {
  return (
    <div>
      {/* Header with Image */}
      <div className="relative h-48 bg-gradient-to-br from-red-50 to-red-100">
        <div className="absolute inset-0 flex items-center justify-center">
          {bloodBank.profile_img ? (
            <img 
              src={bloodBank.profile_img} 
              alt={bloodBank.name}
              className="w-full h-full object-cover"
            />
          ) : (
            <Building2 className="w-20 h-20 text-red-300" />
          )}
        </div>
      </div>

      {/* Content */}
      <div className="p-6 space-y-6">
        {/* Title and Status */}
        <div>
          <div className="flex items-start justify-between mb-2">
            <h2 className="text-2xl font-bold text-gray-900">{bloodBank.name}</h2>
            <Badge variant={bloodBank.isOpen ? "success" : "danger"}>
              {bloodBank.isOpen ? "Open Now" : "Closed"}
            </Badge>
          </div>
          <div className="flex items-center gap-2 text-gray-600">
            <MapPin className="w-4 h-4" />
            <p className="text-sm">{bloodBank.location}</p>
          </div>
        </div>

        {/* Info Grid */}
        <div className="grid grid-cols-2 gap-4">
          {/* Working Hours */}
          <div className="space-y-1">
            <div className="flex items-center gap-2 text-gray-700">
              <Clock className="w-4 h-4 text-red-600" />
              <span className="text-sm font-medium">Working Hours</span>
            </div>
            <p className="text-sm text-gray-600 ml-6">{bloodBank.working_hours}</p>
          </div>

          {/* Contact */}
          <div className="space-y-1">
            <div className="flex items-center gap-2 text-gray-700">
              <Phone className="w-4 h-4 text-red-600" />
              <span className="text-sm font-medium">Contact</span>
            </div>
            <p className="text-sm text-gray-600 ml-6">{bloodBank.phone}</p>
          </div>

          {/* Email */}
          {bloodBank.email && (
            <div className="space-y-1 col-span-2">
              <div className="flex items-center gap-2 text-gray-700">
                <Mail className="w-4 h-4 text-red-600" />
                <span className="text-sm font-medium">Email</span>
              </div>
              <p className="text-sm text-gray-600 ml-6">{bloodBank.email}</p>
            </div>
          )}
        </div>

        {/* Blood Availability */}
        {bloodBank.bloodAvailability && (
          <div className="bg-gray-50 rounded-lg p-4">
            <h3 className="text-sm font-semibold text-gray-900 mb-3">Blood Availability</h3>
            <div className="grid grid-cols-4 gap-2">
              {Object.entries(bloodBank.bloodAvailability).map(([type, units]) => (
                <Badge 
                  key={type} 
                  variant={units > 0 ? "success" : "default"}
                  className="justify-center"
                >
                  {type}: {units}
                </Badge>
              ))}
            </div>
          </div>
        )}

        {/* Action Buttons */}
        <div className="flex gap-3 pt-4 border-t">
          <Button className="flex-1">
            Request Blood
          </Button>
          <Button variant="outline" size="icon">
            <ArrowUpRight className="w-4 h-4" />
          </Button>
        </div>
      </div>
    </div>
  );
};

// Blood Bank Brief Info Card Component
export const BloodBankBriefInfoCard = ({ searchParams }) => {
  const [selectedBank, setSelectedBank] = useState(null);

  // Mock data - replace with actual API call
  const blood_banks = [
    {
      id: 1,
      name: "City General Hospital Blood Bank",
      location: "123 Medical Avenue, Wardha, Maharashtra",
      profile_img: null,
      working_hours: "24/7",
      phone: "+91 98765 43210",
      email: "bloodbank@cityhospital.com",
      distance: 2.3,
      isOpen: true,
      bloodAvailability: {
        "O+": 12,
        "O-": 3,
        "A+": 8,
        "A-": 2,
        "B+": 6,
        "B-": 1,
        "AB+": 4,
        "AB-": 0
      }
    },
    {
      id: 2,
      name: "Red Cross Blood Centre",
      location: "456 Healthcare Road, Wardha, Maharashtra",
      profile_img: null,
      working_hours: "Mon-Sat: 9 AM - 6 PM",
      phone: "+91 98765 43211",
      email: "contact@redcross.org",
      distance: 4.7,
      isOpen: true,
      bloodAvailability: {
        "O+": 15,
        "O-": 5,
        "A+": 10,
        "A-": 3,
        "B+": 7,
        "B-": 2,
        "AB+": 5,
        "AB-": 1
      }
    },
    {
      id: 3,
      name: "Community Blood Bank",
      location: "789 Wellness Street, Wardha, Maharashtra",
      profile_img: null,
      working_hours: "Mon-Fri: 8 AM - 5 PM",
      phone: "+91 98765 43212",
      email: "info@communityblood.org",
      distance: 6.1,
      isOpen: false,
      bloodAvailability: {
        "O+": 5,
        "O-": 0,
        "A+": 3,
        "A-": 1,
        "B+": 4,
        "B-": 0,
        "AB+": 2,
        "AB-": 0
      }
    }
  ];

  // Backend integration point
  React.useEffect(() => {
    // Fetch blood banks based on searchParams
    const fetchBloodBanks = async () => {
      try {
        const response = await fetch('/api/blood-banks', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(searchParams)
        });
        const data = await response.json();
        // setBloodBanks(data.results);
      } catch (error) {
        console.error('Error fetching blood banks:', error);
      }
    };
    
    // Uncomment when backend is ready
    // fetchBloodBanks();
  }, [searchParams]);

  return (
    <div className="space-y-4">
      {blood_banks.map((bank) => (
        <div
          key={bank.id}
          className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-md transition-all duration-200 hover:border-red-200"
        >
          <div className="flex items-start justify-between gap-6">
            {/* Left Section - Image & Info */}
            <div className="flex gap-4 flex-1">
              {/* Profile Image */}
              <div className="w-16 h-16 rounded-lg bg-gradient-to-br from-red-50 to-red-100 flex items-center justify-center flex-shrink-0">
                {bank.profile_img ? (
                  <img 
                    src={bank.profile_img} 
                    alt={bank.name}
                    className="w-full h-full object-cover rounded-lg"
                  />
                ) : (
                  <Building2 className="w-8 h-8 text-red-600" />
                )}
              </div>

              {/* Info */}
              <div className="flex-1 min-w-0 postion-left">
                <h3 className="text-lg font-semibold text-gray-900 mb-1 flex items-end">
                  {bank.name}
                </h3>
                <div className="flex items-center gap-2 text-sm text-gray-600 mb-2">
                  <MapPin className="w-4 h-4 flex-shrink-0" />
                  <span className="truncate">{bank.location}</span>
                </div>
                <div className="flex items-center gap-4">
                  <Badge variant={bank.isOpen ? "success" : "default"}>
                    {bank.isOpen ? "Open" : "Closed"}
                  </Badge>
                  <span className="text-sm text-gray-600">
                    {bank.distance} km away
                  </span>
                </div>
              </div>
            </div>

            {/* Right Section - Actions */}
            <div className="flex items-center gap-2 flex-shrink-0">
              <Button
                variant="outline"
                onClick={() => setSelectedBank(bank)}
              >
                More Info
              </Button>
            </div>
          </div>
        </div>
      ))}

      {/* Popup Dialog */}
      <Dialog open={!!selectedBank} onOpenChange={() => setSelectedBank(null)}>
        <DialogContent onClose={() => setSelectedBank(null)}>
          {selectedBank && (
            <BloodPopupCard 
              bloodBank={selectedBank} 
              onClose={() => setSelectedBank(null)}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
};