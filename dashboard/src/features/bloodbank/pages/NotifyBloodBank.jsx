import React, { useState, useEffect } from 'react';
import { Bell, AlertCircle, Info, Calendar, MessageSquare, Send, Plus, X, Check } from 'lucide-react';

// UI Components
const Button = ({ children, variant = "default", size = "default", className = "", ...props }) => {
  const baseStyles = "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50";
  const variants = {
    default: "bg-red-600 text-white hover:bg-red-700",
    outline: "border-2 border-gray-300 text-gray-700 hover:bg-gray-50",
    ghost: "hover:bg-gray-100 text-gray-900"
  };
  const sizes = {
    default: "h-10 px-4 py-2",
    sm: "h-9 px-3 text-sm",
    lg: "h-11 px-8"
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

const Textarea = ({ className = "", ...props }) => (
  <textarea
    className={`flex min-h-[80px] w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm placeholder:text-gray-400 focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent disabled:cursor-not-allowed disabled:opacity-50 ${className}`}
    {...props}
  />
);

const Label = ({ children, className = "", htmlFor }) => (
  <label htmlFor={htmlFor} className={`text-sm font-medium text-gray-700 ${className}`}>
    {children}
  </label>
);

const Badge = ({ children, variant = "default", className = "" }) => {
  const variants = {
    default: "bg-gray-100 text-gray-800",
    high: "bg-red-100 text-red-800",
    medium: "bg-amber-100 text-amber-800",
    low: "bg-blue-100 text-blue-800",
    success: "bg-green-100 text-green-800"
  };
  
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${variants[variant]} ${className}`}>
      {children}
    </span>
  );
};

const Card = ({ children, className = "" }) => (
  <div className={`rounded-lg border border-gray-200 bg-white shadow-sm ${className}`}>
    {children}
  </div>
);

const Select = ({ children, value, onChange, className = "" }) => (
  <select
    value={value}
    onChange={onChange}
    className={`flex h-10 w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-red-500 focus:border-transparent ${className}`}
  >
    {children}
  </select>
);

// Modal Component
const Modal = ({ isOpen, onClose, children, title }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      <div 
        className="fixed inset-0 bg-black/50 backdrop-blur-sm"
        onClick={onClose}
      />
      <div className="relative z-50 w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
        <Card className="p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-2xl font-bold text-gray-900">{title}</h2>
            <button
              onClick={onClose}
              className="text-gray-400 hover:text-gray-600 transition-colors"
            >
              <X className="w-6 h-6" />
            </button>
          </div>
          {children}
        </Card>
      </div>
    </div>
  );
};

// Send Notification Modal
const SendNotificationModal = ({ isOpen, onClose, onSend, currentUserId }) => {
  const [formData, setFormData] = useState({
    type: 'info',
    priority: 'medium',
    title: '',
    message: '',
    receiver: ''
  });
  const [errors, setErrors] = useState({});
  const [sending, setSending] = useState(false);
  const [successMessage, setSuccessMessage] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: null }));
    }
  };

  const validateForm = () => {
    const newErrors = {};
    if (!formData.title.trim()) {
      newErrors.title = 'Title is required';
    }
    if (!formData.message.trim()) {
      newErrors.message = 'Message is required';
    }
    if (formData.message.length > 500) {
      newErrors.message = 'Message cannot exceed 500 characters';
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async () => {
    if (!validateForm()) return;

    setSending(true);
    setErrors({});
    setSuccessMessage('');

    try {
      const currentTime = new Date().toISOString();
      
      const payload = {
        type: formData.type,
        title: formData.title.trim(),
        message: formData.message.trim(),
        time: currentTime,
        priority: formData.priority,
        sender: currentUserId,
        receiver: formData.receiver ? parseInt(formData.receiver) : null
      };

      const response = await fetch('/notifications', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('token')}`
        },
        body: JSON.stringify(payload)
      });

      const result = await response.json();

      if (!response.ok || !result.success) {
        throw new Error(result.error || 'Failed to send notification');
      }

      setSuccessMessage('Notification sent successfully!');
      onSend(result.notification);
      
      setTimeout(() => {
        setFormData({
          type: 'info',
          priority: 'medium',
          title: '',
          message: '',
          receiver: ''
        });
        setErrors({});
        setSuccessMessage('');
        onClose();
      }, 1500);

    } catch (error) {
      console.error('Error sending notification:', error);
      setErrors({ submit: error.message || 'Failed to send notification. Please try again.' });
    } finally {
      setSending(false);
    }
  };

  const handleClose = () => {
    setFormData({
      type: 'info',
      priority: 'medium',
      title: '',
      message: '',
      receiver: ''
    });
    setErrors({});
    setSuccessMessage('');
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={handleClose} title="Send New Notification">
      <div className="space-y-4">
        {successMessage && (
          <div className="bg-green-50 border border-green-200 rounded-lg p-3 flex items-center gap-2 text-green-800">
            <Check className="w-5 h-5" />
            <span>{successMessage}</span>
          </div>
        )}

        <div>
          <Label htmlFor="receiver">
            Recipient ID <span className="text-gray-500">(Optional - leave empty for broadcast)</span>
          </Label>
          <Input
            id="receiver"
            name="receiver"
            type="number"
            value={formData.receiver}
            onChange={handleChange}
            placeholder="Enter recipient user ID or leave empty"
          />
          <p className="text-xs text-gray-500 mt-1">
            Leave empty to send to all users, or enter specific user ID
          </p>
        </div>

        <div>
          <Label htmlFor="type">
            Notification Type <span className="text-red-500">*</span>
          </Label>
          <Select
            id="type"
            name="type"
            value={formData.type}
            onChange={handleChange}
          >
            <option value="info">Info</option>
            <option value="alert">Alert</option>
            <option value="request">Request</option>
            <option value="reminder">Reminder</option>
          </Select>
        </div>

        <div>
          <Label htmlFor="priority">
            Priority <span className="text-red-500">*</span>
          </Label>
          <Select
            id="priority"
            name="priority"
            value={formData.priority}
            onChange={handleChange}
          >
            <option value="low">Low</option>
            <option value="medium">Medium</option>
            <option value="high">High</option>
          </Select>
        </div>

        <div>
          <Label htmlFor="title">
            Title <span className="text-red-500">*</span>
          </Label>
          <Input
            id="title"
            name="title"
            value={formData.title}
            onChange={handleChange}
            placeholder="Enter notification title"
            className={errors.title ? 'border-red-500' : ''}
            maxLength={100}
          />
          {errors.title && (
            <p className="text-xs text-red-500 mt-1">{errors.title}</p>
          )}
        </div>

        <div>
          <Label htmlFor="message">
            Message <span className="text-red-500">*</span>
          </Label>
          <Textarea
            id="message"
            name="message"
            value={formData.message}
            onChange={handleChange}
            placeholder="Enter notification message"
            rows={4}
            className={errors.message ? 'border-red-500' : ''}
            maxLength={500}
          />
          {errors.message && (
            <p className="text-xs text-red-500 mt-1">{errors.message}</p>
          )}
          <p className="text-xs text-gray-500 mt-1">
            {formData.message.length} / 500 characters
          </p>
        </div>

        <div className="bg-gray-50 rounded-lg p-4 border border-gray-200">
          <h4 className="text-sm font-semibold text-gray-900 mb-2">Preview</h4>
          <div className="bg-white rounded-lg border border-gray-200 p-3">
            <div className="flex items-start gap-3">
              <div className={`p-2 rounded-lg ${
                formData.type === 'alert' ? 'bg-red-100 text-red-700' :
                formData.type === 'request' ? 'bg-purple-100 text-purple-700' :
                formData.type === 'reminder' ? 'bg-blue-100 text-blue-700' :
                'bg-gray-100 text-gray-700'
              }`}>
                {formData.type === 'alert' && <AlertCircle className="w-4 h-4" />}
                {formData.type === 'request' && <MessageSquare className="w-4 h-4" />}
                {formData.type === 'reminder' && <Calendar className="w-4 h-4" />}
                {formData.type === 'info' && <Info className="w-4 h-4" />}
              </div>
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-1">
                  <p className="font-semibold text-gray-900">
                    {formData.title || 'Notification Title'}
                  </p>
                  <Badge variant={formData.priority}>
                    {formData.priority.toUpperCase()}
                  </Badge>
                </div>
                <p className="text-sm text-gray-600">
                  {formData.message || 'Notification message will appear here...'}
                </p>
              </div>
            </div>
          </div>
        </div>

        {errors.submit && (
          <div className="bg-red-50 border border-red-200 rounded-lg p-3 text-red-800 text-sm">
            {errors.submit}
          </div>
        )}

        <div className="flex gap-3 pt-4">
          <Button
            variant="outline"
            onClick={handleClose}
            className="flex-1"
            disabled={sending}
          >
            Cancel
          </Button>
          <Button
            onClick={handleSubmit}
            disabled={sending}
            className="flex-1"
          >
            <Send className="w-4 h-4 mr-2" />
            {sending ? 'Sending...' : 'Send Notification'}
          </Button>
        </div>
      </div>
    </Modal>
  );
};

// Sent Notification Card Component
const SentNotificationCard = ({ notification }) => {
  const getTypeColor = (type) => {
    switch (type) {
      case 'request':
        return 'bg-purple-100 text-purple-700';
      case 'reminder':
        return 'bg-blue-100 text-blue-700';
      case 'alert':
        return 'bg-red-100 text-red-700';
      case 'info':
        return 'bg-gray-100 text-gray-700';
      default:
        return 'bg-gray-100 text-gray-700';
    }
  };

  const getPriorityColor = (priority) => {
    switch (priority) {
      case 'high':
        return 'border-l-red-500 bg-red-50';
      case 'medium':
        return 'border-l-amber-500 bg-amber-50';
      case 'low':
        return 'border-l-blue-500 bg-blue-50';
      default:
        return 'border-l-gray-500 bg-white';
    }
  };

  const formatTime = (timestamp) => {
    const date = new Date(timestamp);
    const now = new Date();
    const diffMs = now - date;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins} minute${diffMins > 1 ? 's' : ''} ago`;
    if (diffHours < 24) return `${diffHours} hour${diffHours > 1 ? 's' : ''} ago`;
    if (diffDays < 7) return `${diffDays} day${diffDays > 1 ? 's' : ''} ago`;
    
    return date.toLocaleDateString();
  };

  const getIcon = () => {
    switch (notification.type) {
      case 'request':
        return <MessageSquare className="w-5 h-5" />;
      case 'reminder':
        return <Calendar className="w-5 h-5" />;
      case 'alert':
        return <AlertCircle className="w-5 h-5" />;
      case 'info':
        return <Info className="w-5 h-5" />;
      default:
        return <Bell className="w-5 h-5" />;
    }
  };

  return (
    <Card className={`p-4 border-l-4 ${getPriorityColor(notification.priority)} hover:shadow-md transition-all`}>
      <div className="flex items-start gap-4">
        <div className={`${getTypeColor(notification.type)} p-2 rounded-lg flex-shrink-0`}>
          {getIcon()}
        </div>

        <div className="flex-1 min-w-0">
          <div className="flex items-start justify-between gap-2 mb-1">
            <h3 className="font-semibold text-gray-900">
              {notification.title}
            </h3>
            <Badge variant={notification.priority}>
              {notification.priority.toUpperCase()}
            </Badge>
          </div>

          <p className="text-sm text-gray-600 mb-3">
            {notification.message}
          </p>

          <div className="flex items-center justify-between text-xs">
            <div className="flex items-center gap-4 text-gray-500">
              <span>Sent {formatTime(notification.time)}</span>
              {notification.receiver ? (
                <span className="bg-blue-100 text-blue-700 px-2 py-0.5 rounded-full">
                  To: User #{notification.receiver}
                </span>
              ) : (
                <span className="bg-purple-100 text-purple-700 px-2 py-0.5 rounded-full">
                  Broadcast to All
                </span>
              )}
            </div>
            <span className="text-gray-400">ID: {notification.id}</span>
          </div>
        </div>
      </div>
    </Card>
  );
};

// Main Notifications Page
const NotifyBloodBank = () => {
  const [sentNotifications, setSentNotifications] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showSendModal, setShowSendModal] = useState(false);
  
  // Get current user ID from your auth system
  const currentUserId = parseInt(localStorage.getItem('userId')) || 1;

  useEffect(() => {
    fetchSentNotifications();
  }, []);

  const fetchSentNotifications = async () => {
    setLoading(true);
    try {
      const response = await fetch(`/notifications`, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token')}`
        }
      });
      
      if (!response.ok) throw new Error('Failed to fetch notifications');
      
      const result = await response.json();
      setSentNotifications(result.notifications || []);
    } catch (error) {
      console.error('Error fetching notifications:', error);
      setSentNotifications([]);
    } finally {
      setLoading(false);
    }
  };

  const handleSendNotification = () => {
    fetchSentNotifications();
  };

  const stats = {
    total: sentNotifications.length,
    high: sentNotifications.filter(n => n.priority === 'high').length,
    alerts: sentNotifications.filter(n => n.type === 'alert').length,
    broadcasts: sentNotifications.filter(n => !n.receiver).length
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b border-gray-200 sticky top-0 z-40">
        <div className="max-w-7xl mx-auto px-6 py-6">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-gray-900 flex items-center gap-3">
                <Bell className="w-8 h-8 text-red-600" />
                Notifications
              </h1>
              <p className="text-gray-600 mt-1">
                Send notifications to other hospitals and blood banks
              </p>
            </div>
            <Button onClick={() => setShowSendModal(true)}>
              <Plus className="w-4 h-4 mr-2" />
              Send Notification
            </Button>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="max-w-7xl mx-auto px-6 py-8">
        {/* Stats */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
          <Card className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Total Sent</p>
                <p className="text-2xl font-bold text-gray-900">{stats.total}</p>
              </div>
              <Send className="w-8 h-8 text-gray-400" />
            </div>
          </Card>
          <Card className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">High Priority</p>
                <p className="text-2xl font-bold text-red-600">{stats.high}</p>
              </div>
              <AlertCircle className="w-8 h-8 text-red-400" />
            </div>
          </Card>
          <Card className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Alerts</p>
                <p className="text-2xl font-bold text-amber-600">{stats.alerts}</p>
              </div>
              <AlertCircle className="w-8 h-8 text-amber-400" />
            </div>
          </Card>
          <Card className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Broadcasts</p>
                <p className="text-2xl font-bold text-blue-600">{stats.broadcasts}</p>
              </div>
              <MessageSquare className="w-8 h-8 text-blue-400" />
            </div>
          </Card>
        </div>

        {/* Sent Notifications List */}
        <div className="mb-4">
          <h2 className="text-xl font-semibold text-gray-900">Sent Notifications</h2>
          <p className="text-sm text-gray-600">View all notifications you have sent</p>
        </div>

        {loading ? (
          <div className="text-center py-12">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-4 border-gray-200 border-t-red-600"></div>
            <p className="text-gray-600 mt-4">Loading notifications...</p>
          </div>
        ) : sentNotifications.length === 0 ? (
          <Card className="p-12 text-center">
            <Send className="w-16 h-16 text-gray-300 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">No notifications sent yet</h3>
            <p className="text-gray-600 mb-6">
              Start by sending your first notification to hospitals or blood banks
            </p>
            <Button onClick={() => setShowSendModal(true)}>
              <Plus className="w-4 h-4 mr-2" />
              Send Your First Notification
            </Button>
          </Card>
        ) : (
          <div className="space-y-4">
            {sentNotifications.map(notification => (
              <SentNotificationCard
                key={notification.id}
                notification={notification}
              />
            ))}
          </div>
        )}
      </div>

      {/* Send Modal */}
      <SendNotificationModal
        isOpen={showSendModal}
        onClose={() => setShowSendModal(false)}
        onSend={handleSendNotification}
        currentUserId={currentUserId}
      />
    </div>
  );
};

export default NotifyBloodBank;