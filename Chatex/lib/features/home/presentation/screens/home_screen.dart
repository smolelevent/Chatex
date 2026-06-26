import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:chatex/features/chat/presentation/screens/load_chats.dart';
import 'package:chatex/features/chat/presentation/screens/start_chat.dart';
import 'package:chatex/core/presentation/widgets/sidebar.dart';
import 'package:chatex/core/presentation/widgets/bottom_nav_bar.dart';
import 'package:chatex/features/friends/presentation/people.dart';
import 'package:chatex/features/groups/presentation/screens/groups.dart';
import 'package:chatex/features/settings/presentation/settings.dart';
import 'package:chatex/features/groups/presentation/widgets/dummy_group.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/l10n/app_localizations.dart';

//ChatUI OSZTÁLY ELEJE ----------------------------------------------------------------------------
class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  late SidebarXController _sidebarController;
  int _selectedIndex = 0;
  final bool _widgetFromSidebar = false;

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    //meghívunk egy sidebarX kontrollert hogy számon tudjuk majd tartani melyik Dart-on vagyunk
    _sidebarController = SidebarXController(selectedIndex: 0, extended: true);
  }

  //ez a logika felelős a képernyő indexének megfelelő beállításáért
  void _setScreen(int index, {bool isSidebarPage = false}) {
    setState(() {
      _selectedIndex = index;
      if (isSidebarPage) {
        _sidebarController.selectIndex(index);
      } else if (index == 0) {
        _sidebarController.selectIndex(0);
      } else {
        _sidebarController.selectIndex(-1);
      }
    });
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //ez a widget figyeli a belépéskor beállított nyelvet és az alapján építi fel a widgeteket
    return ValueListenableBuilder<String>(
      valueListenable: Preferences.languageNotifier, //ez alapján
      builder: (context, value, child) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[850],
            appBar: _buildAppbar(),
            drawer: _buildSidebar(),
            body: _getScreen(),
            bottomNavigationBar: _buildBottomNavbar(),
          ),
        );
      },
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _getScreen() {
    //ez a logika felelős a képernyő megfelelő váltásáért
    switch (_selectedIndex) {
      case 0:
        return const LoadedChatData();
      case 1:
        return const People();
      case 2:
        return const Groups();
      case 3:
        return const Settings();
      default:
        return const LoadedChatData();
    }
  }

  PreferredSizeWidget _buildAppbar() {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: Colors.black,
      foregroundColor: Colors.deepPurpleAccent,
      shadowColor: Colors.deepPurpleAccent,
      elevation: 10,
      title: Text(
        _selectedIndex == 0
            ? "Chatex"
            : _selectedIndex == 1
                ? "Chatex"
                : _selectedIndex == 2
                    ? l10n.groups
                    : l10n.settings,
      ),
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
      actions: () {
        if (_selectedIndex == 0) {
          //index alapján határozzuk meg hogy az Appbar jobb oldalán milyen gomb jelenjen meg!
          return [
            IconButton(
              icon: const Icon(
                Icons.add_comment,
              ),
              color: Colors.deepPurpleAccent,
              tooltip: l10n.createNewChat,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StartChat(),
                  ),
                );
              },
            ),
          ];
        } else if (_selectedIndex == 2) {
          return [
            IconButton(
              icon: const Icon(
                Icons.groups_rounded,
              ),
              color: Colors.deepPurpleAccent,
              tooltip: l10n.createNewGroup,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DummyGroup(),
                  ),
                );
              },
            ),
          ];
        } else {
          return null;
        }
      }(),
    );
  }

  Widget _buildSidebar() {
    //meghívjuk a sidebar.dart-ot aminek az elemei a _setScreen metódus alapján működnek (részben)
    return ChatSidebar(
      onSelectPage: _setScreen,
      sidebarXController: _sidebarController,
    );
  }

  Widget _buildBottomNavbar() {
    //meghívjuk a bottom_nav_bar.dart-ot aminek az indexei össze vannak kapcsolva a sidebar elemeivel!
    return BottomNavbarForChat(
      selectedIndex: _widgetFromSidebar ? -1 : _selectedIndex,
      onItemTapped: (index) => _setScreen(index, isSidebarPage: false),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//ChatUI OSZTÁLY VÉGE -----------------------------------------------------------------------------
