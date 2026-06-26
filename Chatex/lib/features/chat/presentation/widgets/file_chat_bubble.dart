import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/features/notifications/data/notifications.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'dart:typed_data';
import 'dart:developer';
import 'dart:async';
import 'dart:io';

//FileChatBubble OSZTÁLY ELEJE --------------------------------------------------------------------
class FileChatBubble extends StatefulWidget {
  const FileChatBubble({
    super.key,
    required this.fileNames,
    required this.downloadUrls,
    required this.sentAt,
    required this.isSender,
    this.messageText,
    this.svgProfileBytes,
    this.cachedImage,
    this.isRead = false,
    this.onTapScrollToBottom,
    this.isLastMessage = false,
  });

  final List<String> fileNames;
  final List<String> downloadUrls;

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
  State<FileChatBubble> createState() => _FileChatBubbleState();
}

class _FileChatBubbleState extends State<FileChatBubble> {
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

  Future<void> _downloadFile(int index) async {
    try {
      final uri = Uri.tryParse(widget.downloadUrls[index]);
      if (uri == null || uri.toString().isEmpty) return;

      final response = await http.get(uri);
      if (response.statusCode != 200) return;

      //eszköz letöltési könyvtára
      final directory = await getDownloadsDirectory();

      //ahova menteni szeretnénk
      final filePath = "${directory!.path}/${widget.fileNames[index]}";
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await NotificationService.showNotification(
        title: "Letöltés kész",
        body: "${widget.fileNames[index]} elmentve ide:\n$filePath",
      );
    } catch (e) {
      await NotificationService.showNotification(
        title: "Hiba",
        body: "Nem sikerült letölteni a file-t!",
      );
      log("Fájl letöltési hiba: ${e.toString()}");
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
      child: _buildFileChatBubble(), //a file bubble-t megjelenítő widget
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildFileChatBubble() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
      child: Row(
        mainAxisAlignment: widget.isSender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start, //bal vagy jobb oldalon jelenjen meg a chaten
        crossAxisAlignment:
            _showDetails ? CrossAxisAlignment.start : CrossAxisAlignment.start, //a profilkép helye ne változzon
        children: [
          //csak akkor jelenjen meg a profilkép, ha nem én küldtem a message-t
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
                  maxWidth:
                      MediaQuery.of(context).size.width * 0.5, //maximum a szélesség 50%-át foglalhatja el a file bubble
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.isSender ? Colors.deepPurpleAccent : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    if (widget.messageText != null && widget.messageText!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          widget.messageText!, //itt már lehet null az üzenet
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ...List.generate(widget.fileNames.length, (index) {
                      return TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          _downloadFile(index);
                        },
                        icon: const Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        label: AutoSizeText(
                          maxLines: 2,
                          widget.fileNames[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      );
                    }),
                  ],
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

//FileChatBubble OSZTÁLY VÉGE ------------------------------------------------------------------
