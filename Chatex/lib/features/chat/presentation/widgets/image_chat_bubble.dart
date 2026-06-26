import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chatex/features/notifications/data/notifications.dart';
import 'dart:typed_data';
import 'dart:developer';
import 'dart:io';
import 'package:chatex/l10n/app_localizations.dart';

//ImageChatBubble OSZTÁLY ELEJE -----------------------------------------------------------------
class ImageChatBubble extends StatefulWidget {
  const ImageChatBubble({
    super.key,
    required this.imageUrls,
    required this.sentAt,
    required this.isSender,
    this.messageText,
    this.svgProfileBytes,
    this.cachedImage,
    this.isRead = false,
    this.onTapScrollToBottom,
    this.isLastMessage = false,
  });

  final List<String> imageUrls;

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
  State<ImageChatBubble> createState() => _ImageChatBubbleState();
}

class _ImageChatBubbleState extends State<ImageChatBubble> {
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

  Future<void> _downloadImage(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return;

      final directory = await getDownloadsDirectory();
      final path = "${directory!.path}/$fileName";
      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);

      await NotificationService.showNotification(
        title: "Kép elmentve",
        body: "$fileName elmentve ide:\n$path",
      );
    } catch (e) {
      await NotificationService.showNotification(
        title: "Hiba",
        body: "Nem sikerült letölteni a képet!",
      );
      log("Kép letöltési hiba: ${e.toString()}");
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
      child: _buildImageChatBubble(), //az image bubble-t megjelenítő widget
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildImageChatBubble() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 20),
      child: Row(
        mainAxisAlignment: widget.isSender
            //bal vagy jobb oldalon jelenjen meg a chaten
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: _showDetails
            //a profilkép helye ne változzon, ha megnézzük az üzenetet részleteit
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.start,
        children: [
          //csak akkor jelenjen meg a profilkép, ha nem a fogadó küldte az üzenetet
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
                      0.7, //maximum a szélesség 70%-át foglalhatja el az image bubble
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.isSender ? Colors.deepPurpleAccent : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, //hány oszlopban legyenek a képek
                        mainAxisSpacing: 5, //képek közötti távolság
                      ),
                      itemCount: widget.imageUrls.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: () async {
                              final url = widget.imageUrls[index];
                              final fileName = widget.imageUrls[index].split("/").last;
                              //a kép kattintásakor letöltődik az eszközre
                              await _downloadImage(url, fileName);
                            },
                            child: Image.network(
                              widget.imageUrls[index],
                              fit: BoxFit.fill, //hogy jelenjen meg a kép
                            ),
                          ),
                        );
                      },
                    ),
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

//ImageChatBubble OSZTÁLY VÉGE ------------------------------------------------------------------
