import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
import 'dart:developer';

//ManageFriends OSZTÁLY ELEJE --------------------------------------------------------------------
class ManageFriends extends StatefulWidget {
  const ManageFriends({super.key});

  @override
  State<ManageFriends> createState() => _ManageFriendsState();
}

class _ManageFriendsState extends State<ManageFriends> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  List<dynamic> _friends = []; //ebben a tároljuk el a felhasználó barátait
  bool _isLoading = true; //töltést fogja szolgálni

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    //ez a metódus a képernyő betöltésekor lekéri a barátokat, majd elmenti azt
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/ChatexProject/chatex_phps/friends/get/get_friends.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": Preferences.getUserId()}),
      );

      final responseData = jsonDecode(response.body);
      if (responseData["success"] == true) {
        setState(() {
          //mentsük el a barátokat és a töltést kapcsoljuk ki
          _friends = responseData["friends"];
          _isLoading = false;
        });
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nbarátok lekérésénél!"
            : "Connection error while\nloading friends!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a barátok lekérésénél! ${e.toString()}");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFriend(int friendId) async {
    //ez a metódus kitörli a felhasználó és a barát oldaláról is az egymással lévő barátságot
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/friends/set/remove_friend.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"user_id": Preferences.getUserId(), "friend_id": friendId}),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["success"] == true) {
        setState(() {
          //helyileg is kitöröljük
          _friends.removeWhere((f) => f["id"] == friendId);
        });
        ToastMessages.showToastMessages(
          Preferences.isHungarian ? "Barát törölve!" : "Friend removed!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      } else {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba a törlés közben"
              : "Error while deleting friend",
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\n barát törlése közben!"
            : "Connection error while\n removing friend!",
        0.2,
        Colors.redAccent,
        Icons.error_rounded,
        Colors.black,
        const Duration(seconds: 3),
        context,
      );
      log("Kapcsolati hiba a barát törlése közben! ${e.toString()}");
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: _buildAppbar(),
        body:
            _isLoading //ha igaz egy töltő kört jelenítünk meg, különben a barátokat
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.deepPurpleAccent,
                    ),
                  )
                : _buildManageFriendsList(),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.isHungarian ? "Barátok kezelése" : "Manage Friends",
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

  Widget _buildProfilePicture(String? profilePicture) {
    //base64 alapján
    Widget profileImage;

    if (profilePicture != null && profilePicture.isNotEmpty) {
      if (profilePicture.startsWith("data:image/svg+xml;base64,")) {
        final svgString =
            utf8.decode(base64Decode(profilePicture.split(",")[1]));
        profileImage = SvgPicture.string(
          svgString,
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        );
      } else if (profilePicture.startsWith("data:image/")) {
        profileImage = Image.memory(
          base64Decode(profilePicture.split(",")[1]),
          width: 50,
          height: 50,
          fit: BoxFit.fill,
        );
      } else {
        profileImage = CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[600],
          child: const Icon(
            Icons.person,
            size: 35,
            color: Colors.white,
          ),
        );
      }
    } else {
      profileImage = CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[600],
        child: const Icon(
          Icons.person,
          size: 35,
          color: Colors.white,
        ),
      );
    }

    return profileImage;
  }

  Widget _buildManageFriendsList() {
    //ez a metódus a people.dart logikáját és a friend_request.dart dizájnját követve megjeleníti a barátokat a _friends változó szerint
    if (_friends.isEmpty) {
      return Center(
        child: Text(
          Preferences.isHungarian
              ? "Jelenleg nincsenek barátaid!"
              : "Currently you have no friends!",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Center(
            child: Text(
              Preferences.isHungarian
                  ? "Jelenlegi barátaid"
                  : "Your current friends",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _friends.length,
            itemBuilder: (context, index) {
              //külön-külön fogja felépíteni a friend változó alapján (key-value)
              final friend = _friends[index];
              final int friendId = friend["id"];
              final String username = friend["username"];
              final String? profilePicture = friend["profile_picture"];

              return Card(
                color: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: ClipOval(
                    child: _buildProfilePicture(profilePicture),
                  ),
                  title: AutoSizeText(
                    username,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle_rounded,
                      color: Colors.redAccent,
                    ),
                    tooltip: Preferences.isHungarian ? "Törlés" : "Remove",
                    onPressed: () {
                      //megnyomáskor jelenjen meg a törlés dialógus
                      _showRemoveFriendDialog(friendId);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showRemoveFriendDialog(int friendId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          elevation: 10,
          shadowColor: Colors.deepPurpleAccent,
          title: Text(
            Preferences.isHungarian ? "Barát törlése" : "Remove friend",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Text(
            Preferences.isHungarian
                ? "Biztosan törölni szeretnéd ezt a barátot?"
                : "Are you sure you want to remove this friend?",
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
                ),
              ),
              onPressed: () {
                //ha Mégse-re nyom akkor csak kilép a dialógusból
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                Preferences.isHungarian ? "Törlés" : "Remove",
                style: const TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              onPressed: () async {
                //ha pedig a törlésre akkor kilép és lefuttatja a _removeFriend metódust
                Navigator.pop(context);
                await _removeFriend(friendId);
              },
            ),
          ],
        );
      },
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//ManageFriends OSZTÁLY VÉGE -----------------------------------------------------------------------------
