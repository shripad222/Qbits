//import React, { useState, useEffect } from 'react';
//import { Search, MapPin, Droplet, Activity } from 'lucide-react';
//import { BloodBankBriefInfoCard } from './BloodBankBreifInfoCard';
//
//const Button = ({ children, variant = "default", size = "default", className = "", ...props }) => {
//  const baseStyles = "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50";
//  const variants = {
//    default: "bg-red-600 text-white hover:bg-red-700",
//    outline: "border border-gray-300 bg-white hover:bg-gray-50 text-gray-700",
//    ghost: "hover:bg-gray-100 text-gray-700"
//  };
//  const sizes = {
//    default: "h-10 px-4 py-2",
//    sm: "h-9 px-3 text-sm",
//    lg: "h-11 px-8",
//    icon: "h-10 w-10"
//  };
//  
//  return (
//    <button 
//      className={`${baseStyles} ${variants[variant]} ${sizes[size]} ${className}`}
//      {...props}
//    >
//      {children}
//    </button>
//  );
//};
//
//const Input = ({ className = "", ...props }) => (
//  <input
//    className={`flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent disabled:cursor-not-allowed disabled:opacity-50 ${className}`}
//    {...props}
//  />
//);
//
//const Select = ({ children, value, onValueChange, placeholder }) => {
//  const [isOpen, setIsOpen] = useState(false);
//  
//  return (
//    <div className="relative">
//      <button
//        onClick={() => setIsOpen(!isOpen)}
//        className="flex h-10 w-full items-center justify-between rounded-md border border-gray-300 bg-white px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-500 hover:bg-gray-50"
//      >
//        <span className={value ? "text-gray-900" : "text-gray-400"}>
//          {value || placeholder}
//        </span>
//        <svg className="h-4 w-4 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
//          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
//        </svg>
//      </button>
//      
//      {isOpen && (
//        <div className="absolute z-50 mt-1 w-full rounded-md border border-gray-200 bg-white shadow-lg">
//          <div className="p-1">
//            {React.Children.map(children, child =>
//              React.cloneElement(child, {
//                onClick: () => {
//                  onValueChange(child.props.value);
//                  setIsOpen(false);
//                }
//              })
//            )}
//          </div>
//        </div>
//      )}
//    </div>
//  );
//};
//
//const SelectItem = ({ children, value, onClick }) => (
//  <div
//    className="relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm hover:bg-gray-100 focus:bg-gray-100"
//    onClick={onClick}
//  >
//    {children}
//  </div>
//);
//
//const Card = ({ children, className = "" }) => (
//  <div className={`rounded-lg border border-gray-200 bg-white shadow-sm ${className}`}>
//    {children}
//  </div>
//);
//
//const Badge = ({ children, variant = "default" }) => {
//  const variants = {
//    default: "bg-gray-100 text-gray-800",
//    success: "bg-green-100 text-green-800",
//    warning: "bg-amber-100 text-amber-800",
//    danger: "bg-red-100 text-red-800"
//  };
//  
//  return (
//    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${variants[variant]}`}>
//      {children}
//    </span>
//  );
//};
//
//
//const SearchForBlood = () => {
//  const bloodGroups = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"];
//  const bloodComponents = [
//    "Whole Blood",
//    "Packed Red Blood Cells",
//    "Platelets",
//    "Fresh Frozen Plasma",
//    "Cryoprecipitate"
//  ];
//
//  const [searchParams, setSearchParams] = useState({
//    bloodGroup: "",
//    component: "",
//    radius: "",
//    location: ""
//  });
//
//  const [searchResults, setSearchResults] = useState([]);
//  const [isLoading, setIsLoading] = useState(false);
//  const [allBloodBanks, setAllBloodBanks] = useState([]);
//  const [initialLoading, setInitialLoading] = useState(true);
//
//  // Fetch all blood banks on component mount
//  useEffect(() => {
//    const fetchAllBloodBanks = async () => {
//      try {
//        const response = await fetch('http://10.79.215.218:3000/get-all-bloodbanks');
//        const data = await response.json();
//        
//        if (data.success) {
//          // Transform data to ensure all fields exist, use '---' for missing fields
//          const transformedData = data.bloodBanks.map(bank => ({
//            id: bank.id || '---',
//            name: bank.name || '---',
//            address: bank.address || '---',
//            distance: bank.distance || '---',
//            available: bank.available || '---',
//            lastUpdated: bank.lastUpdated || '---',
//            ...bank
//          }));
//          setAllBloodBanks(transformedData);
//          setSearchResults(transformedData);
//        }
//      } catch (error) {
//        console.error('Error fetching blood banks:', error);
//      } finally {
//        setInitialLoading(false);
//      }
//    };
//
//    fetchAllBloodBanks();
//  }, []);
//
//  // Handle search - filter the fetched blood banks
//  const handleSearch = async () => {
//    setIsLoading(true);
//    
//    try {
//      // Filter blood banks based on search params
//      let filtered = allBloodBanks;
//
//      if (searchParams.bloodGroup) {
//        filtered = filtered.filter(bank => 
//          bank.bloodGroup === searchParams.bloodGroup
//        );
//      }
//
//      if (searchParams.component) {
//        filtered = filtered.filter(bank =>
//          bank.component === searchParams.component
//        );
//      }
//
//      setSearchResults(filtered);
//    } catch (error) {
//      console.error('Search error:', error);
//      setSearchResults([]);
//    } finally {
//      setIsLoading(false);
//    }
//  };
//
//  if (initialLoading) {
//    return (
//      <div className="min-h-screen bg-gray-50 p-6 flex items-center justify-center">
//        <div className="text-center">
//          <Droplet className="w-12 h-12 text-red-600 mx-auto mb-4 animate-pulse" />
//          <p className="text-gray-600">Loading blood banks...</p>
//        </div>
//      </div>
//    );
//  }
//
//  return (
//    <div className="min-h-screen bg-gray-50 p-6">
//      <div className="max-w-4xl mx-auto">
//        {/* Header */}
//        <div className="mb-8 flex items-center flex-col">
//          <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
//            <Droplet className="w-8 h-8 text-red-600" /> Find Blood Availability
//          </h1>
//          <p className="text-gray-600 mt-2">Search for blood banks near you with available blood units</p>
//        </div>
//
//        {/* Search Form */}
//        <Card className="p-6 mb-6">
//          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
//            {/* Blood Group Selection */}
//            <div>
//              <label className="block text-sm font-medium text-gray-700 mb-2">
//                Blood Group *
//              </label>
//              <Select
//                value={searchParams.bloodGroup}
//                onValueChange={(value) => setSearchParams({...searchParams, bloodGroup: value})}
//                placeholder="Select blood group"
//              >
//                {bloodGroups.map((group) => (
//                  <SelectItem key={group} value={group}>
//                    {group}
//                  </SelectItem>
//                ))}
//              </Select>
//            </div>
//
//            {/* Component Selection */}
//            <div>
//              <label className="block text-sm font-medium text-gray-700 mb-2">
//                Component *
//              </label>
//              <Select
//                value={searchParams.component}
//                onValueChange={(value) => setSearchParams({...searchParams, component: value})}
//                placeholder="Select component"
//              >
//                {bloodComponents.map((comp) => (
//                  <SelectItem key={comp} value={comp}>
//                    {comp}
//                  </SelectItem>
//                ))}
//              </Select>
//            </div>
//
//            {/* Radius Input */}
//            <div>
//              <label className="block text-sm font-medium text-gray-700 mb-2">
//                Search Radius (km) *
//              </label>
//              <Input
//                type="number"
//                placeholder="e.g., 10"
//                value={searchParams.radius}
//                onChange={(e) => setSearchParams({...searchParams, radius: e.target.value})}
//                min="1"
//                max="100"
//              />
//            </div>
//
//            {/* Search Button */}
//            <div className="flex items-end">
//              <Button
//                onClick={handleSearch}
//                disabled={!searchParams.bloodGroup || !searchParams.component || !searchParams.radius || isLoading}
//                className="w-full"
//              >
//                {isLoading ? (
//                  <>Searching...</>
//                ) : (
//                  <>
//                    <Search className="w-4 h-4 mr-2" />
//                    Search
//                  </>
//                )}
//              </Button>
//            </div>
//          </div>
//        </Card>
//
//        {/* Results Section */}
//        {searchResults.length > 0 && (
//          <div>
//            <div className="flex items-center justify-between mb-4">
//              <h2 className="text-xl font-semibold text-gray-900">
//                Found {searchResults.length} blood bank(s)
//              </h2>
//              <Badge variant="default">
//                {searchParams.bloodGroup || 'All'} • {searchParams.component || 'All'}
//              </Badge>
//            </div>
//
//            <div className="space-y-4">
//              {searchResults.map((bloodBank) => (
//                <BloodBankBriefInfoCard key={bloodBank.id} bloodBank={bloodBank} />
//              ))}
//            </div>
//          </div>
//        )}
//
//        {/* Empty State */}
//        {!isLoading && searchResults.length === 0 && searchParams.bloodGroup && (
//          <Card className="p-12 text-center">
//            <Droplet className="w-16 h-16 text-gray-300 mx-auto mb-4" />
//            <h3 className="text-lg font-medium text-gray-900 mb-2">No results found</h3>
//            <p className="text-gray-600">Try adjusting your search criteria or increasing the radius</p>
//          </Card>
//        )}
//      </div>
//    </div>
//  );
//};
//
//export default SearchForBlood;

import React, { useState, useEffect } from 'react';
import { Search, MapPin, Droplet, Activity, Building2, X, Clock, Phone, Mail, ArrowUpRight } from 'lucide-react';

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

const Input = ({ className = "", ...props }) => (
  <input
    className={`flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent disabled:cursor-not-allowed disabled:opacity-50 ${className}`}
    {...props}
  />
);

const Select = ({ children, value, onValueChange, placeholder }) => {
  const [isOpen, setIsOpen] = useState(false);
  
  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex h-10 w-full items-center justify-between rounded-md border border-gray-300 bg-white px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-500 hover:bg-gray-50"
      >
        <span className={value ? "text-gray-900" : "text-gray-400"}>
          {value || placeholder}
        </span>
        <svg className="h-4 w-4 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </button>
      
      {isOpen && (
        <div className="absolute z-50 mt-1 w-full rounded-md border border-gray-200 bg-white shadow-lg">
          <div className="p-1">
            {React.Children.map(children, child =>
              React.cloneElement(child, {
                onClick: () => {
                  onValueChange(child.props.value);
                  setIsOpen(false);
                }
              })
            )}
          </div>
        </div>
      )}
    </div>
  );
};

const SelectItem = ({ children, value, onClick }) => (
  <div
    className="relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm hover:bg-gray-100 focus:bg-gray-100"
    onClick={onClick}
  >
    {children}
  </div>
);

const Card = ({ children, className = "" }) => (
  <div className={`rounded-lg border border-gray-200 bg-white shadow-sm ${className}`}>
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

const BloodPopupCard = ({ bloodBank, onClose }) => {
  return (
    <div>
      <div className="relative h-48 bg-gradient-to-br from-red-50 to-red-100">
        <div className="absolute inset-0 flex items-center justify-center">
          {bloodBank.profile_img && bloodBank.profile_img !== '---' ? (
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

      <div className="p-6 space-y-6">
        <div>
          <div className="flex items-start justify-between mb-2">
            <h2 className="text-2xl font-bold text-gray-900">{bloodBank.name || '---'}</h2>
            <Badge variant={(bloodBank.is_open === true || bloodBank.is_open === 'true') ? "success" : "danger"}>
              {(bloodBank.is_open === true || bloodBank.is_open === 'true') ? "Open Now" : "Closed"}
            </Badge>
          </div>
          <div className="flex items-center gap-2 text-gray-600">
            <MapPin className="w-4 h-4" />
            <p className="text-sm">{bloodBank.address || '---'}</p>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-1">
            <div className="flex items-center gap-2 text-gray-700">
              <Clock className="w-4 h-4 text-red-600" />
              <span className="text-sm font-medium">Working Hours</span>
            </div>
            <p className="text-sm text-gray-600 ml-6">{bloodBank.working_hours || '---'}</p>
          </div>

          <div className="space-y-1">
            <div className="flex items-center gap-2 text-gray-700">
              <Phone className="w-4 h-4 text-red-600" />
              <span className="text-sm font-medium">Contact</span>
            </div>
            <p className="text-sm text-gray-600 ml-6">{bloodBank.phone || '---'}</p>
          </div>

          {bloodBank.email && bloodBank.email !== '---' && (
            <div className="space-y-1 col-span-2">
              <div className="flex items-center gap-2 text-gray-700">
                <Mail className="w-4 h-4 text-red-600" />
                <span className="text-sm font-medium">Email</span>
              </div>
              <p className="text-sm text-gray-600 ml-6">{bloodBank.email}</p>
            </div>
          )}
        </div>

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

const SearchForBlood = () => {
  const bloodGroups = ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"];
  const bloodComponents = [
    "Whole Blood",
    "Packed Red Blood Cells",
    "Platelets",
    "Fresh Frozen Plasma",
    "Cryoprecipitate"
  ];

  const [searchParams, setSearchParams] = useState({
    bloodGroup: "",
    component: "",
    radius: "",
    location: ""
  });

  const [searchResults, setSearchResults] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [allBloodBanks, setAllBloodBanks] = useState([]);
  const [initialLoading, setInitialLoading] = useState(true);
  const [selectedBank, setSelectedBank] = useState(null);

  // Fetch all blood banks on component mount
  useEffect(() => {
    const fetchAllBloodBanks = async () => {
      try {
        const response = await fetch('http://10.79.215.218:3000/get-all-bloodbanks');
        const data = await response.json();
        
        if (data.success) {
          const transformedData = data.bloodBanks.map(bank => ({
            id: bank.id || '---',
            name: bank.name || '---',
            address: bank.address || '---',
            distance: bank.distance || '---',
            available: bank.available || '---',
            lastUpdated: bank.lastUpdated || '---',
            phone: bank.phone || '---',
            email: bank.email || '---',
            working_hours: bank.working_hours || '---',
            profile_img: bank.profile_img || '---',
            is_open: bank.is_open || false,
            ...bank
          }));
          setAllBloodBanks(transformedData);
          setSearchResults(transformedData);
        }
      } catch (error) {
        console.error('Error fetching blood banks:', error);
      } finally {
        setInitialLoading(false);
      }
    };

    fetchAllBloodBanks();
  }, []);

  // Handle search - filter the fetched blood banks
  const handleSearch = async () => {
    setIsLoading(true);
    
    try {
      let filtered = allBloodBanks;

      if (searchParams.bloodGroup) {
        filtered = filtered.filter(bank => 
          bank.bloodGroup === searchParams.bloodGroup
        );
      }

      if (searchParams.component) {
        filtered = filtered.filter(bank =>
          bank.component === searchParams.component
        );
      }

      setSearchResults(filtered);
    } catch (error) {
      console.error('Search error:', error);
      setSearchResults([]);
    } finally {
      setIsLoading(false);
    }
  };

  if (initialLoading) {
    return (
      <div className="min-h-screen bg-gray-50 p-6 flex items-center justify-center">
        <div className="text-center">
          <Droplet className="w-12 h-12 text-red-600 mx-auto mb-4 animate-pulse" />
          <p className="text-gray-600">Loading blood banks...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="mb-8 flex items-center flex-col">
          <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
            <Droplet className="w-8 h-8 text-red-600" /> Find Blood Availability
          </h1>
          <p className="text-gray-600 mt-2">Search for blood banks near you with available blood units</p>
        </div>

        {/* Search Form */}
        <Card className="p-6 mb-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Blood Group
              </label>
              <Select
                value={searchParams.bloodGroup}
                onValueChange={(value) => setSearchParams({...searchParams, bloodGroup: value})}
                placeholder="Select blood group"
              >
                {bloodGroups.map((group) => (
                  <SelectItem key={group} value={group}>
                    {group}
                  </SelectItem>
                ))}
              </Select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Component
              </label>
              <Select
                value={searchParams.component}
                onValueChange={(value) => setSearchParams({...searchParams, component: value})}
                placeholder="Select component"
              >
                {bloodComponents.map((comp) => (
                  <SelectItem key={comp} value={comp}>
                    {comp}
                  </SelectItem>
                ))}
              </Select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Search Radius (km)
              </label>
              <Input
                type="number"
                placeholder="e.g., 10"
                value={searchParams.radius}
                onChange={(e) => setSearchParams({...searchParams, radius: e.target.value})}
                min="1"
                max="100"
              />
            </div>

            <div className="flex items-end">
              <Button
                onClick={handleSearch}
                disabled={isLoading}
                className="w-full"
              >
                {isLoading ? (
                  <>Searching...</>
                ) : (
                  <>
                    <Search className="w-4 h-4 mr-2" />
                    Search
                  </>
                )}
              </Button>
            </div>
          </div>
        </Card>

        {/* Results Section */}
        {searchResults.length > 0 && (
          <div>
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold text-gray-900">
                Found {searchResults.length} blood bank(s)
              </h2>
              {(searchParams.bloodGroup || searchParams.component) && (
                <Badge variant="default">
                  {searchParams.bloodGroup || 'All'} • {searchParams.component || 'All'}
                </Badge>
              )}
            </div>

            <div className="space-y-4">
              {searchResults.map((bloodBank) => (
                <div
                  key={bloodBank.id}
                  className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-md transition-all duration-200 hover:border-red-200"
                >
                  <div className="flex items-start justify-between gap-6">
                    <div className="flex gap-4 flex-1">
                      <div className="w-16 h-16 rounded-lg bg-gradient-to-br from-red-50 to-red-100 flex items-center justify-center flex-shrink-0">
                        {bloodBank.profile_img && bloodBank.profile_img !== '---' ? (
                          <img 
                            src={bloodBank.profile_img} 
                            alt={bloodBank.name}
                            className="w-full h-full object-cover rounded-lg"
                          />
                        ) : (
                          <Building2 className="w-8 h-8 text-red-600" />
                        )}
                      </div>

                      <div className="flex-1 min-w-0">
                        <h3 className="text-lg font-semibold text-gray-900 mb-1">
                          {bloodBank.name}
                        </h3>
                        <div className="flex items-center gap-2 text-sm text-gray-600 mb-2">
                          <MapPin className="w-4 h-4 flex-shrink-0" />
                          <span className="truncate">{bloodBank.address}</span>
                        </div>
                        <div className="flex items-center gap-4">
                          <Badge variant={(bloodBank.is_open === true || bloodBank.is_open === 'true') ? "success" : "default"}>
                            {(bloodBank.is_open === true || bloodBank.is_open === 'true') ? "Open" : "Closed"}
                          </Badge>
                          {bloodBank.distance !== '---' && (
                            <span className="text-sm text-gray-600">
                              {bloodBank.distance} km away
                            </span>
                          )}
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 flex-shrink-0">
                      <Button
                        variant="outline"
                        onClick={() => setSelectedBank(bloodBank)}
                      >
                        More Info
                      </Button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Empty State */}
        {!isLoading && searchResults.length === 0 && (searchParams.bloodGroup || searchParams.component) && (
          <Card className="p-12 text-center">
            <Droplet className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">No results found</h3>
            <p className="text-gray-600">Try adjusting your search criteria or increasing the radius</p>
          </Card>
        )}
      </div>

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

export default SearchForBlood;
