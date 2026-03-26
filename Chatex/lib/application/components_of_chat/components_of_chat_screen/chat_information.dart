import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatex/application/components_of_chat/build_ui.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:developer';
import 'dart:convert';

//ChatInfoScreen OSZTÁLY ELEJE --------------------------------------------------------------------
class ChatInfoScreen extends StatefulWidget {
  const ChatInfoScreen({
    super.key,
    required this.chatId,
  });

  //átadjuk a chatId-t hogy tudjuk melyik chat információit jelenítsük meg! (jelenleg csak törlés gomb)
  final int chatId;

  @override
  State<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  //ez a változó felel azért hogy többször egymás után ne lehessen megnyomni a törlés gombot (exceptiont adna!)
  bool _isDeleting = false;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  Future<void> _deleteChat(BuildContext context) async {
    if (_isDeleting) return; // ha már fut, akkor kilépünk

    setState(() {
      _isDeleting = true; // amikor elindul a törlés
    });

    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/chat/set/delete_chat.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          //ezek alapján azonosítjuk a törlést
          "chat_id": widget.chatId,
          //kinek töröljük ki a chatet (user_id - friend_id alapján)
          "user_id": Preferences.getUserId(),
        }),
      );

      final responseData = jsonDecode(response.body);
      if (responseData["success"] == true) {
        if (!context.mounted) return;

        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "A beszélgetés sikeresen törölve lett!"
              : "Chat deleted successfully!",
          0.2,
          Colors.green,
          Icons.check_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );

        //a sikeres törlés után visszatérünk a chat listához
        Future.delayed(const Duration(milliseconds: 3500), () {
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ChatUI()),
              (route) => false, // minden route-ot töröl ami ide vezetett
            );
          }
        });
      } else {
        if (!context.mounted) return;

        setState(() {
          _isDeleting = false; //lehessen újra törölni, ha hiba történt
        });

        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt a törlés során!"
              : "Failed to delete chat!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
        log("Chat törlés sikertelen: ${response.body}");
      }
    } catch (e) {
      if (!context.mounted) return;

      setState(() {
        _isDeleting = false; //lehessen újra törölni, ha hiba történt
      });

      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nchat törlése közben!"
            : "Connection error while\ndeleting chat!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a chat törlése közben! ${e.toString()}");
      return;
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: _buildAppBar(),
      body: _buildDeleteChatButton(context),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 10,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      title: Text(
        Preferences.isHungarian ? "Chat információi" : "Chat information",
      ),
    );
  }

  Widget _buildDeleteChatButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
        alignment: Alignment.topCenter,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            //más design ha már történik törlés
            disabledBackgroundColor: Colors.grey[700],
            disabledForegroundColor: Colors.white,
          ),
          icon: const Icon(
            Icons.delete,
            size: 40,
          ),
          label: Text(
            Preferences.isHungarian ? "Chat törlése" : "Delete chat",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          //megerősítő dialógus, csak akkor ha nem fut már egy!
          onPressed: _isDeleting ? null : () => _confirmDelete(context),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        //megkülönböztetjük a dialógusban használt context-et a törlési context-el,
        //mert exceptiont adna ha ugyanazt használnánk!
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          elevation: 10,
          shadowColor: Colors.deepPurpleAccent,
          title: AutoSizeText(
            Preferences.isHungarian
                ? "Biztosan törlöd a chatet?"
                : "Are you sure you want to delete the chat?",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: AutoSizeText(
            Preferences.isHungarian
                ? "Ez a művelet nem visszavonható!"
                : "This action cannot be undone!",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                Preferences.isHungarian ? "Mégse" : "Cancel",
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: Text(
                Preferences.isHungarian ? "Törlés" : "Delete",
                style: const TextStyle(
                  color: Colors.redAccent,
                  letterSpacing: 1,
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                //"eredeti" context-el törlünk!
                _deleteChat(context);
              },
            ),
          ],
        );
      },
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//ChatInfoScreen OSZTÁLY VÉGE ---------------------------------------------------------------------
