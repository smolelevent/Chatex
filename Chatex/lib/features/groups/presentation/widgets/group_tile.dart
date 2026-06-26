import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:convert';

//GroupTile OSZTÁLY ELEJE --------------------------------------------------------------------
class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.groupName,
    required this.lastMessage,
    required this.time,
    required this.profileImage,
    required this.onTap,
  });

  final String groupName;
  final String lastMessage;
  final String time;
  final String profileImage;
  final VoidCallback onTap;

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  Widget _buildProfileImage(String imageString) {
    //az összes képet base64-es kódolással értelmezzük
    if (imageString.startsWith("data:image/svg+xml;base64,")) {
      final svgBytes = base64Decode(imageString.split(",")[1]);
      return SvgPicture.memory(
        svgBytes,
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      );
    } else if (imageString.startsWith("data:image/")) {
      final base64Data = base64Decode(imageString.split(",")[1]);
      return Image.memory(
        base64Data,
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      );
    } else {
      return const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 30,
        child: Icon(
          Icons.groups,
          size: 50,
          color: Colors.white,
        ),
      );
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return _buildGroupTile();
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildGroupTile() {
    return Card(
      color: Colors.black45,
      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: ClipOval(child: _buildProfileImage(profileImage)),
        title: AutoSizeText(
          maxLines: 1,
          groupName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        trailing: Text(
          time,
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
//GroupTile OSZTÁLY VÉGE --------------------------------------------------------------------------
