import 'package:flutter/material.dart';
import 'CustomCard.dart';
import 'DeatiledBloodBankInfo.dart';

class CustomCardExamples extends StatelessWidget {
  const CustomCardExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBloodBankCard(context, size),
            const SizedBox(height: 24),
            _buildAppointmentsCard(size),
            const SizedBox(height: 24),
            _buildStaffCard(size),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodBankCard(BuildContext context, Size size) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.pink.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade200.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GlassCard(
          width: double.infinity,
          height: size.height * 0.75,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DeatiledBloodBankInfo()),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Blood Bank",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DeatiledBloodBankInfo()),
                    ),
                    icon: Icon(Icons.navigate_next, size: 32, color: Colors.red.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Current blood stock overview",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Expanded(child: _buildBloodStockSection()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBloodStockSection() {
    final bloodData = [
      {"type": "O+", "progress": 0.85, "units": 42, "color": Colors.red},
      {"type": "O-", "progress": 0.55, "units": 22, "color": Colors.red.shade700},
      {"type": "A+", "progress": 0.65, "units": 28, "color": Colors.orange},
      {"type": "A-", "progress": 0.35, "units": 14, "color": Colors.orange.shade700},
      {"type": "B+", "progress": 0.45, "units": 18, "color": Colors.amber},
      {"type": "B-", "progress": 0.25, "units": 10, "color": Colors.amber.shade700},
      {"type": "AB+", "progress": 0.20, "units": 8, "color": Colors.deepOrange},
      {"type": "AB-", "progress": 0.15, "units": 6, "color": Colors.deepOrange.shade700},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left 70%: Blood stock rows (NOW SCROLLABLE)
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            child: Column(
              children: bloodData.map((data) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildBloodStockRow(
                    data["type"] as String,
                    data["progress"] as double,
                    data["units"] as int,
                    data["color"] as Color,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Right 30% stays the same...
        // Right 30%: Stats panel
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade50, Colors.pink.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.shade200, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(Icons.water_drop, "Total", "148 units"),
                Divider(color: Colors.red.shade200, thickness: 1, indent: 16, endIndent: 16),
                _buildStatItem(Icons.trending_up, "High", "O+, A+"),
                Divider(color: Colors.red.shade200, thickness: 1, indent: 16, endIndent: 16),
                _buildStatItem(Icons.warning_amber_rounded, "Low", "AB-"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.red.shade700, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBloodStockRow(String type, double progress, int units, Color color) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Blood type badge
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Progress and units
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 18,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "$units units",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsCard(Size size) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.cyan.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GlassCard(
          width: double.infinity,
          height: size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Appointments",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "View today's appointments and manage schedules.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffCard(Size size) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.teal.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2.5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GlassCard(
          width: double.infinity,
          height: size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Staff",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Manage doctors, nurses, and hospital staff records.",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}