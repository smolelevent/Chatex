import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/logic/preferences.dart';
import 'package:chatex/application/components_of_ui/components_of_people/friend_requests.dart';
import 'package:chatex/application/components_of_ui/components_of_people/manage_friends.dart';
import 'package:chatex/logic/toast_message.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';

//People OSZTÁLY ELEJE ----------------------------------------------------------------------------
class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  final TextEditingController _userSearchController =
      TextEditingController(); //a keresési mezőből ez kell hogy kinyerjük a szöveget

  final FocusNode _userSearchFocusNode =
      FocusNode(); //figyeli a szövegmező fókuszálását
  bool _isUserSearchFocused = false; //amit itt tárolunk el

  final _formKey = GlobalKey<FormBuilderState>();

  List<dynamic> _userSearchResults =
      []; //listában tároljuk a keresési találatokat

  //ameddig ez a időzítő fut addig nem keres (megvárja a felhasználót hogy befejezze az írást)
  Timer? _timer;

  int _friendRequestCount = 0; //barátkérés számláló

  //id-k alapján eltároljuk hogy pending a kérés vagy accepted
  final Map<int, String> _friendStatusMap = {};

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _userSearchFocusNode.addListener(() {
      setState(() {
        //összekötjük a kettőt
        _isUserSearchFocused = _userSearchFocusNode.hasFocus;
      });
    });
    _loadFriendRequestCount();
  }

  @override
  void dispose() {
    //ha már nincsenek használatban "eldobjuk"
    _userSearchController.dispose();
    _userSearchFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadFriendRequestCount() async {
    //ez a metódus a barátjelölések számát kéri le az adatbázisból amit majd megjelenítünk
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/friends/get/get_friend_request_count.php"),
        body: jsonEncode({"user_id": Preferences.getUserId()}),
        headers: {"Content-Type": "application/json"},
      );

      //lekérjük hogy a felhasználónak mennyi barátkérése van
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["success"]) {
          setState(() {
            //eltároljuk a számot
            _friendRequestCount = responseData["count"];
          });
        }
      }
    } catch (e) {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nbarátkérések számának lekérésékor!"
            : "Connection error while\nfetching friend requests (count)!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Kapcsolati hiba a barátkérések számának lekérésében! ${e.toString()}");
    }
  }

  void _searchUsers(String query) {
    //ez a metódus felel azért hogy az minden felhasználó megtudja keresni akit szeretnének barátnak jelölni
    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(
      const Duration(milliseconds: 500), //fél másodpercig vár
      () async {
        if (query.isEmpty || query.length < 3 || query.length > 20) {
          setState(() {
            //eredmény üres ha nem felel meg az if-nek
            _userSearchResults = [];
          });
          return;
          //különben lekérjük az adatbázisból a keresett felhasználókat
        }

        try {
          final response = await http.post(
            //elküldjük az adatbázisba is a keresett illetőt
            Uri.parse(
                "http://10.0.2.2/ChatexProject/chatex_phps/friends/get/search_users.php"),
            body: jsonEncode({"query": query}),
            headers: {"Content-Type": "application/json"},
          );

          if (response.statusCode == 200) {
            List<dynamic> responseData = jsonDecode(response.body);
            final String currentUsername = Preferences.getUsername();

            //A keresést indító felhasználót kizárjuk a keresési eredményekből
            responseData = responseData.where((user) {
              return user["username"] != currentUsername;
            }).toList();

            setState(() {
              _userSearchResults = responseData;
            });
          } else {
            setState(() {
              _userSearchResults = [];
            });
          }
        } catch (e) {
          ToastMessages.showToastMessages(
            Preferences.isHungarian
                ? "Kapcsolati hiba a\nfelhasználók lekérésekor!"
                : "Connection error while\n fetching users!",
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2),
            context,
          );
          log("Kapcsolati hiba a felhasználók lekérésekor! ${e.toString()}");
        }
      },
    );
  }

  Future<String> _checkFriendStatus(int friendId) async {
    //ez a metódus a kilistázott felhasználóknak nézi meg hogy van e függőben kérés vagy már barátja a küldőnek
    if (_friendStatusMap.containsKey(friendId)) {
      //ha a Map-unk tartalmazza a listázott felhasználó id-ját akkor térjen vissza vele (tehát már vagy barátja vagy függőben van egy kérés)
      return _friendStatusMap[friendId]!;
    }

    final response = await http.post(
      Uri.parse(
          "http://10.0.2.2/ChatexProject/chatex_phps/friends/get/check_friend_status.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": Preferences.getUserId(),
        "friend_id": friendId,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      //a message kulcs tartalmazhatja a "pending_request"-et, "already_friends", vagy a "can_send"-et
      final String status = responseData["message"];
      _friendStatusMap[friendId] = status; //hozzá rendeli a státuszt
      return status; //később ez alapján változik a design
    } else {
      ToastMessages.showToastMessages(
        Preferences.isHungarian
            ? "Kapcsolati hiba a\nbarátjelölés állapotának lekérésénél!"
            : "Connection error while fetching friend request status!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 2),
        context,
      );
      log("Kapcsolati hiba a barátjelölés állapotának lekérésénél! ${responseData.toString()}");
      _friendStatusMap[friendId] = "error";
      return "error";
    }
  }

  Future<void> _sendFriendRequest(int friendId) async {
    //ez a metódus barátkérést küld az adott felhasználónak
    try {
      final response = await http.post(
        Uri.parse(
            "http://10.0.2.2/ChatexProject/chatex_phps/friends/set/send_friend_request.php"),
        body: jsonEncode({
          "user_id": Preferences.getUserId(),
          "friend_id": friendId,
        }),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = jsonDecode(response.body);

      if (responseData["message"] == "Barátjelölés elküldve!") {
        //ha sikeres volt a küldés akkor átváltja a pending_request állapotra és így megváltozik a szöveg is!
        setState(() {
          _friendStatusMap[friendId] = "pending_request";
        });

        //a lefrissítést a keresés meghívásával kényszerítjük
        _searchUsers(_userSearchController.text);

        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Barátjelölés elküldve!"
              : "Friend request sent!",
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 4),
          context,
        );
      } else if (responseData["message"] ==
          "Hiba történt a barátjelölés során!") {
        ToastMessages.showToastMessages(
          Preferences.isHungarian
              ? "Hiba történt a barátjelölés során!"
              : "Error occurred while sending the friend request!",
          0.2,
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
            ? "Kapcsolati hiba a barátküldés közben!"
            : "Connection error while\nsending the friend request!",
        0.2,
        Colors.redAccent,
        Icons.error,
        Colors.black,
        const Duration(seconds: 4),
        context,
      );
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: _buildBody(),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildBody() {
    //ez a metódus felel az egész képernyő felépítéséért
    return FormBuilder(
      //a formBuilder használata azért szükséges hogy validálni tudjuk a kereső mezőt
      key: _formKey, //egy kulccsal tudjuk figyelni
      child: Column(
        children: [
          _buildCard(
            Icons.people_alt_rounded,
            Colors.white,
            Preferences.isHungarian ? "Barát jelölések" : "Friend requests",
            //trailingként átadott kód
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
                if (_friendRequestCount > 0)
                  //ha van barátjelölés jelenítsük meg a előre nyíl előtt
                  Positioned(
                    right: 30,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '$_friendRequestCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            () async {
              //kattintásra nyissa meg a barátjelölések képernyőt
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendRequests(),
                ),
              );
              //és töltse be a barátkérés számlálót
              _loadFriendRequestCount();
            },
          ),
          //barátok kezelése gomb
          _buildCard(
            Icons.emoji_people_rounded,
            Colors.white,
            Preferences.isHungarian ? "Barátok kezelése" : "Manage friends",
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
            () async {
              //kattintásra nyissa meg a barátkezelés képernyőt
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManageFriends(),
                ),
              );
            },
          ),
          _userSearchInputWidget(),
          const SizedBox(height: 10),
          Expanded(
            //expanded widgettel van megoldva a hogy 2:3 arányban jelenjen meg
            flex: 2,
            child: _searchResultsWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, Color iconColor, String title,
      Widget trailing, VoidCallback onTap) {
    return Card(
      //Card widget adja az alakot míg,
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: ListTile(
        //a ListTile widget adja a Card-ban lévő elrendezést
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _userSearchInputWidget() {
    //ez a metódus a keresésért felel
    return Container(
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
      child: FormBuilderTextField(
        key: (const Key("userName")), //a teszteléshez ez a kulcs szükséges
        name: "username",
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          //a regisztrációkor is érvényes követelmények alapján keresünk
          FormBuilderValidators.minLength(
            3,
            errorText: Preferences.isHungarian
                ? "A felhasználónév túl rövid! (min 3)"
                : "The username is too short! (min 3)",
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.maxLength(
            20,
            errorText: Preferences.isHungarian
                ? "A felhasználónév túl hosszú! (max 20)"
                : "The username is too long! (max 20)",
            checkNullOrEmpty: false,
          ),
        ]),
        focusNode: _userSearchFocusNode, //design változás fókuszkor
        controller: _userSearchController, //tartalom
        onChanged: (query) {
          //ha változik akkor csak a null eshetőséget vizsgáljuk itt
          if (query == null) {
            setState(() {
              _userSearchResults = [];
            });
          } else {
            //a többit itt ellenőrizzük
            _searchUsers(query);
          }
        },
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        decoration: _decorationForInput(),
      ),
    );
  }

  InputDecoration _decorationForInput() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      hintText: _isUserSearchFocused
          ? null
          : Preferences.isHungarian
              ? "Add meg a felhasználónevet!"
              : "Enter the username!",
      labelText: _isUserSearchFocused
          ? Preferences.isHungarian
              ? "Add meg a felhasználónevet!"
              : "Enter the username!"
          : null,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurpleAccent,
          width: 2.5,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2.5,
        ),
      ),
      suffixIcon: _userSearchController.text.isNotEmpty
          //tartalom törlő ikon
          ? IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                _userSearchController.clear();
                setState(() {
                  _userSearchResults = [];
                });
              },
            )
          : null,
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        letterSpacing: 1.0,
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
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        );
      } else if (profilePicture.startsWith("data:image/")) {
        profileImage = Image.memory(
          base64Decode(profilePicture.split(",")[1]),
          width: 60,
          height: 60,
          fit: BoxFit.fill,
        );
      } else {
        profileImage = CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[600],
          child: const Icon(
            Icons.person,
            size: 40,
            color: Colors.white,
          ),
        );
      }
    } else {
      profileImage = CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[600],
        child: const Icon(
          Icons.person,
          size: 40,
          color: Colors.white,
        ),
      );
    }

    return profileImage;
  }

  Widget _searchResultsWidget() {
    if (_userSearchResults.isEmpty) {
      //középre igazítás itt a ListView területén van, illetve nem lehet külön metódusba mert nem buildelődik újra
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

    //ha viszont van akkor:
    return ListView.builder(
      //az összes talált felhasználó adatait lebuildeljük mivel a lista hossza alapján megyünk
      itemCount: _userSearchResults.length,
      itemBuilder: (context, index) {
        //külön eltároljuk a listánk adatait
        final user = _userSearchResults[index];
        //id-re, profile_picture-re, és username-et tároló változókra
        final int friendId = user["id"];
        final String username = user["username"];
        final String? profilePicture = user["profile_picture"];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            //ismét vízszintes elrendezés ListTile-al
            leading: ClipOval(child: _buildProfilePicture(profilePicture)),
            title: AutoSizeText(
              //kiférjen minden eshetőséggel a felhasználónév
              maxLines: 1,
              username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            trailing: FutureBuilder(
              //itt viszont dinamikusan kell változtatnunk az értékeket
              future: _checkFriendStatus(friendId), //ez alapján
              builder: (context, snapshot) {
                //a future alapján visszaadott érték amit a snapshot-ból veszünk ki
                final status = snapshot.data.toString();

                //majd az értékek alapján megjelenítjük
                if (status == "already_friends") {
                  return Text(
                    Preferences.isHungarian ? "Barát" : "Friend",
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 14,
                    ),
                  );
                } else if (status == "pending_request") {
                  return Text(
                    Preferences.isHungarian ? "Függőben" : "Pending",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                    ),
                  );
                } else {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    onPressed: () => _sendFriendRequest(friendId),
                    child: Text(
                      Preferences.isHungarian ? "Jelölés" : "Add",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}
//People OSZTÁLY VÉGE -----------------------------------------------------------------------------
