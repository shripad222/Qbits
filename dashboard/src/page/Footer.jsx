import React from 'react';
import { Droplet, Phone, Mail, Facebook, Twitter, Instagram, Linkedin } from 'lucide-react';

const Footer = () => {
  return (
    <footer className="bg-gray-900 text-gray-300 w-full">
      {/* Main Footer Content */}
      <div className="w-full px-8 lg:px-16 xl:px-24 py-12">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 mb-8">
          {/* Company Info */}
          <div>
            <div className="flex items-center gap-2 mb-4">
              <div className="bg-red-600 rounded-lg p-2">
                <Droplet className="w-5 h-5 text-white fill-white" />
              </div>
              <span className="text-xl font-bold text-white">BloodConnect</span>
            </div>
            <p className="text-sm text-gray-400 leading-relaxed">
              Enterprise blood management platform for hospitals and blood banks. 
              Trusted by healthcare institutions worldwide.
            </p>
          </div>

          {/* Product */}
          <div>
            <h3 className="text-white font-semibold mb-4">Product</h3>
            <ul className="space-y-2 text-sm">
              <li>
                <a href="/features" className="hover:text-red-400 transition-colors">
                  Features
                </a>
              </li>
              <li>
                <a href="/pricing" className="hover:text-red-400 transition-colors">
                  Pricing
                </a>
              </li>
              <li>
                <a href="/integrations" className="hover:text-red-400 transition-colors">
                  Integrations
                </a>
              </li>
              <li>
                <a href="/security" className="hover:text-red-400 transition-colors">
                  Security
                </a>
              </li>
            </ul>
          </div>

          {/* Company */}
          <div>
            <h3 className="text-white font-semibold mb-4">Company</h3>
            <ul className="space-y-2 text-sm">
              <li>
                <a href="/about" className="hover:text-red-400 transition-colors">
                  About Us
                </a>
              </li>
              <li>
                <a href="/careers" className="hover:text-red-400 transition-colors">
                  Careers
                </a>
              </li>
              <li>
                <a href="/blog" className="hover:text-red-400 transition-colors">
                  Blog
                </a>
              </li>
              <li>
                <a href="/contact" className="hover:text-red-400 transition-colors">
                  Contact
                </a>
              </li>
            </ul>
          </div>

          {/* Legal & Support */}
          <div>
            <h3 className="text-white font-semibold mb-4">Support</h3>
            <ul className="space-y-3 text-sm mb-4">
              <li className="flex items-center gap-2">
                <Phone className="w-4 h-4 text-red-400" />
                <span>+91 1800-BLOOD-11</span>
              </li>
              <li className="flex items-center gap-2">
                <Mail className="w-4 h-4 text-red-400" />
                <span className="break-all">enterprise@bloodconnect.com</span>
              </li>
            </ul>
            <ul className="space-y-2 text-sm">
              <li>
                <a href="/help" className="hover:text-red-400 transition-colors">
                  Help Center
                </a>
              </li>
              <li>
                <a href="/privacy" className="hover:text-red-400 transition-colors">
                  Privacy Policy
                </a>
              </li>
              <li>
                <a href="/terms" className="hover:text-red-400 transition-colors">
                  Terms of Service
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="pt-8 border-t border-gray-800">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <p className="text-sm text-gray-400">
              &copy; 2025 BloodConnect SaaS. All rights reserved.
            </p>
            <div className="flex gap-4">
              <a 
                href="#" 
                className="bg-gray-800 p-2 rounded-full hover:bg-red-600 transition-colors"
                aria-label="Facebook"
              >
                <Facebook className="w-4 h-4" />
              </a>
              <a 
                href="#" 
                className="bg-gray-800 p-2 rounded-full hover:bg-red-600 transition-colors"
                aria-label="Twitter"
              >
                <Twitter className="w-4 h-4" />
              </a>
              <a 
                href="#" 
                className="bg-gray-800 p-2 rounded-full hover:bg-red-600 transition-colors"
                aria-label="Instagram"
              >
                <Instagram className="w-4 h-4" />
              </a>
              <a 
                href="#" 
                className="bg-gray-800 p-2 rounded-full hover:bg-red-600 transition-colors"
                aria-label="LinkedIn"
              >
                <Linkedin className="w-4 h-4" />
              </a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;