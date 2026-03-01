import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/application/components_of_chat/chat_screen.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:developer';
import 'dart:convert';

//StartChat OSZTÁLY ELEJE -------------------------------------------------------------------------
class StartChat extends StatefulWidget {
  const StartChat({super.key});

  @override
  State<StartChat> createState() => _StartChatState();
}

class _StartChatState extends State<StartChat> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  final TextEditingController _searchController =
      TextEditingController(); //keresési szöveg
  final FocusNode _searchFocusNode = FocusNode(); //keresési mező fokuszálásához
  bool _isSearchFocused =
      false; //keresési mező fokuszálását elmentjük egy bool-ba
  String _searchQuery = ""; //keresési mező tartalma

  List<dynamic> _friends = []; //barátok listája
  bool _isLoading = true; //loading spinner megjelenítése

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    //figyeljük a focusNode változásait amit a _isSearchFocused-ba mentünk!
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
    //betöltjük a felhasználó barátait
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      if (Preferences.getUserId() == null) return;

      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/chat/get/get_friend_list.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": Preferences.getUserId()}),
      );

      final List<dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _friends =
              responseData; //ha sikeresen lekértük akkor a _friends tömb-be mentse a felhasználó barátait
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Nem sikerült betölteni a barátaid!"
              : "Couldn't load your friends!",
          0.1,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 4),
          context,
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nbarátlista lekérésénél!"
            : "Connection error while\ngetting friend list!",
        0.1,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 4),
        context,
      );
      log("Kapcsolati hiba a barátlista lekérésénél! ${e.toString()}");
    }
  }

  void _startChatWith(int friendId) async {
    try {
      //csak olyan felhasználókkal lehet chatelni akikkel még nincs chat
      final int? senderId = Preferences.getUserId();

      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/chat/set/start_chat.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "sender_id": senderId, //a jelenleg bejelentkezett felhasználó
          "receiver_id":
              friendId, //az adott felhasználó id-je akivel chatelni szeretnénk
        }),
      );

      final responseData = jsonDecode(response.body);

      if (responseData["message"] == "Chat létrehozva!") {
        ToastMessages.showToastMessages(
          Preferences.isHungarian ? "Chat létrehozva!" : "Chat created!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );

        //ha sikeresen létrehoztuk a chatet akkor átirányít a chat képernyőre
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiverId: responseData["friend_id"],
              chatName: responseData["friend_name"],
              profileImage: responseData["friend_profile_picture"] ?? "",
              lastSeen: responseData["last_seen"],
              isOnline: responseData["status"],
              signedIn: responseData["signed_in"],
              chatId: responseData["chat_id"],
            ),
          ),
        );
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nchat kezdeményezésénél!"
            : "Connection error while\nstarting chat!",
        0.1,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Kapcsolati hiba a chat kezdeményezésénél! ${e.toString()}");
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(),
        backgroundColor: Colors.grey[850],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: _buildSearchField(),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      ),
                    )
                  : _buildFriendList(),
            ),
          ],
        ),
      ),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        Preferences.isHungarian ? "Chat kezdése" : "Start a chat",
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

  Widget _buildSearchField() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        //flutter_form_builder csomaggal készített kereső mező
        key: const Key("chatStartSearch"),
        name: "chat_start_search",
        controller: _searchController, //kitudjuk nyerni a tartalmát
        focusNode:
            _searchFocusNode, //design változás (hintText és labelText) amikor fokuszban van
        onChanged: (searchQuery) {
          setState(() {
            _searchQuery = searchQuery ?? ""; //keresési mező tartalma
          });
        },
        keyboardType:
            TextInputType.name, //név kereséshez alkalmas billentyűzet kiosztás
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17.0,
        ),
        decoration: _decorationForInput(),
      ),
    );
  }

  InputDecoration _decorationForInput() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[800],
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      hintText: _isSearchFocused //ellentétes logika a labelText-hez képest
          ? null
          : Preferences.isHungarian
              ? "Ismerősök keresése..."
              : "Search friends...",
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 17.0,
      ),
      labelText: _isSearchFocused //ellentétes logika a hintText-hez képest
          ? Preferences.isHungarian
              ? "Ismerősök keresése..."
              : "Search friends..."
          : null,
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17.0,
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Colors.white,
        size: 28,
      ),
      suffixIcon: _searchController.text.isNotEmpty
          //tartalom törlő gomb
          ? GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
              child: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.white70,
          width: 2.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.deepPurpleAccent,
          width: 2.5,
        ),
      ),
    );
  }

  Widget _buildFriendList() {
    //kereséskor ebben a listában mentjük el minden olyan felhasználót akinek a neve megegyezik a kereséssel (.startsWith-el)
    final filteredFriendList = _friends.where(
      (friend) {
        final username = (friend["username"] as String).toLowerCase();
        return username.startsWith(_searchQuery.toLowerCase());
      },
    ).toList();

    if (filteredFriendList.isEmpty) {
      //sajnos ezt nem lehet külön metódusba tenni mivel nem fog működni
      return Center(
        child: Text(
          Preferences.isHungarian ? "Nincs találat" : "No results found",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    //ha van találat akkor:
    return ListView.builder(
      itemCount: filteredFriendList.length,
      itemBuilder: (context, index) {
        //elmentjük a tetszőleges elemét a listának egy user változóba
        final user = filteredFriendList[index];

        //és annak az elemeit eltároljuk külön is
        final receivedFriendId = user["id"];
        final receivedUsername = user["username"];
        final String? receivedProfilePicture = user["profile_picture"];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: ClipOval(
              child: _buildProfilePicture(receivedProfilePicture),
            ),
            title: Text(
              receivedUsername,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onTap: () => _startChatWith(receivedFriendId),
          ),
        );
      },
    );
  }

  Widget _buildProfilePicture(String? receivedProfilePicture) {
    //ezt fogjuk vissza adni profilképként
    Widget profilePicture;

    if (receivedProfilePicture != null && receivedProfilePicture.isNotEmpty) {
      if (receivedProfilePicture.startsWith("data:image/svg+xml;base64,")) {
        final svgString =
            utf8.decode(base64Decode(receivedProfilePicture.split(",")[1]));
        profilePicture = SvgPicture.string(
          svgString,
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        );
      } else if (receivedProfilePicture.startsWith("data:image/")) {
        profilePicture = Image.memory(
          base64Decode(receivedProfilePicture.split(",")[1]),
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        );
      } else {
        profilePicture = CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[800],
          child: const Icon(
            Icons.person,
            size: 40,
            color: Colors.white,
          ),
        );
      }
    } else {
      profilePicture = CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[800],
        child: const Icon(
          Icons.person,
          size: 40,
          color: Colors.white,
        ),
      );
    }

    return profilePicture;
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//StartChat OSZTÁLY VÉGE --------------------------------------------------------------------------
