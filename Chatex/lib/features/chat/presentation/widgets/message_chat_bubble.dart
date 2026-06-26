import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:typed_data';
import 'package:chatex/l10n/app_localizations.dart';

//MessageChatBubble OSZTÁLY ELEJE -----------------------------------------------------------------
class MessageChatBubble extends StatefulWidget {
  const MessageChatBubble({
    super.key,
    required this.messageText,
    required this.sentAt,
    required this.isSender,
    this.svgProfileBytes,
    this.cachedImage,
    this.isRead = false,
    this.onTapScrollToBottom,
    this.isLastMessage = false,
  });

  //ezek a mezők mind a 3 message bubble-ben megtalálhatók
  final String? messageText;
  final String sentAt;
  final bool isSender;
  final Uint8List? svgProfileBytes;
  final ImageProvider<Object>? cachedImage;
  final bool isRead;
  final VoidCallback? onTapScrollToBottom;
  final bool isLastMessage;

  @override
  State<MessageChatBubble> createState() => _MessageChatBubbleState();
}

class _MessageChatBubbleState extends State<MessageChatBubble> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  bool _showDetails = false;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  void _toggleDetails() {
    //üzenet információi ki/be nyomásra
    setState(() {
      _showDetails = !_showDetails;
    });

    if (widget.onTapScrollToBottom != null && widget.isLastMessage) {
      widget.onTapScrollToBottom!();
    }
  }

  Widget _buildProfileImage() {
    if (widget.svgProfileBytes != null) {
      return SvgPicture.memory(
        widget.svgProfileBytes!,
        width: 36,
        height: 36,
        fit: BoxFit.fill,
      );
    } else if (widget.cachedImage != null) {
      return Image(
        image: widget.cachedImage!,
        width: 36,
        height: 36,
        fit: BoxFit.fill,
      );
    } else {
      return const Icon(
        Icons.person,
        size: 36,
        color: Colors.white,
      );
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDetails, //nyíljon ki a bubble a részletekért
      child: _buildMessageChatBubble(), //a message bubble-t megjelenítő widget
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildMessageChatBubble() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
      child: Row(
        mainAxisAlignment: widget.isSender
            //bal vagy jobb oldalon jelenjen meg az üzenet
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: _showDetails
            //a profilkép helye ne változzon
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.start,
        children: [
          if (!widget.isSender)
            ClipOval(
              child: _buildProfileImage(),
            ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: widget.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width *
                      0.5, //maximum a szélesség 50%-át foglalhatja el a message bubble
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.isSender ? Colors.deepPurpleAccent : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  widget.messageText ?? "", //nem lehet null az üzenet!
                  style: TextStyle(
                    color: widget.messageText == null ? Colors.redAccent : Colors.white,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ),
              if (_showDetails) ...[
                const SizedBox(height: 4),
                Text(
                  widget.sentAt,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[500],
                  ),
                ),
                if (widget.isSender)
                  Text(
                    widget.isRead ? l10n.seen : l10n.delivered,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: widget.isRead ? Colors.greenAccent : Colors.grey[500],
                    ),
                  ),
              ]
            ],
          ),
        ],
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//MessageChatBubble OSZTÁLY VÉGE ------------------------------------------------------------------
