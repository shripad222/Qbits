import React from 'react';

import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "../../../components/ui/card";
import { Button } from "../../../components/ui/button";
import { Badge } from "../../../components/ui/badge";

// --- Icon Component (Calendar & Drop - Lucide Style) ---
const CalendarIcon = (props) => (
  <svg {...props} xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-calendar">
    <path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/>
  </svg>
);

const ClockIcon = (props) => (
  <svg {...props} xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-clock">
    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
  </svg>
);



const scheduledSessions = [
  { id: 'S001', donorName: 'Alice Johnson', bloodGroup: 'O+', time: '10:00 AM', status: 'Scheduled', location: 'Room 1A' },
  { id: 'S002', donorName: 'Bob Smith', bloodGroup: 'A-', time: '10:30 AM', status: 'Confirmed', location: 'Room 2B' },
  { id: 'S003', donorName: 'Charlie Brown', bloodGroup: 'B+', time: '11:00 AM', status: 'Checked In', location: 'Room 1A' },
  { id: 'S004', donorName: 'Diana Prince', bloodGroup: 'AB+', time: '11:30 AM', status: 'Canceled', location: '' },
  { id: 'S005', donorName: 'Ethan Hunt', bloodGroup: 'O-', time: '12:00 PM', status: 'Completed', location: 'Room 3C' },
  { id: 'S006', donorName: 'Fiona Glenn', bloodGroup: 'A+', time: '12:30 PM', status: 'Scheduled', location: 'Room 2B' },
  { id: 'S007', donorName: 'Greg House', bloodGroup: 'O+', time: '01:00 PM', status: 'Confirmed', location: 'Room 1A' },
];

// Utility to map status to Badge variant
const getStatusVariant = (status) => {
    switch (status) {
        // Shadcn uses fixed variants (default, secondary, destructive, outline).
        // For a real app, you'd map custom statuses to Tailwind classes or extend Badge variants.
        // Here, we'll map them to the closest visual style using custom classes (which the real Badge component allows).
        case 'Scheduled': return 'bg-blue-100 text-blue-600 hover:bg-blue-200';
        case 'Confirmed': return 'bg-green-100 text-green-600 hover:bg-green-200';
        case 'Checked In': return 'bg-indigo-100 text-indigo-600 hover:bg-indigo-200';
        case 'Completed': return 'bg-gray-100 text-gray-600 hover:bg-gray-200';
        case 'Canceled': return 'bg-red-100 text-red-600 hover:bg-red-200';
        default: return 'bg-gray-100 text-gray-600 hover:bg-gray-200';
    }
};

// Mimics a shadcn Table Row
const SessionRow = ({ session }) => {
    const customBadgeClasses = getStatusVariant(session.status);
    
    return (
        <div className="flex items-center py-3 border-b border-gray-100 last:border-b-0 hover:bg-gray-50 transition-colors">
            {/* Time (Fixed Width) */}
            <div className="w-24 text-sm font-bold text-gray-700 flex items-center">
                <ClockIcon className="w-4 h-4 mr-2 text-blue-500" />
                {session.time}
            </div>
            
            {/* Donor Name & Group (Flexible) */}
            <div className="flex-1 min-w-0 pr-4">
                <p className="font-medium text-gray-900 truncate">{session.donorName}</p>
                <p className="text-xs text-muted-foreground">{session.bloodGroup} Group</p>
            </div>
            
            {/* Location (Medium Width) */}
            <div className="w-24 text-sm text-gray-500 hidden sm:block">
                {session.location || 'N/A'}
            </div>
            
            {/* Status Badge (Fixed Width) */}
            <div className="w-32 text-right">
                {/* We use the default Badge variant and apply custom classes for color */}
                <Badge variant="default" className={`border-transparent ${customBadgeClasses}`}>
                    {session.status}
                </Badge>
            </div>
            
            {/* Action Button (Fixed Width) */}
            <div className="w-24 text-right">
                <Button variant="outline" className="h-7 px-2 text-xs">
                    {session.status === 'Scheduled' ? 'Confirm' : 'Details'}
                </Button>
            </div>
        </div>
    );
};



export default function AppointmentsCard() {

    const handleNewSession = () => {
        console.log("Opening modal to schedule new session...");
    };

    return (
        <div>
            <Card className="min-h-[600px] w-full bg-gray-50">
                
                <CardHeader className="flex flex-row items-center justify-between">
                    <div className="flex items-center space-x-3">
                        <div className="p-2 rounded-full bg-blue-50 border-2 border-blue-200 text-blue-600">
                            <CalendarIcon className="w-6 h-6" />
                        </div>
                        <div >
                            <CardTitle className="text-3xl font-extrabold text-gray-800">
                                Donation Session Management
                            </CardTitle>
                            <CardDescription className="text-base text-gray-500">
                                Overview of all scheduled, confirmed, and checked-in donor appointments for today.
                            </CardDescription>
                        </div>
                    </div>
                    
                    {/* Using the standard shadcn Button */}
                    <Button 
                        className="h-10 px-6 text-sm bg-blue-700 hover:bg-blue-800"
                        onClick={handleNewSession}
                    >
                        + Schedule New
                    </Button>
                </CardHeader>

                <CardContent className="p-6">
                    {/* Table Header (Mimicking shadcn table-header) */}
                    <div className="flex py-3 border-b border-gray-200 text-xs font-semibold uppercase text-gray-500">
                        <div className="w-24">Time</div>
                        <div className="flex-1">Donor Name</div>
                        <div className="w-24 hidden sm:block">Location</div>
                        <div className="w-32 text-right">Status</div>
                        <div className="w-24 text-right">Actions</div>
                    </div>

                    {/* Table Body */}
                    <div className="divide-y divide-gray-100">
                        {scheduledSessions.map((session) => (
                            <SessionRow key={session.id} session={session} />
                        ))}
                    </div>

                    <CardDescription className="text-xs text-center mt-6">
                         Showing {scheduledSessions.length} appointments scheduled for today.
                    </CardDescription>
                </CardContent>
            </Card>
        </div>
    );
};