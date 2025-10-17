import React, { useState } from 'react';
import { Search, MapPin, Droplet, Activity } from 'lucide-react';
import { BloodBankBriefInfoCard } from './BloodBankBreifInfoCard';
const Button = ({ children, variant = "default", size = "default", className = "", ...props }) => {
  const baseStyles = "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50";
  const variants = {
    default: "bg-red-600 text-white hover:bg-red-700",
    outline: "border border-gray-300 bg-white hover:bg-gray-50 text-gray-700",
    ghost: "hover:bg-gray-100 text-gray-700"
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

const Badge = ({ children, variant = "default" }) => {
  const variants = {
    default: "bg-gray-100 text-gray-800",
    success: "bg-green-100 text-green-800",
    warning: "bg-amber-100 text-amber-800",
    danger: "bg-red-100 text-red-800"
  };
  
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${variants[variant]}`}>
      {children}
    </span>
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

  // State management for backend compatibility
  const [searchParams, setSearchParams] = useState({
    bloodGroup: "",
    component: "",
    radius: "",
    location: ""
  });

  const [searchResults, setSearchResults] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  // Mock data for demonstration
  const mockResults = [
    {
      id: 1,
      name: "City General Hospital Blood Bank",
      address: "123 Medical Avenue, Wardha",
      distance: 2.3,
      available: 12,
      lastUpdated: "2 hours ago"
    },
    {
      id: 2,
      name: "Red Cross Blood Centre",
      address: "456 Healthcare Road, Wardha",
      distance: 4.7,
      available: 8,
      lastUpdated: "30 mins ago"
    },
    {
      id: 3,
      name: "Community Blood Bank",
      address: "789 Wellness Street, Wardha",
      distance: 6.1,
      available: 0,
      lastUpdated: "1 hour ago"
    }
  ];

  // Handle search - Ready for backend integration
  const handleSearch = async () => {
    setIsLoading(true);
    
    try {
      // Backend API call structure
      const response = await fetch('/api/blood-banks/search', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          bloodGroup: searchParams.bloodGroup,
          component: searchParams.component,
          radius: parseFloat(searchParams.radius),
          location: searchParams.location || 'current' // Use geolocation or input
        })
      });
      
      const data = await response.json();
      setSearchResults(data.results);
    } catch (error) {
      console.error('Search error:', error);
      // For demo, use mock data
      setSearchResults(mockResults);
    } finally {
      setIsLoading(false);
    }
  };

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
            {/* Blood Group Selection */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Blood Group *
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

            {/* Component Selection */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Component *
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

            {/* Radius Input */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Search Radius (km) *
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

            {/* Search Button */}
            <div className="flex items-end">
              <Button
                onClick={handleSearch}
                disabled={!searchParams.bloodGroup || !searchParams.component || !searchParams.radius || isLoading}
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

          {/* Location Input (Optional)
          <div className="mt-4">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Location (Optional)
            </label>
            <Input
              type="text"
              placeholder="Enter location or use current location"
              value={searchParams.location}
              onChange={(e) => setSearchParams({...searchParams, location: e.target.value})}
            />
          </div> */}
        </Card>

        {/* Results Section */}
        {searchResults.length > 0 && (
          <div>
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold text-gray-900">
                Found {searchResults.length} blood bank(s)
              </h2>
              <Badge variant="default">
                {searchParams.bloodGroup} • {searchParams.component}
              </Badge>
            </div>

            <div className="space-y-4">
              {searchResults.map((bloodBank) => (
                <BloodBankBriefInfoCard key={bloodBank.id} bloodBank={bloodBank} />
              ))}
            </div>
          </div>
        )}

        {/* Empty State */}
        {!isLoading && searchResults.length === 0 && searchParams.bloodGroup && (
          <Card className="p-12 text-center">
            <Droplet className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">No results found</h3>
            <p className="text-gray-600">Try adjusting your search criteria or increasing the radius</p>
          </Card>
        )}
      </div>
    </div>
  );
};

export default SearchForBlood;