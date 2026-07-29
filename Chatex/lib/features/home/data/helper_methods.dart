import 'dart:developer';
import 'dart:io';
import 'package:chatex/core/constants/api_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> uploadProfilePicture(File imageFile, int userId) async {
  try {
    final String path = '$userId/profile_picture.jpg';

    // 2. Feltöltés a Storage-ba (az upsert: true felülírja a régit, ha már volt)
    await supabase.storage.from('avatars').upload(
          path,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    // 3. A publikus URL lekérése
    final String imageUrl = supabase.storage.from('avatars').getPublicUrl(path);

    // 4. Frissítjük a users táblát ezzel az URL-lel
    await supabase.from('users').update({'profile_picture': imageUrl}).eq('id', userId);

    return imageUrl;
  } catch (e) {
    log("Kép feltöltési hiba: $e");
    throw Exception('image_upload_failed');
  }
}
