import React, { useState } from 'react';
import { Droplet, TrendingUp, Shield, Zap, Database, Bell, BarChart3, CheckCircle, ArrowRight, Phone, Mail, Facebook, Twitter, Instagram, Linkedin, Building2, Activity } from 'lucide-react';

// Button Component
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
// const Navbar = () => {
//   const [isMenuOpen, setIsMenuOpen] = useState(false);

//   return (
//     <nav className="bg-white border-b border-gray-200 sticky top-0 z-50 shadow-sm">
//       <div className="max-w-7xl mx-auto px-6">
//         <div className="flex items-center justify-between h-16">
//           {/* Logo */}
//           <a href="/" className="flex items-center gap-2 hover:opacity-80 transition-opacity">
//             <div className="bg-red-600 rounded-lg p-2">
//               <Droplet className="w-5 h-5 text-white fill-white" />
//             </div>
//             <span className="text-xl font-bold text-gray-900">BloodConnect</span>
//             <span className="text-xs bg-red-100 text-red-700 px-2 py-0.5 rounded-full font-semibold">SaaS</span>
//           </a>

//           {/* Desktop Navigation */}
//           <div className="hidden md:flex items-center gap-8">
//             <a  className="text-gray-700 hover:text-red-600 font-medium transition-colors">
//               Home
//             </a>
//             <a  className="text-gray-700 hover:text-red-600 font-medium transition-colors">
//               Features
//             </a>
//             <a className="text-gray-700 hover:text-red-600 font-medium transition-colors">
//               Pricing
//             </a>
//             <a  className="text-gray-700 hover:text-red-600 font-medium transition-colors">
//               About Us
//             </a>
//           </div>

//           {/* Login Button */}
//           <div className="hidden md:flex items-center gap-3">
//             <Button variant="ghost">Contact Sales</Button>
//             <Button>Login</Button>
//           </div>

//           {/* Mobile Menu Button */}
//           <button
//             className="md:hidden p-2 hover:bg-gray-100 rounded-md"
//             onClick={() => setIsMenuOpen(!isMenuOpen)}
//           >
//             <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
//               {isMenuOpen ? (
//                 <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
//               ) : (
//                 <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
//               )}
//             </svg>
//           </button>
//         </div>

//         {/* Mobile Menu */}
//         {isMenuOpen && (
//           <div className="md:hidden py-4 border-t">
//             <div className="flex flex-col gap-4">
//               <a href="/" className="text-gray-700 hover:text-red-600 font-medium">Home</a>
//               <a href="/features" className="text-gray-700 hover:text-red-600 font-medium">Features</a>
//               <a href="/pricing" className="text-gray-700 hover:text-red-600 font-medium">Pricing</a>
//               <a href="/about" className="text-gray-700 hover:text-red-600 font-medium">About Us</a>
//               <Button variant="ghost" className="w-full">Contact Sales</Button>
//               <Button className="w-full">Login</Button>
//             </div>
//           </div>
//         )}
//       </div>
//     </nav>
//   );
// };

// Hero Section
const HeroSection = () => {
  return (
    <section className="bg-gradient-to-br from-gray-50 via-white to-red-50 py-20">
      <div className="max-w-7xl mx-auto px-6">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          {/* Left Content */}
          <div>
            <div className="inline-flex items-center gap-2 bg-red-100 text-red-700 px-4 py-2 rounded-full text-sm font-medium mb-6">
              <TrendingUp className="w-4 h-4" />
              Smart Blood Management Platform
            </div>
            <h1 className="text-5xl font-bold text-gray-900 leading-tight mb-6">
              Transform Your<br />
              <span className="text-red-600">Blood Inventory</span><br />
              Management
            </h1>
            <p className="text-lg text-gray-600 mb-8 leading-relaxed">
              The complete SaaS solution for hospitals and blood banks. Real-time inventory tracking, 
              automated donor coordination, and emergency response—all in one platform.
            </p>
            <div className="flex flex-wrap gap-4">
              <Button size="lg">
                Request Demo
                <ArrowRight className="w-5 h-5 ml-2" />
              </Button>
              <Button variant="outline" size="lg">
                View Pricing
              </Button>
            </div>

            {/* Trust Indicators */}
            <div className="grid grid-cols-3 gap-6 mt-12 pt-12 border-t border-gray-200">
              <div>
                <div className="text-3xl font-bold text-red-600">200+</div>
                <div className="text-sm text-gray-600 mt-1">Hospitals</div>
              </div>
              <div>
                <div className="text-3xl font-bold text-red-600">99.9%</div>
                <div className="text-sm text-gray-600 mt-1">Uptime</div>
              </div>
              <div>
                <div className="text-3xl font-bold text-red-600">24/7</div>
                <div className="text-sm text-gray-600 mt-1">Support</div>
              </div>
            </div>
          </div>

          {/* Right Content - Dashboard Preview */}
          <div className="relative">
            <div className="bg-white rounded-2xl shadow-2xl p-6 border border-gray-200">
              <div className="flex items-center gap-2 mb-4 pb-4 border-b">
                <div className="flex gap-1">
                  <div className="w-3 h-3 rounded-full bg-red-500"></div>
                  <div className="w-3 h-3 rounded-full bg-yellow-500"></div>
                  <div className="w-3 h-3 rounded-full bg-green-500"></div>
                </div>
                <span className="text-xs text-gray-500 ml-auto">Dashboard</span>
              </div>
              <div className="space-y-4">
                <div className="bg-gradient-to-r from-red-50 to-red-100 rounded-lg p-4">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm text-gray-700 font-medium">Blood Inventory</span>
                    <Activity className="w-4 h-4 text-red-600" />
                  </div>
                  <div className="text-2xl font-bold text-gray-900">847 Units</div>
                  <div className="text-xs text-green-600 mt-1">↑ 12% from last week</div>
                </div>
                <div className="grid grid-cols-2 gap-3">
                  <div className="bg-gray-50 rounded-lg p-3">
                    <div className="text-xs text-gray-600 mb-1">Active Donors</div>
                    <div className="text-xl font-bold text-gray-900">1,245</div>
                  </div>
                  <div className="bg-gray-50 rounded-lg p-3">
                    <div className="text-xs text-gray-600 mb-1">Pending Requests</div>
                    <div className="text-xl font-bold text-gray-900">23</div>
                  </div>
                </div>
                <div className="bg-gray-50 rounded-lg p-3">
                  <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                    <div className="h-full bg-red-600 rounded-full" style={{width: '68%'}}></div>
                  </div>
                  <div className="text-xs text-gray-600 mt-2">Storage Capacity: 68%</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

// Features Section
const FeaturesSection = () => {
  const features = [
    {
      icon: <Database className="w-8 h-8" />,
      title: "Real-Time Inventory Management",
      description: "Track blood units across all locations with live updates. Never run out of critical blood types again."
    },
    {
      icon: <Bell className="w-8 h-8" />,
      title: "Automated Emergency Alerts",
      description: "Instantly notify nearby hospitals and blood banks during critical shortages with smart routing."
    },
    {
      icon: <Shield className="w-8 h-8" />,
      title: "Compliance & Security",
      description: "HIPAA compliant platform with end-to-end encryption and secure donor data management."
    },
    {
      icon: <BarChart3 className="w-8 h-8" />,
      title: "Advanced Analytics",
      description: "Get insights into donation patterns, inventory forecasting, and operational efficiency metrics."
    },
    {
      icon: <Zap className="w-8 h-8" />,
      title: "Lightning-Fast Search",
      description: "Find matching blood types across your network in milliseconds with AI-powered search."
    },
    {
      icon: <Building2 className="w-8 h-8" />,
      title: "Multi-Location Support",
      description: "Manage multiple blood banks and hospital branches from a single unified dashboard."
    }
  ];

  return (
    <section className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-6">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">
            Everything You Need to <span className="text-red-600">Manage Blood Operations</span>
          </h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto">
            Built specifically for healthcare professionals. Our platform reduces wastage by 40% 
            and improves response times by 3x.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <div
              key={index}
              className="bg-white border border-gray-200 rounded-xl p-6 hover:shadow-lg hover:border-red-200 transition-all duration-300"
            >
              <div className="bg-red-100 text-red-600 w-16 h-16 rounded-lg flex items-center justify-center mb-4">
                {feature.icon}
              </div>
              <h3 className="text-xl font-semibold text-gray-900 mb-2">
                {feature.title}
              </h3>
              <p className="text-gray-600">
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};

// Benefits Section
const BenefitsSection = () => {
  const benefits = [
    "Reduce blood wastage by up to 40%",
    "Cut operational costs by 30%",
    "Improve emergency response time by 3x",
    "Automate donor management workflows",
    "Ensure regulatory compliance automatically",
    "24/7 technical support and monitoring"
  ];

  return (
    <section className="py-20 bg-gray-50">
      <div className="max-w-7xl mx-auto px-6">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div>
            <h2 className="text-4xl font-bold text-gray-900 mb-6">
              Why Leading Hospitals Choose <span className="text-red-600">BloodConnect</span>
            </h2>
            <p className="text-lg text-gray-600 mb-8">
              Join 200+ hospitals and blood banks that have transformed their blood management 
              operations with our enterprise-grade platform.
            </p>
            <ul className="space-y-4">
              {benefits.map((benefit, index) => (
                <li key={index} className="flex items-start gap-3">
                  <CheckCircle className="w-6 h-6 text-red-600 flex-shrink-0 mt-0.5" />
                  <span className="text-gray-700">{benefit}</span>
                </li>
              ))}
            </ul>
          </div>

          <div className="bg-white rounded-2xl shadow-xl p-8 border border-gray-200">
            <div className="text-center mb-6">
              <div className="text-5xl font-bold text-red-600 mb-2">40%</div>
              <div className="text-gray-600">Reduction in Blood Wastage</div>
            </div>
            <div className="grid grid-cols-2 gap-4 mb-6">
              <div className="text-center p-4 bg-gray-50 rounded-lg">
                <div className="text-2xl font-bold text-gray-900">3x</div>
                <div className="text-sm text-gray-600">Faster Response</div>
              </div>
              <div className="text-center p-4 bg-gray-50 rounded-lg">
                <div className="text-2xl font-bold text-gray-900">99.9%</div>
                <div className="text-sm text-gray-600">Uptime SLA</div>
              </div>
            </div>
            <div className="text-center text-sm text-gray-500 italic">
              "BloodConnect has revolutionized how we manage our blood bank. 
              The ROI was visible within the first month."
            </div>
            <div className="text-center mt-3">
              <div className="font-semibold text-gray-900">Dr. Sarah Johnson</div>
              <div className="text-sm text-gray-600">Chief Medical Officer, City Hospital</div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

// CTA Section
const CTASection = () => {
  return (
    <section className="py-20 bg-gradient-to-r from-red-600 to-red-700">
      <div className="max-w-4xl mx-auto px-6 text-center">
        <h2 className="text-4xl font-bold text-white mb-6">
          Ready to Transform Your Blood Management?
        </h2>
        <p className="text-xl text-red-100 mb-8">
          Join leading hospitals and blood banks. Get started with a free 30-day trial.
          No credit card required.
        </p>
        <div className="flex flex-wrap gap-4 justify-center ">
          <Button size="lg" className=" text-red-900 ">
            Schedule a Demo
          </Button>
          <Button size="lg" variant="outline" className=" text-red-600 border-white bg-white">
            Contact Sales
          </Button>
        </div>
      </div>
    </section>
  );
};

// // Footer Component
// const Footer = () => {
//   return (
//     <footer className="bg-gray-900 text-gray-300">
//       <div className="max-w-7xl mx-auto px-6 py-10">
//         <div className="grid md:grid-cols-4 gap-8 mb-8">
//           {/* Company Info */}
//           <div>
//             <div className="flex items-center gap-2 mb-4">
//               <div className="bg-red-600 rounded-lg p-2">
//                 <Droplet className="w-5 h-5 text-white fill-white" />
//               </div>
//               <span className="text-xl font-bold text-white">BloodConnect</span>
//             </div>
//             <p className="text-sm text-gray-400">
//               Enterprise blood management platform for hospitals and blood banks. 
//               Trusted by healthcare institutions worldwide.
//             </p>
//           </div>

//           {/* Product */}
//           <div>
//             <h3 className="text-white font-semibold mb-4">Product</h3>
//             <ul className="space-y-2 text-sm">
//               <li><a href="/features" className="hover:text-red-400 transition-colors">Features</a></li>
//               <li><a href="/pricing" className="hover:text-red-400 transition-colors">Pricing</a></li>
//               <li><a href="/integrations" className="hover:text-red-400 transition-colors">Integrations</a></li>
//               <li><a href="/security" className="hover:text-red-400 transition-colors">Security</a></li>
//             </ul>
//           </div>

//           {/* Company */}
//           <div>
//             <h3 className="text-white font-semibold mb-4">Company</h3>
//             <ul className="space-y-2 text-sm">
//               <li><a href="/about" className="hover:text-red-400 transition-colors">About Us</a></li>
//               <li><a href="/careers" className="hover:text-red-400 transition-colors">Careers</a></li>
//               <li><a href="/blog" className="hover:text-red-400 transition-colors">Blog</a></li>
//               <li><a href="/contact" className="hover:text-red-400 transition-colors">Contact</a></li>
//             </ul>
//           </div>

//           {/* Legal & Support */}
//           <div>
//             <h3 className="text-white font-semibold mb-4">Support</h3>
//             <ul className="space-y-3 text-sm">
//               <li className="flex items-center gap-2">
//                 <Phone className="w-4 h-4 text-red-400" />
//                 <span>+91 1800-BLOOD-11</span>
//               </li>
//               <li className="flex items-center gap-2">
//                 <Mail className="w-4 h-4 text-red-400" />
//                 <span>enterprise@bloodconnect.com</span>
//               </li>
//             </ul>
//             <div className="mt-4">
//               <ul className="space-y-2 text-sm">
//                 <li><a href="/help" className="hover:text-red-400 transition-colors">Help Center</a></li>
//                 <li><a href="/privacy" className="hover:text-red-400 transition-colors">Privacy Policy</a></li>
//                 <li><a href="/terms" className="hover:text-red-400 transition-colors">Terms of Service</a></li>
//               </ul>
//             </div>
//           </div>
//         </div>

//         {/* Bottom Bar */}
//         <div className="pt-8 border-t border-gray-800">
//           <div className="flex flex-col md:flex-row justify-between items-center gap-4">
//             <p className="text-sm text-gray-400">
//               &copy; 2025 BloodConnect SaaS. All rights reserved.
//             </p>
//             <div className="flex gap-4">
//               <a href="#" className="bg-gray-800 p-2 rounded-full hover:bg-red-600 transition-colors">
//                 <Facebook className="w-4 h-4" />
//               </a>
//               <a href="#" className="bg-gray-800 p-2 rounded-full hover:bg-red-600 transition-colors">
//                 <Twitter className="w-4 h-4" />
//               </a>
//               <a href="#" className="bg-gray-800 p-2 rounded-full hover:bg-red-600 transition-colors">
//                 <Instagram className="w-4 h-4" />
//               </a>
//               <a href="#" className="bg-gray-800 p-2 rounded-full hover:bg-red-600 transition-colors">
//                 <Linkedin className="w-4 h-4" />
//               </a>
//             </div>
//           </div>
//         </div>
//       </div>
//     </footer>
//   );
// };

// Main Home Page Component
const HomePage = () => {
  return (
    <div className=" bg-white">
      {/* <Navbar /> */}
      <HeroSection />
      <FeaturesSection />
      <BenefitsSection />
      <CTASection />
      {/* <Footer /> */}
    </div>
  );
};

export default HomePage;