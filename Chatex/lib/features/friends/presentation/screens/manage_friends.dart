import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:chatex/l10n/app_localizations.dart';
import 'package:chatex/features/friends/data/friend_service.dart';

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
    final service = FriendService();

    try {
      final friendsList = await service.fetchFriends(Preferences.getUserId()!);
      if (mounted) {
        setState(() {
          _friends = friendsList;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ToastMessages.showToastMessages(
          l10n.connectionErrorLoadingFriends,
          0.2,
          Colors.redAccent,
          Icons.error,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
        setState(() => _isLoading = false);
      }
      log("Kapcsolati hiba a barátok lekérésénél! ${e.toString()}");
    }
  }

  Future<void> _removeFriend(int friendId) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final service = FriendService();

    try {
      await service.removeFriend(Preferences.getUserId()!, friendId);
      if (mounted) {
        setState(() => _friends.removeWhere((f) => f["id"] == friendId));
        //TODO: errorWhileDeletingFriend nincs itt
        ToastMessages.showToastMessages(
          l10n.friendRemoved,
          0.2,
          Colors.green,
          Icons.check,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
    } catch (e) {
      if (mounted) {
        ToastMessages.showToastMessages(
          l10n.connectionErrorRemovingFriend,
          0.2,
          Colors.redAccent,
          Icons.error_rounded,
          Colors.black,
          const Duration(seconds: 3),
          context,
        );
      }
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
        body: _isLoading //ha igaz egy töltő kört jelenítünk meg, különben a barátokat
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
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(
        l10n.manageFriends,
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

  // Widget _buildProfilePicture(String? profilePicture) {
  //   //base64 alapján
  //   Widget profileImage;
  //
  //   if (profilePicture != null && profilePicture.isNotEmpty) {
  //     if (profilePicture.startsWith("data:image/svg+xml;base64,")) {
  //       final svgString = utf8.decode(base64Decode(profilePicture.split(",")[1]));
  //       profileImage = SvgPicture.string(
  //         svgString,
  //         width: 50,
  //         height: 50,
  //         fit: BoxFit.fill,
  //       );
  //     } else if (profilePicture.startsWith("data:image/")) {
  //       profileImage = Image.memory(
  //         base64Decode(profilePicture.split(",")[1]),
  //         width: 50,
  //         height: 50,
  //         fit: BoxFit.fill,
  //       );
  //     } else {
  //       profileImage = CircleAvatar(
  //         radius: 25,
  //         backgroundColor: Colors.grey[600],
  //         child: const Icon(
  //           Icons.person,
  //           size: 35,
  //           color: Colors.white,
  //         ),
  //       );
  //     }
  //   } else {
  //     profileImage = CircleAvatar(
  //       radius: 25,
  //       backgroundColor: Colors.grey[600],
  //       child: const Icon(
  //         Icons.person,
  //         size: 35,
  //         color: Colors.white,
  //       ),
  //     );
  //   }
  //
  //   return profileImage;
  // }

  // --- ÚJ NETWORK IMAGE PROFILKÉP METÓDUS (Base64 kuka!) ---
  Widget _buildProfilePicture(String? profilePicture) {
    if (profilePicture != null && profilePicture.startsWith('http')) {
      return CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(profilePicture),
        backgroundColor: Colors.transparent,
      );
    } else {
      // Visszaadjuk a te eredeti alapértelmezett ikonodat
      return CircleAvatar(
        radius: 25,
        backgroundColor: Colors.grey[600],
        child: const Icon(
          Icons.person,
          size: 35,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildManageFriendsList() {
    final l10n = AppLocalizations.of(context)!;
    //ez a metódus a people.dart logikáját és a friend_request.dart dizájnját követve megjeleníti a barátokat a _friends változó szerint
    if (_friends.isEmpty) {
      return Center(
        child: Text(
          l10n.currentlyNoFriends,
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
              l10n.currentFriends,
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
                    tooltip: l10n.remove,
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          elevation: 10,
          shadowColor: Colors.deepPurpleAccent,
          title: Text(
            l10n.removeFriend,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Text(
            l10n.areYouSureRemoveFriend,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                l10n.cancel,
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
                l10n.remove,
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
