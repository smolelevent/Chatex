import 'package:chatex/features/auth/presentation/screens/login_screen.dart';
import 'package:chatex/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/core/utils/toast_message.dart';
import 'package:chatex/features/auth/data/auth.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:async';

//ChatSidebar OSZTÁLY ELEJE -----------------------------------------------------------------------
class ChatSidebar extends StatefulWidget {
  const ChatSidebar({
    super.key,
    required this.onSelectPage,
    required this.sidebarXController,
  });

  final SidebarXController
      sidebarXController; //a home_screen-ból átvett kontroller amivel megtudjuk hogy melyik index-en álunk (bottomNavBar egyezésért)
  final Function(int, {bool isSidebarPage})
      onSelectPage; //átadjuk hogy melyik képernyőt akarjuk kiválasztani, illetve egy bool-al azt hogy a sidebarhoz tartozik vagy sem

  @override
  State<ChatSidebar> createState() => _ChatSidebarState();
}

class _ChatSidebarState extends State<ChatSidebar> {
  //elmentjük itt a státuszt hogy egyből tudjuk frissíteni ne keljen rebuild
  String? _selectedStatus;

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _selectedStatus = Preferences.getStatus();
  }

  Future<void> _updateStatus(String? newStatus) async {
    //ez a metódus frissíti az adatbázisban és lokálisan is a státuszt
    // try {
    //   final response = await http.post(
    //     Uri.parse("http://10.0.2.2/ChatexProject/chatex_phps/auth/update_status.php"),
    //     headers: {"Content-Type": "application/json"},
    //     body: jsonEncode({
    //       "user_id": Preferences.getUserId(), //melyik felhasználó státuszát
    //       "status": newStatus, //milyen státuszra
    //     }),
    //   );
    //
    //   final responseData = jsonDecode(response.body);
    //   if (responseData["message"] == "Státusz frissítve!" && newStatus != null) {
    //     await Preferences.setStatus(newStatus); //lokálisan is beállítjuk
    //     ToastMessages.showToastMessages(
    //       Preferences.isHungarian ? "Sikeres változtatás!" : "Successful change!",
    //       0.3,
    //       Colors.green,
    //       Icons.check_rounded,
    //       Colors.black,
    //       const Duration(seconds: 2),
    //       context,
    //       center: false,
    //       rightPercentage: 0.3,
    //       leftPercentage: 0,
    //     );
    //   } else {
    //     ToastMessages.showToastMessages(
    //       Preferences.isHungarian ? "A változtatás nem sikerült!" : "The change didn't happened!",
    //       0.3,
    //       Colors.orange,
    //       Icons.warning_rounded,
    //       Colors.black,
    //       const Duration(seconds: 2),
    //       context,
    //       center: true,
    //       rightPercentage: 0,
    //       leftPercentage: 0,
    //     );
    //   }
    // } catch (e) {
    //   ToastMessages.showToastMessages(
    //     Preferences.isHungarian
    //         ? "Kapcsolati hiba a\nstátusz változtatásánál!"
    //         : "Connection error while\nchanging status!",
    //     0.3,
    //     Colors.redAccent,
    //     Icons.error_rounded,
    //     Colors.black,
    //     const Duration(seconds: 2),
    //     context,
    //     center: false,
    //     rightPercentage: 0.3,
    //     leftPercentage: 0,
    //   );
    //   log("Kapcsolati hiba a státusz változtatásánál! ${e.toString()}");
    // }
  }

  AlertDialog _buildLogOutWidget() {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Colors.grey[850],
      elevation: 10,
      shadowColor: Colors.deepPurpleAccent,
      title: Text(
        l10n.logout,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      content: Text(
        l10n.areYouSureLogout,
        style: const TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 1),
      ),
      actions: [
        TextButton(
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: Colors.white, letterSpacing: 1),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: Text(
            l10n.yes,
            style: const TextStyle(color: Colors.redAccent, letterSpacing: 1),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _onLogoutButtonPressed() async {
    final l10n = AppLocalizations.of(context)!;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return _buildLogOutWidget();
      },
    );

    if (shouldLogout == true) {
      final authService = AuthService();

      try {
        await authService.logOut();

        if (!context.mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginUI()),
          (route) => false,
        );
      } catch (e) {
        if (mounted) {
          String errorMessage = l10n.error;
          if (e.toString().contains('logout_error')) {
            errorMessage = l10n.connectionErrorLogout;
          }

          ToastMessages.showToastMessages(errorMessage, 0.2, Colors.redAccent, Icons.error, Colors.black, const Duration(seconds: 3), context);
        }
      }
    }
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return _buildSidebar();
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  ValueListenableBuilder<String> _buildSidebar() {
    final l10n = AppLocalizations.of(context)!;
    return ValueListenableBuilder<String>(
      //figyeli hogy milyen nyelvre van állítva az alkalmazás és úgy jeleníti meg a dolgokat
      valueListenable: Preferences.languageNotifier,
      builder: (context, locale, child) {
        return SidebarX(
          showToggleButton: false,
          controller: widget.sidebarXController,
          headerBuilder: (context, extended) {
            //itt a profilkép, név, és a státusz menü épül fel
            return _buildHeader();
          },
          headerDivider: _buildHeaderDivider(),
          items: [
            //a tényleges tartalma a sidebarnak, ahova lehet navigálni
            _buildSidebarOption(locale, l10n.chats, Icons.chat_rounded, Colors.deepPurpleAccent, () {
              widget.sidebarXController.selectIndex(0);
              widget.onSelectPage(0, isSidebarPage: false);
              Navigator.pop(context);
            }),

            _buildSidebarOption(locale, l10n.groups, Icons.groups_rounded, Colors.lightBlue, () {
              widget.sidebarXController.selectIndex(2);
              widget.onSelectPage(2, isSidebarPage: true);
              Navigator.pop(context);
            }),
          ],
          footerItems: [
            _buildSidebarOption(locale, l10n.settings, Icons.settings_rounded, Colors.teal, () {
              widget.sidebarXController.selectIndex(3);
              widget.onSelectPage(3, isSidebarPage: true);
              Navigator.pop(context);
            }),
            _buildSidebarOption(
              locale,
              l10n.logout,
              Icons.logout_rounded,
              Colors.redAccent,
              _onLogoutButtonPressed,
            ),
          ],
          theme: _sidebarXTheme(),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        _buildProfileImage(),
        const SizedBox(height: 20),
        Text(
          Preferences.getUsername(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            wordSpacing: 2,
          ),
        ),
        _buildDropdownMenu(),
      ],
    );
  }

  Widget _defaultAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey[600],
      child: const Icon(
        Icons.person,
        size: 80,
        color: Colors.white,
      ),
    );
  }

  //TODO: elcsúszik a profilkép
  Widget _buildProfileImage() {
    final String? image = Preferences.getProfilePicture();
    log("MIT AD ÁT PROFILKÉPNEK${Preferences.getProfilePicture()}");

    if (image == null || image.isEmpty) {
      return _defaultAvatar();
    }

    Widget imageWidget;

    if (image.startsWith('http')) {
      imageWidget = Image.network(
        image,
        width: 120,
        height: 120,
        fit: BoxFit.fill,
        // Hiba esetén alap ikon
        errorBuilder: (context, error, stackTrace) => _defaultAvatar(),
      );
    } else {
      //errort kapunk ha túl gyorsan töltjük be a sidebar-t ezért kell a postFrameCallback
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ToastMessages.showToastMessages(
        //   Preferences.isHungarian ? "Ismeretlen MIME-típus a profilképnél!" : "An unknown MIME type has been detected!",
        //   0.2,
        //   Colors.redAccent,
        //   Icons.error,
        //   Colors.black,
        //   const Duration(seconds: 2),
        //   context,
        //   center: true,
        //   rightPercentage: 0,
        //   leftPercentage: 0,
        // );
      });
      imageWidget = _defaultAvatar();
    }

    //a profilképhez hozzáadjuk a státusz karikát:
    return SizedBox(
      //a profilkép méretével megegyező SizedBox-ot felveszünk ez engedi majd a Stack widgetet
      width: 120,
      height: 120,

      child: Stack(
        //ha kilóg akkor sehogy ne vágja le amikor ráépítünk a profilképre
        clipBehavior: Clip.none,
        children: [
          Positioned(
            //profilkép
            top: 0,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[800],
              child: ClipOval(
                child: imageWidget,
              ),
            ),
          ),
          Positioned(
            //manuálisan elcsúsztatva a státusz karika
            bottom: -1,
            right: 15,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: (_selectedStatus ?? "offline").toLowerCase() == "online" ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderDivider() {
    return Padding(
      //elválasztó vonal
      padding: const EdgeInsets.only(bottom: 15),
      child: Center(
        child: Container(
          height: 5,
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  SidebarXItem _buildSidebarOption(String locale, String text, IconData icon, Color iconColor, FutureOr<void> Function()? onTap) {
    return SidebarXItem(
      label: text,
      iconBuilder: (context, isSelected) {
        return Icon(
          icon,
          color: iconColor,
          size: 30,
        );
      },
      onTap: onTap,
    );
  }

  DropdownMenuEntry<String> _buildDropdownMenuEntry(String value, String label) {
    //jelenleg 2
    return DropdownMenuEntry(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
      value: value,
      label: label,
    );
  }

  Widget _buildDropdownMenu() {
    final l10n = AppLocalizations.of(context)!;
    //státusz válosztó menüért
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: DropdownMenu<String>(
        initialSelection: Preferences.getStatus(), //a betöltött státusz legyen kiválasztva
        label: Text(
          l10n.status,
        ),
        onSelected: (newStatus) async {
          //csak akkor engedünk új státuszt ha nem ugyanaz mint a régi (pl.: a felhasználó ugyanarra nyomna)
          if (newStatus != Preferences.getStatus()) {
            setState(() {
              _selectedStatus = newStatus;
            });
          }

          //az adatbázisban is frissítjük
          _updateStatus(newStatus);
        },
        dropdownMenuEntries: [
          //a választható lehetőségek
          _buildDropdownMenuEntry("online", "🟢 Online"),
          _buildDropdownMenuEntry("offline", "⚫ Offline"),
        ],

        trailingIcon: const Icon(
          //normál állapotban lévő menü végén megjelenő ikon
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        selectedTrailingIcon: const Icon(
          //ha megnyitjuk a menüt hogy jelenjen meg az ikon a végén
          Icons.arrow_drop_up,
          color: Colors.deepPurpleAccent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          //a beviteli mező kinézete
          labelStyle: TextStyle(
            color: Colors.grey[500],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            letterSpacing: 1,
          ),
          enabledBorder: const OutlineInputBorder(
            //állandó border
            borderSide: BorderSide(
              color: Colors.deepPurpleAccent,
              width: 2.5,
            ),
          ),
        ),
        textStyle: const TextStyle(
          //a megjelenített szöveg stílusa (normál állapotban)
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
        menuStyle: MenuStyle(
          //a megnyitáskor hogy nézzen ki a választó menü
          backgroundColor: WidgetStatePropertyAll(Colors.grey[900]),
          shadowColor: const WidgetStatePropertyAll(Colors.deepPurpleAccent),
          elevation: const WidgetStatePropertyAll(10),
        ),
      ),
    );
  }

  SidebarXTheme _sidebarXTheme() {
    return SidebarXTheme(
      width: 250,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ),
      selectedTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 1,
      ),
      itemTextPadding: const EdgeInsets.symmetric(horizontal: 20),
      selectedItemTextPadding: const EdgeInsets.symmetric(horizontal: 20),
      selectedItemDecoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//ChatSidebar OSZTÁLY VÉGE ------------------------------------------------------------------------
