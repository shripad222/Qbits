import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_service.g.dart';

class SupabaseService {
  final SupabaseClient client;

  SupabaseService(this.client);

  /// Initializes the Supabase client connection (to be called in main.dart)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL', // Replace with your actual URL
      anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your actual Anon Key
    );
  }

  /// Generic function to insert data into a specified table.
  Future<void> insertData(String table, Map<String, dynamic> data) async {
    try {
      await client.from(table).insert(data);
    } on PostgrestException catch (e) {
      // Re-throw the exception to be handled by the ViewModel
      throw Exception('Supabase Insert Error in $table: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred during insertion: $e');
    }
  }
}

@Riverpod(keepAlive: true)
SupabaseService supabaseService(SupabaseServiceRef ref) {
  // Access the singleton instance after Supabase.initialize()
  return SupabaseService(Supabase.instance.client);
}