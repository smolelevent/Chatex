import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatex/core/constants/api_constants.dart';

class SettingsService {
  // --- NYELV FRISSÍTÉSE ---
  Future<void> updateLanguage(int userId, String language) async {
    await supabase.from('users').update({'preferred_lang': language}).eq('id', userId);
  }

  Future<void> updateUsername(int userId, String newUsername) async {
    final existingUser = await supabase.from('users').select('id').eq('username', newUsername).maybeSingle();
    if (existingUser != null) throw Exception('username_taken');

    await supabase.from('users').update({'username': newUsername}).eq('id', userId);
  }

  Future<void> updateEmail(int userId, String newEmail) async {
    final existingEmail = await supabase.from('users').select('id').eq('email', newEmail).maybeSingle();
    if (existingEmail != null) throw Exception('email_taken');

    await supabase.auth.updateUser(UserAttributes(email: newEmail));

    await supabase.from('users').update({'email': newEmail}).eq('id', userId);
  }

  Future<void> updatePassword(String newPassword) async {
    // Ezt a Supabase Auth teljesen a háttérben intézi, titkosítva!
    await supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<String> uploadProfilePicture(int userId, File imageFile) async {
    final String path = '$userId/profile.jpg';

    //upsert: true = felülírja a régit
    await supabase.storage.from('avatars').upload(
          path,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String imageUrl = '${supabase.storage.from('avatars').getPublicUrl(path)}?t=$timestamp';

    await supabase.from('users').update({'profile_picture': imageUrl}).eq('id', userId);

    return imageUrl;
  }

  // --- FIÓK TÖRLÉSE ---
  Future<void> deleteAccount(int userId) async {
    // Biztonsági okokból kliensről Auth usert nem lehet csak úgy törölni.
    // TODO: Létre kell majd hoznod egy RPC (Stored Procedure) függvényt a Supabase-ben "delete_user_account" néven!
    //[log] Hiba a fiók törlése közben! PostgrestException(message: Could not find the function public.delete_user_account without parameters in the schema cache, code: PGRST202, details: Searched for the function public.delete_user_account without parameters or with a single unnamed json/jsonb parameter, but no matches were found in the schema cache., hint: null)
    await supabase.rpc('delete_user_account');
  }
}
