import 'package:flutter/material.dart';

import '../components/DashBoard.dart';

class Hospital extends StatelessWidget {
  const Hospital({super.key});

  @override
  Widget build(BuildContext context) {
    return const HospitalMainPage();
  }
}

class HospitalMainPage extends StatefulWidget {
  const HospitalMainPage({super.key});

  @override
  State<HospitalMainPage> createState() => _HospitalMainPageState();
}

class _HospitalMainPageState extends State<HospitalMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Dashboard'),
        backgroundColor: Colors.red.shade700,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:CustomCardExamples()
    )
    );
  }
}

