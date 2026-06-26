import 'package:flutter/material.dart';
import 'package:chatex/features/chat/presentation/widgets/chat_tile.dart';
import 'package:chatex/features/chat/presentation/screens/chat_screen.dart';
import 'package:chatex/core/utils/permissions.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatex/core/constants/api_constants.dart';

//LoadedChatData OSZTÁLY ELEJE --------------------------------------------------------------------
class LoadedChatData extends StatefulWidget {
  const LoadedChatData({super.key});

  @override
  LoadedChatDataState createState() => LoadedChatDataState();
}

class LoadedChatDataState extends State<LoadedChatData> {
  //OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  late Future<List<dynamic>> _chatList = Future.value([]);
  late RealtimeChannel _channel; // A Supabase hivatalos WebSocket csatornája

  //OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

  //HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    //szükséges a Future.delayed mivel meg kell hogy várja a kis folyamatokat hogy végezzenek
    Future.delayed(Duration.zero, () async {
      await requestNotificationPermission(context);
      await requestDownloadPermission(context);
    });
    _connectToSupabaseRealtime();
    _getCorrectChatList();
  }

  @override
  void dispose() {
    supabase.removeChannel(_channel); // Leiratkozás kilépéskor (Memóriaszivárgás megelőzése!)
    super.dispose();
  }

  void _connectToSupabaseRealtime() {
// Ipari sztenderd: Csak a releváns táblára és rekordokra iratkozunk fel!
    _channel = supabase
        .channel('public:messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'receiver_id',
            value: Preferences.getUserId()!,
          ),
          callback: (payload) {
// Ha új üzenet érkezik nekünk az adatbázisba, azonnal frissítjük a listát
            _getCorrectChatList(); // újrahívja a chat listát
          },
        )
        .subscribe();
  }

  Future<void> _getCorrectChatList() async {
    setState(() {
      _chatList = _getChatList(Preferences.getUserId()!);
    });
    await _chatList;
  }

  Future<List<dynamic>> _getChatList(int userId) async {
    try {
// Hívjuk az Adatbázisban létrehozott okos függvényt!
      final response = await supabase.rpc('get_chat_list', params: {'req_user_id': userId});
      if (response != null) {
        return response as List<dynamic>;
      } else {
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ToastMessages.showToastMessages(
            l10n.couldntLoadChatList,
            0.3,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 3),
            context,
          );
        }

        return [];
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastMessages.showToastMessages(
          l10n.connectionErrorGetChats,
          0.3,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
      log("Hiba a chatek lekérése közben: ${e.toString()}");
      return [];
    }
  }

  //HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: _buildChatList(),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildEmptyChatList() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 20,
          ),
          children: [
            TextSpan(text: l10n.noChats),
            const WidgetSpan(
              child: Icon(
                Icons.add_comment,
                size: 20,
                color: Colors.white,
              ),
            ),
            TextSpan(text: l10n.iconEndOfSentence),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<dynamic>>(
      //_chatList alapján felépítjük a Cardokat
      future: _chatList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //amíg tölt addig karika
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.deepPurpleAccent,
            ),
          );
        }

        final dataFromChatList = snapshot.data ?? [];

        if (dataFromChatList.isEmpty) {
          return _buildEmptyChatList();
        }

        return RefreshIndicator(
          color: Colors.deepPurpleAccent,
          backgroundColor: Colors.black,
          //a manuális chat frissítést engedélyez a RefreshIndicator (fentről való lehúzással)
          onRefresh: _getCorrectChatList,
          child: ListView.builder(
            itemCount: dataFromChatList.length,
            itemBuilder: (context, index) {
              final chat = dataFromChatList[index];

              final String rawMessage = chat["last_message"]?.toString().trim() ?? "";
              final int? lastSenderId = chat["last_sender_id"];
              final int currentUserId = Preferences.getUserId() ?? -1;

              String prefix = "";
              if (lastSenderId == currentUserId) {
                prefix = l10n.you;
              }

              String lastMessage;
              if (rawMessage == "[FILE]") {
                lastMessage = prefix + l10n.fileAttached;
              } else if (rawMessage == "[IMAGE]") {
                lastMessage = prefix + l10n.imageSent;
              } else if (rawMessage.isEmpty) {
                lastMessage = l10n.noMessageYet;
              } else {
                lastMessage = prefix + rawMessage;
              }

              return ChatTile(
                chatName: chat["friend_name"],
                profileImage: chat["friend_profile_picture"] ?? "",
                lastMessage: lastMessage,
                time: chat["last_message_time"] ?? "",
                isOnline: chat["status"],
                signedIn: chat["signed_in"],
                unreadCount: chat["unread_count"] ?? 0,
                onTap: () async {
                  final shouldRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverId: chat["friend_id"],
                        chatName: chat["friend_name"],
                        profileImage: chat["friend_profile_picture"] ?? "",
                        lastSeen: chat["friend_last_seen"],
                        isOnline: chat["status"],
                        signedIn: chat["signed_in"],
                        chatId: chat["chat_id"],
                      ),
                    ),
                  );
                  //Csak akkor frissít, ha szükséges
                  if (shouldRefresh == true) {
                    _getCorrectChatList();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//LoadedChatData OSZTÁLY VÉGE ---------------------------------------------------------------------
