import React, { useState } from 'react';
import { Droplet, TrendingUp, Shield, Zap, Database, Bell, BarChart3, CheckCircle, ArrowRight, Phone, Mail, Facebook, Twitter, Instagram, Linkedin, Building2, Activity } from 'lucide-react';
import { useLocation } from 'react-router-dom';



const Button = ({ children, variant = "default", size = "default", className = "", ...props }) => {
  const baseStyles = "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50";
  const variants = {
    default: "bg-red-600 text-white hover:bg-red-700",
    outline: "border-2 border-red-600 text-red-600 hover:bg-red-50",
    ghost: "hover:bg-gray-100 text-gray-900",
    link: "text-red-600 underline-offset-4 hover:underline"
  };
  const sizes = {
    default: "h-10 px-6 py-2",
    sm: "h-9 px-4 text-sm",
    lg: "h-12 px-8 text-lg"
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

// Navbar Component
export default function Navbar() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const location = useLocation();
  const currentPath = location.pathname;

  return (
    <nav className="bg-white border-b border-gray-200 sticky top-0 z-50 shadow-sm">
      <div className="max-w-7xl mx-auto px-6">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <a href="/" className="flex items-center gap-2 hover:opacity-80 transition-opacity">
            <div className="bg-red-600 rounded-lg p-2">
              <Droplet className="w-5 h-5 text-white fill-white" />
            </div>
            <span className="text-xl font-bold text-gray-900">BloodConnect</span>
            <span className="text-xs bg-red-100 text-red-700 px-2 py-0.5 rounded-full font-semibold">SaaS</span>
          </a>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center gap-8">
            <a  className="text-gray-700 hover:text-red-600 font-medium transition-colors">
              Home
            </a>
            <a  className="text-gray-700 hover:text-red-600 font-medium transition-colors">
              Features
            </a>
            <a className="text-gray-700 hover:text-red-600 font-medium transition-colors">
              Pricing
            </a>
              {currentPath.includes('hospital')||currentPath.includes('bloodbank') ? (
     <a  href="/bloodbank/camps"  className="text-gray-700 hover:text-red-600 font-medium transition-colors">
              Organize A Camp
            </a>
  ) : (
     <a  className="text-gray-700 hover:text-red-600 font-medium transition-colors">
              About Us
      </a>
  )}
          </div>

          {/* Login Button */}
<div className="hidden md:flex items-center gap-3">
  <Button variant="ghost">Contact Sales</Button>
  {currentPath.includes('hospital')||currentPath.includes('bloodbank') ? (
    <Button>Logout</Button>
  ) : (
    <Button>Login</Button>
  )}
</div>
          {/* Mobile Menu Button */}
          <button
            className="md:hidden p-2 hover:bg-gray-100 rounded-md"
            onClick={() => setIsMenuOpen(!isMenuOpen)}
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              {isMenuOpen ? (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              ) : (
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              )}
            </svg>
          </button>
        </div>

        {/* Mobile Menu */}
        {isMenuOpen && (
          <div className="md:hidden py-4 border-t">
            <div className="flex flex-col gap-4">
              <a href="/" className="text-gray-700 hover:text-red-600 font-medium">Home</a>
              <a href="/features" className="text-gray-700 hover:text-red-600 font-medium">Features</a>
              <a href="/pricing" className="text-gray-700 hover:text-red-600 font-medium">Pricing</a>
              <a href="/about" className="text-gray-700 hover:text-red-600 font-medium">About Us</a>
              <Button variant="ghost" className="w-full">Contact Sales</Button>
              <Button className="w-full">Login</Button>
            </div>
          </div>
        )}
      </div>
    </nav>
  );
};