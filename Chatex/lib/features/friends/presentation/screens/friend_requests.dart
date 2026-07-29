import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:chatex/l10n/app_localizations.dart';
import 'package:chatex/features/friends/data/friend_service.dart';

//FriendRequests OSZTÁLY ELEJE --------------------------------------------------------------------
class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  List<dynamic> _friendRequests = [];
  bool _isLoading = true;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _fetchFriendRequests();
  }

  Future<void> _fetchFriendRequests() async {
    final service = FriendService();

    try {
      final requests = await service.fetchFriendRequests(Preferences.getUserId()!);
      if (mounted) {
        setState(() {
          _friendRequests = requests;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastMessages.showToastMessages(
          l10n.connectionErrorFriendRequests,
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
        setState(() => _isLoading = false);
      }
      log("Kapcsolati hiba a barát kérések lekérésénél! ${e.toString()}");
    }
  }

  // FIGYELEM: Új paraméter a senderId!
  Future<void> _acceptRequest(int requestId, int senderId) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final service = FriendService();

    try {
      await service.acceptRequest(Preferences.getUserId()!, senderId, requestId);
      if (mounted) {
        ToastMessages.showToastMessages(
          l10n.friendRequestAccepted,
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        setState(() => _friendRequests.removeWhere((req) => req['id'] == requestId));
        //TODO: errorOccuredAccepting nincs itt
        if (_friendRequests.isEmpty) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ToastMessages.showToastMessages(
          l10n.connectionErrorAcceptingFriendRequests,
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
      log("Kapcsolati hiba a barátkérés elfogadásakor! ${e.toString()}");
    }
  }

  Future<void> _declineRequest(int requestId) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final service = FriendService();

    try {
      await service.declineRequest(requestId);
      if (mounted) {
        ToastMessages.showToastMessages(
          l10n.friendRequestDeclined,
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
        setState(() => _friendRequests.removeWhere((req) => req['id'] == requestId));
        //TODO: errorOccuredDeclining nincs itt
        if (_friendRequests.isEmpty) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ToastMessages.showToastMessages(
          l10n.connectionErrorDecliningFriendRequests,
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
      log("Kapcsolati hiba a barátkérés elutasítása közben! ${e.toString()}");
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: _buildAppbar(),
        body: _isLoading //ha tölt akkor egy töltő kört jelenítsen meg
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _friendRequests.isEmpty //különben nézze meg hogy van e kérés vagy nincs
                ? _noRequestsWidget()
                : _friendRequestsList(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(
        l10n.friendRequests,
      ),
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
    );
  }

  Widget _noRequestsWidget() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        l10n.noNewFriendRequest,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  // Widget _buildProfileImage(String? profilePicture) {
  //   final l10n = AppLocalizations.of(context)!;
  //   if (profilePicture == null || profilePicture.isEmpty) {
  //     return _defaultAvatar();
  //   }
  //
  //   try {
  //     if (profilePicture.startsWith("data:image/svg+xml;base64,")) {
  //       final svgString = base64Decode(profilePicture.split(",")[1]);
  //       return ClipOval(
  //         child: SvgPicture.memory(
  //           svgString,
  //           width: 60,
  //           height: 60,
  //           fit: BoxFit.fill,
  //         ),
  //       );
  //     } else if (profilePicture.startsWith("data:image/")) {
  //       final imageBytes = base64Decode(profilePicture.split(",")[1]);
  //       return ClipOval(
  //         child: Image.memory(
  //           imageBytes,
  //           width: 60, //(width, height)*2 = radius
  //           height: 60,
  //           fit: BoxFit.fill,
  //         ),
  //       );
  //     } else {
  //       ToastMessages.showToastMessages(
  //         l10n.unknownMimeType,
  //         0.2,
  //         Colors.redAccent,
  //         Icons.error,
  //         Colors.black,
  //         const Duration(seconds: 2),
  //         context,
  //       );
  //       log("An unknown MIME type has been detected: $profilePicture");
  //       return _defaultAvatar();
  //     }
  //   } catch (e) {
  //     ToastMessages.showToastMessages(
  //       l10n.errorWhileDecodingImage,
  //       0.2,
  //       Colors.redAccent,
  //       Icons.error,
  //       Colors.black,
  //       const Duration(seconds: 2),
  //       context,
  //     );
  //     log("Hiba a kép dekódolásakor: ${e.toString()}");
  //     return _defaultAvatar();
  //   }
  // }

  // --- ÚJ NETWORK IMAGE PROFILKÉP METÓDUS ---
  Widget _buildProfilePicture(String? profilePicture) {
    if (profilePicture != null && profilePicture.startsWith('http')) {
      return CircleAvatar(
        radius: 30, // Itt 30-as sugarat használtál!
        backgroundImage: NetworkImage(profilePicture),
        backgroundColor: Colors.transparent,
      );
    } else {
      return _defaultAvatar(); // Ez hívja a már meglévő szürke defaultAvatar metódusodat!
    }
  }

  Widget _defaultAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[600],
      child: const Icon(
        Icons.person,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Widget _buildFriendRequestCard(dynamic request) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        leading: _buildProfilePicture(request["profile_picture"]),
        title: AutoSizeText(
          maxLines: 1,
          request['username'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text(
          l10n.friendRequest,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        trailing: Row(
          //a legkevesebb helyet foglalva jelenítse meg a kettő gombot
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ),
              // ITT ADJUK ÁT A SENDER ID-T IS:
              onPressed: () => _acceptRequest(request['id'], request['sender_id']),
            ),
            IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () => _declineRequest(request['id']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _friendRequestsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      itemCount: _friendRequests.length,
      itemBuilder: (context, index) {
        final request = _friendRequests[index];
        return _buildFriendRequestCard(request);
      },
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//FriendRequests OSZTÁLY VÉGE ---------------------------------------------------------------------
