import 'package:flutter/material.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/features/settings/presentation/screens/language.dart';
import 'package:chatex/features/settings/presentation/screens/account.dart';
import 'package:chatex/l10n/app_localizations.dart';
import 'package:chatex/features/settings/presentation/widgets/settings_widgets.dart';

//Settings OSZTÁLY ELEJE --------------------------------------------------------------------------
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
//OSZTÁLYON BELÜLI VÁLTOZÓK ELEJE -----------------------------------------------------------------

  final TextEditingController _searchController = TextEditingController(); //szöveg kezelésére szolgál

  final FocusNode _searchFocusNode = FocusNode(); //fókuszra történő dizájn változtatás

  bool _isSearchFocused = false; //itt mentjük el a FocusNode-ot

  String _searchQuery = ""; //keresés

//OSZTÁLYON BELÜLI VÁLTOZÓK VÉGE ------------------------------------------------------------------

//HÁTTÉR FOLYAMATOK ELEJE -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<SettingCategory> getSettings() {
    final l10n = AppLocalizations.of(context)!;
    //ez a metódus felépíti a szerkezetét a beállításoknak, amit később kezelünk
    return [
      SettingCategory(
        //külön osztály a kategóriáknak
        title: l10n.general,
        items: [
          SettingItem(
            //és külön osztály a kategóriákban lévő elemeknek
            icon: Icons.language_rounded,
            color: Colors.teal,
            title: l10n.language,
            subtitle: Preferences.getPreferredLanguage(),
            onTap: () async {
              //ha megnyomjuk a nyelv választó menüt akkor eltároljuk egy változóba
              final selectedLanguage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSetting(),
                ),
              );

              if (selectedLanguage != null) {
                //majd ha visszatért és nem null akkor frissítjük a képernyőt (akár más a nyelv akár nem)
                setState(() {}); // csak az UI frissítése
              }
            },
          ),
        ],
      ),
      SettingCategory(
        title: l10n.account,
        items: [
          SettingItem(
            icon: Icons.person_rounded,
            color: Colors.blue,
            title: l10n.manageAccount,
            subtitle: "",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSetting(),
                ),
              );
            },
          ),
        ],
      ),
    ];
  }

//HÁTTÉR FOLYAMATOK VÉGE --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: _buildSearchFilteredBody(),
    );
  }

//DIZÁJN ELEMEK ELEJE -----------------------------------------------------------------------------

  Widget _buildSearchFilteredBody() {
    final l10n = AppLocalizations.of(context)!;
    final List<SettingCategory> settings = getSettings();

    // Szűrési logika
    final filteredSettings = settings
        .map((category) {
          final filteredItems = category.items.where((item) => item.title.toLowerCase().startsWith(_searchQuery.toLowerCase())).toList();
          return filteredItems.isNotEmpty ? SettingCategory(title: category.title, items: filteredItems) : null;
        })
        .whereType<SettingCategory>()
        .toList();

    return Column(
      children: [
        SettingsSearchBar(
          controller: _searchController,
          focusNode: _searchFocusNode,
          isFocused: _isSearchFocused,
          onChanged: (query) {
            setState(() {
              _searchQuery = query ?? "";
            });
          },
          onClear: () {
            _searchController.clear();
            setState(() {
              _searchQuery = '';
            });
          },
        ),
        // A lista
        Expanded(
          //kitöltse a rendelkezésre álló teret a beállítás ameddig engedi a padding
          child: filteredSettings.isEmpty
              ? Center(
                  child: Text(
                    l10n.noResultsFound,
                    style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: filteredSettings.expand((category) {
                    return [
                      // A kiszervezett kategóriacím hívása
                      SettingCategoryTitle(title: category.title),
                      // A kiszervezett kártyák hívása
                      ...category.items.map((item) => SettingCard(
                            icon: item.icon,
                            iconColor: item.color,
                            title: item.title,
                            subtitle: item.subtitle,
                            onTap: item.onTap,
                          )),
                      // A kiszervezett elválasztó hívása
                      if (category != filteredSettings.last) const SettingDivider(),
                    ];
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------

//Settings OSZTÁLY VÉGE ---------------------------------------------------------------------------
