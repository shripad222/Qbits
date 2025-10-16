import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'supabase_service.g.dart';

class SupabaseService {
  final SupabaseClient client;

  SupabaseService(this.client);

  /// Initializes the Supabase client connection (to be called in main.dart)
  static Future<void> initialize() async {
    await Supabase.initialize(
      url:
          'https://gszkxmxrhfmhujujtwho.supabase.co', // Replace with your actual URL
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdzemt4bXhyaGZtaHVqdWp0d2hvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDQ2NjQzMSwiZXhwIjoyMDc2MDQyNDMxfQ.SHfGaVoRJ8aiqz3-92vw-4lqUst0QCmDA8POdR0VUBk', // Replace with your actual Anon Key
    );
  }

  /// Generic function to insert data into a specified table.
  /// Generic function to insert data into a specified table.
  /// Returns the inserted row(s) as returned by Supabase (often a List or Map).
  Future<dynamic> insertData(String table, Map<String, dynamic> data) async {
    try {
      final res = await client.from(table).insert(data).select();
      return res;
    } on PostgrestException catch (e) {
      // Re-throw the exception to be handled by the ViewModel
      throw Exception('Supabase Insert Error in $table: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred during insertion: $e');
    }
  }

  /// Generic helper to update rows in a table by matching a column=value.
  /// Returns the updated row(s).
  Future<dynamic> updateData(
    String table,
    Map<String, dynamic> updates,
    String matchColumn,
    dynamic matchValue,
  ) async {
    try {
      final res = await client
          .from(table)
          .update(updates)
          .eq(matchColumn, matchValue)
          .select();
      return res;
    } on PostgrestException catch (e) {
      throw Exception('Supabase Update Error in $table: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred during update: $e');
    }
  }
}

@Riverpod(keepAlive: true)
SupabaseService supabaseService(Ref ref) {
  // Access the singleton instance after Supabase.initialize()
  return SupabaseService(Supabase.instance.client);
}
