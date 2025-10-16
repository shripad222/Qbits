import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_blood_availability/core/services/supabase_service.dart';
import 'package:smart_blood_availability/pages/Donor.dart';

void main() async {
  // 1. Ensure Flutter bindings are initialized before calling native methods
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Supabase Client
  // NOTE: Ensure your actual URL and Anon Key are set in supabase_service.dart
  await SupabaseService.initialize();

  // 3. Start the application wrapped in ProviderScope for Riverpod
  runApp(
    const ProviderScope(
      child: BloodBankApp(),
    ),
  );
}

class BloodBankApp extends StatelessWidget {
  const BloodBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Blood Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        // Define a clean, modern input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
      // Set the unified registration page as the home screen
      // home: const RegistrationView(),
      home: Donor(),
    );
  }
}