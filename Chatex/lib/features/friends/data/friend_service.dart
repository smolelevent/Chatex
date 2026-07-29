import 'package:chatex/core/constants/api_constants.dart';

class FriendService {
  Future<List<Map<String, dynamic>>> fetchFriends(int myId) async {
    // Supabase Join: Lekérjük a barátságokat, és rögtön hozzácsatoljuk a barát adatait
    final response =
        await supabase.from('friends').select('friend_id, users!friends_friend_id_fkey(id, username, profile_picture)').eq('user_id', myId);

    return (response as List<dynamic>).map((row) {
      final user = row['users'] as Map<String, dynamic>;
      return {
        'id': user['id'],
        'username': user['username'],
        'profile_picture': user['profile_picture'],
      };
    }).toList();
  }

  // --- BARÁT TÖRLÉSE ---
  Future<void> removeFriend(int myId, int friendId) async {
    // Töröljük a kapcsolatot mindkét irányból
    await supabase.from('friends').delete().or('and(user_id.eq.$myId,friend_id.eq.$friendId),and(user_id.eq.$friendId,friend_id.eq.$myId)');
  }

  // --- BARÁTKÉRÉSEK LEKÉRÉSE ---
  Future<List<Map<String, dynamic>>> fetchFriendRequests(int myId) async {
    final response = await supabase
        .from('friend_requests')
        .select('id, sender_id, users!friend_requests_sender_id_fkey(id, username, profile_picture)')
        .eq('receiver_id', myId)
        .eq('status', 'pending');

    return (response as List<dynamic>).map((row) {
      final user = row['users'] as Map<String, dynamic>;
      return {
        'id': row['id'],
        'sender_id': user['id'], // Ez kelleni fog az elfogadáshoz!
        'username': user['username'],
        'profile_picture': user['profile_picture'],
      };
    }).toList();
  }

  // --- BARÁTKÉRÉS ELFOGADÁSA ---
  Future<void> acceptRequest(int myId, int senderId, int requestId) async {
    // 1. Beszúrjuk a barátságot mindkét irányból
    await supabase.from('friends').insert([
      {'user_id': myId, 'friend_id': senderId},
      {'user_id': senderId, 'friend_id': myId},
    ]);
    // 2. Töröljük a barátkérést
    await supabase.from('friend_requests').delete().eq('id', requestId);
  }

  // --- BARÁTKÉRÉS ELUTASÍTÁSA ---
  Future<void> declineRequest(int requestId) async {
    await supabase.from('friend_requests').delete().eq('id', requestId);
  }
}
