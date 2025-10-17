import 'package:flutter/material.dart';
import 'package:smart_blood_availability/components/CustomCard.dart';
import 'package:smart_blood_availability/core/services/auth_service.dart';
import 'package:smart_blood_availability/pages/login_page.dart';
import '../components/notification_card.dart';
import '../components/notification_item.dart';
import 'blood_bank_map.dart';
import 'camp_map.dart';
import 'certificate_page.dart';

class Donor extends StatefulWidget {
  const Donor({super.key});

  @override
  State<Donor> createState() => _DonorState();
}

class _DonorState extends State<Donor> {
  @override
  Widget build(BuildContext context) {
    return const LandingPage();
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      type: NotificationType.request,
      title: "Urgent Blood Request",
      message: "City Hospital needs O+ blood urgently",
      time: "5 min ago",
      priority: Priority.high,
    ),
    NotificationItem(
      type: NotificationType.reminder,
      title: "Donation Reminder",
      message: "You're eligible to donate again",
      time: "2 hours ago",
      priority: Priority.medium,
    ),
    NotificationItem(
      type: NotificationType.alert,
      title: "Low Stock Alert",
      message: "Critical shortage of AB- blood",
      time: "1 day ago",
      priority: Priority.high,
    ),
    NotificationItem(
      type: NotificationType.info,
      title: "Thank You",
      message: "Your last donation helped save 3 lives",
      time: "3 days ago",
      priority: Priority.low,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Donor Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
              ),
              if (notifications.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${notifications.length}",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () async {
              final authService = AuthService();
              await authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDonorStatsCard(),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 20),
            NotificationList(
              notifications: notifications,
              onAction: _handleNotificationAction,
              onDismiss: _dismissNotification,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorStatsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.pink.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade200.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: GlassCard(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.water_drop, color: Colors.red.shade700, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Blood Type",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        Text(
                          "O+ Positive",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("12", "Donations", Icons.volunteer_activism),
                  _buildDivider(),
                  _buildStatItem("36", "Lives Saved", Icons.favorite),
                  _buildDivider(),
                  _buildStatItem("48", "Days Left", Icons.schedule),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.red.shade700, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                margin: EdgeInsets.zero,
                onTap: () {
                  // Navigate to Camps screen (if implemented)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CampMap(),
                    ),
                  );
                },
                child: _buildActionContent("Camps", Icons.campaign, Colors.blue),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassCard(
                margin: EdgeInsets.zero,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BloodBankMap(
                        area: "Goa",
                        amenityType: "blood_bank",
                      ),
                    ),
                  );
                },
                child: _buildActionContent("Find Blood Banks", Icons.location_on, Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                margin: EdgeInsets.zero,
                onTap: () {
                  // Navigate to History screen
                },
                child: _buildActionContent("History", Icons.history, Colors.orange),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassCard(
                margin: EdgeInsets.zero,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CertificatePage(donorName: "John Doe"),
                    ),
                  );
                },
                child: _buildActionContent("Certificates", Icons.card_giftcard, Colors.purple),
              ),
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildActionContent(String label, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _handleNotificationAction(NotificationItem n, bool accepted) {
    setState(() => notifications.remove(n));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(accepted ? "Request accepted" : "Request declined"),
        backgroundColor: accepted ? Colors.green : Colors.red,
      ),
    );
  }

  void _dismissNotification(NotificationItem n) {
    setState(() => notifications.remove(n));
  }
}
