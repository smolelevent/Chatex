import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/features/friends/presentation/friend_requests.dart';
import 'package:chatex/features/friends/presentation/manage_friends.dart';
import 'package:chatex/core/constants/validation_constants.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'package:chatex/core/constants/api_constants.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

//People OSZTÁLY ELEJE ----------------------------------------------------------------------------
class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  final TextEditingController _userSearchController = TextEditingController();

  final FocusNode _userSearchFocusNode = FocusNode();

  bool _isUserSearchFocused = false;

  final _formKey = GlobalKey<FormBuilderState>();

  List<dynamic> _userSearchResults = [];

  Timer? _timer;

  int _friendRequestCount = 0;

  //id-k alapján eltároljuk hogy pending a kérés vagy accepted
  final Map<int, String> _friendStatusMap = {};

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _userSearchFocusNode.addListener(() {
      setState(() {
        _isUserSearchFocused = _userSearchFocusNode.hasFocus;
      });
    });
    _loadFriendRequestCount();
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    _userSearchFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadFriendRequestCount() async {
    try {
      // Supabase Count lekérdezés: Villámgyors és nem tölti le magukat az adatokat, csak a számot.
      final countResponse = await supabase
          .from('friend_requests')
          .select('*')
          .eq('receiver_id', Preferences.getUserId()!)
          .eq('status', 'pending')
          .count(CountOption.exact);

      setState(() {
        _friendRequestCount = countResponse.count;
      });
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastMessages.showToastMessages(
          l10n.connectionErrorFriendRequests,
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
      log("Kapcsolati hiba a barátkérések számának lekérésében! ${e.toString()}");
    }
  }

  void _searchUsers(String query) {
    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty || query.length < usernameMinLength || query.length > usernameMaxLength) {
        setState(() => _userSearchResults = []);
        return;
      }

      try {
        final responseData = await supabase
            .from('users')
            .select('id, username, profile_picture')
            .ilike('username', '%$query%')
            .neq('id', Preferences.getUserId()!);

        setState(() {
          _userSearchResults = responseData;
        });
      } catch (e) {
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ToastMessages.showToastMessages(
            l10n.connectionErrorGettingUsers,
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 2),
            context,
          );
        }
        log("Kapcsolati hiba a felhasználók lekérésekor! ${e.toString()}");
        setState(() => _userSearchResults = []);
      }
    });
  }

  Future<String> _checkFriendStatus(int friendId) async {
    if (_friendStatusMap.containsKey(friendId)) return _friendStatusMap[friendId]!;

    final myId = Preferences.getUserId()!;
    try {
      // 1. Megnézzük, barátok-e már
      final friendRes = await supabase
          .from('friends')
          .select('id')
          .or('and(user_id.eq.$myId,friend_id.eq.$friendId),and(user_id.eq.$friendId,friend_id.eq.$myId)');

      if (friendRes.isNotEmpty) {
        _friendStatusMap[friendId] = "already_friends";
        return "already_friends";
      }

      // 2. Megnézzük, van-e függőben lévő kérés
      final reqRes = await supabase
          .from('friend_requests')
          .select('id')
          .or('and(sender_id.eq.$myId,receiver_id.eq.$friendId),and(sender_id.eq.$friendId,receiver_id.eq.$myId)');

      if (reqRes.isNotEmpty) {
        _friendStatusMap[friendId] = "pending_request";
        return "pending_request";
      }

      // 3. Ha egyik sem, akkor küldhet
      _friendStatusMap[friendId] = "can_send";
      return "can_send";
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastMessages.showToastMessages(
          l10n.connectionErrorFriendRequestStatus,
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 2),
          context,
        );
      }
      log("Hiba a státusz lekérésénél: ${e.toString()}");
      //TODO: lehet nem kell
      _friendStatusMap[friendId] = "error";
      return "error";
    }
  }

  Future<void> _sendFriendRequest(int friendId) async {
    try {
      // Sima adatbázis beszúrás (Insert)
      await supabase
          .from('friend_requests')
          .insert({"sender_id": Preferences.getUserId(), "receiver_id": friendId, "status": "pending"});

      setState(() {
        _friendStatusMap[friendId] = "pending_request";
      });

      //TODO: lehet nem kell, a lefrissítést a keresés meghívásával kényszerítjük
      _searchUsers(_userSearchController.text);

      if (context.mounted) {
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ToastMessages.showToastMessages(
            l10n.friendRequestSent,
            0.2,
            Colors.green,
            Icons.check,
            Colors.black,
            const Duration(seconds: 4),
            context,
          );
        }
        //TODO: lehet nem kell else ág
      } else {
        if (context.mounted) {
          final l10n = AppLocalizations.of(context)!;
          ToastMessages.showToastMessages(
            l10n.errorOccurredFriendRequest,
            0.2,
            Colors.redAccent,
            Icons.error,
            Colors.black,
            const Duration(seconds: 4),
            context,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastMessages.showToastMessages(
          l10n.connectionErrorSendingFriendRequest,
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 4),
          context,
        );
      }
      log("Kapcsolati hiba a barátküldés közben! ${e.toString()}");
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
    final l10n = AppLocalizations.of(context)!;
    //ez a metódus felel az egész képernyő felépítéséért
    return FormBuilder(
      //a formBuilder használata azért szükséges hogy validálni tudjuk a kereső mezőt
      key: _formKey, //egy kulccsal tudjuk figyelni
      child: Column(
        children: [
          _buildCard(
            Icons.people_alt_rounded,
            Colors.white,
            l10n.friendRequests,
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
            l10n.manageFriends,
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

  Widget _buildCard(IconData icon, Color iconColor, String title, Widget trailing, VoidCallback onTap) {
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
    final l10n = AppLocalizations.of(context)!;
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
            usernameMinLength,
            errorText: l10n.usernameTooShort,
            checkNullOrEmpty: false,
          ),
          FormBuilderValidators.maxLength(
            usernameMaxLength,
            errorText: l10n.usernameTooLong,
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
    final l10n = AppLocalizations.of(context)!;
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      hintText: _isUserSearchFocused ? null : l10n.enterUsername,
      labelText: _isUserSearchFocused ? l10n.enterUsername : null,
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
        final svgString = utf8.decode(base64Decode(profilePicture.split(",")[1]));
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
    final l10n = AppLocalizations.of(context)!;
    if (_userSearchResults.isEmpty) {
      //középre igazítás itt a ListView területén van, illetve nem lehet külön metódusba mert nem buildelődik újra
      return Center(
        child: Text(
          l10n.noResultsFound,
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
                    l10n.friend,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 14,
                    ),
                  );
                } else if (status == "pending_request") {
                  return Text(
                    l10n.pending,
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
                      l10n.add,
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
