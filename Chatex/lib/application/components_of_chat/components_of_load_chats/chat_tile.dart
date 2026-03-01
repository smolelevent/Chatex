import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/logic/preferences.dart';
import 'dart:convert';

//ChatTile OSZTÁLY ELEJE --------------------------------------------------------------------------
class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chatName,
    required this.lastMessage,
    required this.time,
    required this.profileImage,
    required this.onTap,
    required this.isOnline,
    required this.signedIn,
    required this.unreadCount,
  });

  final String chatName;
  final String lastMessage;
  final String time;
  final String profileImage;
  final VoidCallback onTap;
  final String isOnline;
  final int signedIn;
  final int unreadCount;

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  String formatMessageTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp).toLocal(); //lokális időzóna
      final now = DateTime.now(); //mostani idő
      final difference = now
          .difference(dateTime); //különbség a mostani idő és a timestamp között

      if (difference.inMinutes < 1) {
        return Preferences.isHungarian ? "Épp most" : "Just now";
      } else if (difference.inMinutes < 60) {
        return Preferences.isHungarian
            ? "${difference.inMinutes} perce"
            : "${difference.inMinutes} minute(s) ago";
      } else if (difference.inHours < 24 && now.day == dateTime.day) {
        return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } else if (difference.inHours < 48 && now.day - dateTime.day == 1) {
        return Preferences.isHungarian ? "Tegnap" : "Yesterday";
      } else {
        return "${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      }
    } catch (e) {
      return ""; //pl.: amikor nincs még üzenet
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return _buildChatTile();
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildProfileImage(String imageString, String isOnline, int signedIn) {
    Widget imageWidget;

    if (imageString.startsWith("data:image/svg+xml;base64,")) {
      final svgBytes = base64Decode(imageString.split(",")[1]);
      imageWidget = SvgPicture.memory(
        svgBytes,
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      );
    } else if (imageString.startsWith("data:image/")) {
      final base64Data = base64Decode(imageString.split(",")[1]);
      imageWidget = Image.memory(
        base64Data,
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      );
    } else {
      imageWidget = const Icon(
        Icons.person,
        size: 40,
        color: Colors.white,
      );
    }

    return SizedBox(
      //profilképnél nagyobb legyen, eltávolítása exception-t ad
      width: 66,
      height: 66,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[800],
              child: ClipOval(child: imageWidget),
            ),
          ),
          Positioned(
            //a státusz karika helye
            bottom: -6,
            right: 10,
            child: Container(
              //a státusz karika mérete
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: isOnline == "online" && signedIn == 1
                    ? Colors.green
                    : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile() {
    final bool hasUnreadMessages = unreadCount > 0;

    return Card(
      color: Colors.black45,
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        //ha van olvasotlan üzenetei akkor legyen egy fehér keret a tile körül
        side: hasUnreadMessages
            ? const BorderSide(
                color: Colors.white,
                width: 2,
              )
            : BorderSide.none,
      ),
      elevation: 5,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        leading: _buildProfileImage(profileImage, isOnline, signedIn),
        title: AutoSizeText(
          maxLines: 1,
          chatName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: hasUnreadMessages
                      ? Colors.white
                      : Colors.grey[400], //emelje ki az olvasatlan üzenetet
                ),
              ),
            ),
            if (hasUnreadMessages)
              AnimatedSwitcher(
                //animációval változzon a olvasatlan üzenetek számlálója
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Container(
                  key: ValueKey<int>(
                    unreadCount,
                  ),
                  margin: const EdgeInsets.only(left: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: const BoxDecoration(
                    //piros kerettel jelenjen meg a feltünőség érdekében
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        trailing: Text(
          formatMessageTime(time), //formázzuk az utlolsó üzenet időpontját
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//ChatTile OSZTÁLY VÉGE ---------------------------------------------------------------------------
