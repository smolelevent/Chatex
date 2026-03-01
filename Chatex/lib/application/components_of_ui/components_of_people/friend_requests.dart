import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
import 'dart:developer';

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
    //ez a metódus a képernyő betöltésekor lekéri a barát kéréseket, majd elmenti azt
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/get/get_requests.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
        }),
      );

      final responseData = jsonDecode(response.body);
      if (responseData["success"] == true) {
        setState(() {
          //mentsük el a kéréseket és a töltést kapcsoljuk ki
          _friendRequests = responseData['requests'];
          _isLoading = false;
        });
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nbarát kérések lekérésénél!"
            : "Connection error while\nloading friend requests!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a barát kérések lekérésénél! ${e.toString()}");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(int requestId) async {
    //ez a metódus a barát kérés küldő id-e szerint hozzáadja mind a kettő felhasználót egymás barátlistájához
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/set/accept_request.php'),
        body: jsonEncode({'request_id': requestId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Barát kérés sikeresen elfogadva!"
              : "Friend request accepted!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        setState(() {
          //helyileg is töröljük a képernyőről
          _friendRequests.removeWhere((req) => req['id'] == requestId);
        });
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt az elfogadás során!"
              : "An error occured while accepting!",
          0.2,
          Colors.red,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }

      if (_friendRequests.isEmpty) {
        //ha nincs több barátkérés akkor egyből dobjon vissza az előző képernyőre
        Navigator.pop(context);
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\njelölés elfogadásakor!"
            : "Connection error while\naccepting request!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a barátkérés elfogadásakor! ${e.toString()}");
    }
  }

  Future<void> _declineRequest(int requestId) async {
    //ez a metódus elutasítja a küldő fél barátkérését
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/set/decline_request.php'),
        body: jsonEncode({'request_id': requestId}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Barátkérés elutasítva!"
              : "Friend request declined!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
        setState(() {
          //helyileg eltávolítjuk
          _friendRequests.removeWhere((req) => req['id'] == requestId);
        });
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt az elutasítás során!"
              : "An error occured while declining",
          0.2,
          Colors.red,
          Icons.error,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }

      if (_friendRequests.isEmpty) {
        //ha üres kilépünk a képernyőről
        Navigator.pop(context);
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\njelölés elutasításakor!"
            : "Connection error while\ndeclineing friend request!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
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
            : _friendRequests
                    .isEmpty //különben nézze meg hogy van e kérés vagy nincs
                ? _noRequestsWidget()
                : _friendRequestsList(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.isHungarian ? "Jelölések" : "Friend Requests",
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
    return Center(
      child: Text(
        Preferences.isHungarian
            ? "Nincsenek új jelölések"
            : "No new friend requests",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildProfileImage(String? profilePicture) {
    if (profilePicture == null || profilePicture.isEmpty) {
      return _defaultAvatar();
    }

    try {
      if (profilePicture.startsWith("data:image/svg+xml;base64,")) {
        final svgString = base64Decode(profilePicture.split(",")[1]);
        return ClipOval(
          child: SvgPicture.memory(
            svgString,
            width: 60,
            height: 60,
            fit: BoxFit.fill,
          ),
        );
      } else if (profilePicture.startsWith("data:image/")) {
        final imageBytes = base64Decode(profilePicture.split(",")[1]);
        return ClipOval(
          child: Image.memory(
            imageBytes,
            width: 60, //(width, height)*2 = radius
            height: 60,
            fit: BoxFit.fill,
          ),
        );
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Ismeretlen MIME-típus a profilképnél!"
              : "An unknown MIME type has been detected!",
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
        log("An unknown MIME type has been detected: $profilePicture");
        return _defaultAvatar();
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Hiba a kép dekódolásakor!"
            : "Error in picture decoding!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Hiba a kép dekódolásakor: ${e.toString()}");
      return _defaultAvatar();
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
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        leading: _buildProfileImage(request["profile_picture"]),
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
          Preferences.isHungarian ? "Barát jelölés" : "Friend request",
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
              onPressed: () => _acceptRequest(request['id']),
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
