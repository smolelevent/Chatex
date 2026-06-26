import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/core/local_storage/preferences.dart';
import 'package:chatex/features/settings/presentation/language.dart';
import 'package:chatex/features/settings/presentation/account.dart';
import 'package:chatex/l10n/app_localizations.dart';

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
        //itt lesznek a fiókkal kapcsolatos beállítások (a jövőben bővülni fog!)
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

  Widget _buildSearchField() {
    //ez a metódus építi fel a keresési mezőt
    return Container(
      margin: const EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 20),
      child: FormBuilderTextField(
        //formBuilder csomag használatával
        key: const Key("settingsSearch"),
        //ezek az értékek (name, key) a teszteléshez kellenek
        name: "settings_search",
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: (query) {
          //a keresési szöveget elmentjük a _searchQuery-be
          setState(() {
            _searchQuery = query ?? "";
          });
        },
        keyboardType: TextInputType.text,
        style: const TextStyle(
          //a beírt szöveg stílusa
          color: Colors.white,
          fontSize: 17.0,
        ),
        decoration: _searchFieldInputDecoration(),
      ),
    );
  }

  InputDecoration _searchFieldInputDecoration() {
    final l10n = AppLocalizations.of(context)!;
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[800],
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      hintText: _isSearchFocused ? null : l10n.searchSettings,
      hintStyle: TextStyle(
        //input helyén megjelenő szöveg
        color: Colors.grey[400],
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 17.0,
      ),
      labelText: _isSearchFocused ? l10n.searchSettings : null,
      labelStyle: const TextStyle(
        //íráskor megjelenő szöveg
        color: Colors.white,
        fontSize: 17.0,
      ),
      prefixIcon: const Icon(
        Icons.search,
        color: Colors.white,
        size: 28,
      ),
      suffixIcon: _searchController.text.isNotEmpty
          //tartalmat törlő gomb
          ? IconButton(
              icon: const Icon(
                Icons.clear_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            )
          : null,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.deepPurpleAccent,
          width: 2.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.white70,
          width: 2.5,
        ),
      ),
    );
  }

  Widget _buildSearchFilteredBody() {
    final l10n = AppLocalizations.of(context)!;
    final List<SettingCategory> settings = getSettings(); //eltároltuk egy List-be az összes beállítást

    final filteredSettings = settings
        //a kereséshez szükséges szűrés, itt kategóriákként kezeli még
        .map((category) {
          //iit pedig már egyéni beállításokként
          final filteredItems = category.items
              .where(
                (item) => item.title.toLowerCase().startsWith(
                      _searchQuery.toLowerCase(), //maga a beállítás szövege megegyezik a keresett szöveggel
                    ),
              )
              .toList(); //és listába adjuk vissza
          return filteredItems.isNotEmpty
              //ha van találat akkor térjen vissza a kategóriával és a beállítás(ok)-al
              ? SettingCategory(title: category.title, items: filteredItems)
              : null;
        })
        .whereType<SettingCategory>()
        .toList();

    return Column(
      children: [
        _buildSearchField(),
        Expanded(
          //kitöltse a rendelkezésre álló teret a beállítás ameddig engedi a padding
          child: filteredSettings.isEmpty
              ? Center(
                  child: Text(
                    l10n.noResultsFound,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView(
                  //legyen kisebb mint a keresés
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: filteredSettings.expand((category) {
                    //szűrő alapján felépíti a kategóriát és annak elemeit is
                    return [
                      _buildCategoryTitle(category.title),
                      ...category.items.map((item) => _buildSettingCard(
                            item.icon,
                            item.color,
                            item.title,
                            item.subtitle,
                            item.onTap,
                          )),
                      //ha az utolsó abban a kategóriában akkor egy elválasztó vonalat tesz
                      if (category != filteredSettings.last) _buildDivider(),
                    ];
                  }).toList(), //fontos hogy mindig listaként, mert a beállításokat is egy listában kezeljük
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryTitle(String title) {
    //ez a metódus felel a kategória megjelenítéséért
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingCard(IconData icon, Color iconColor, String title, String subtitle, VoidCallback onTap) {
    //ez a metódus építi fel maga a beállítás kártyát a megadott adatok alapján
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            //lesz olyan eset ahol nem lesz egyértelmű subtitle ezért kell ez a szerkezet
            ? Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[400],
                  letterSpacing: 1,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    //ez a widget felépít egy elválasztót a kategóriák között
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20),
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

//DIZÁJN ELEMEK VÉGE ------------------------------------------------------------------------------
}

//Settings OSZTÁLY VÉGE ---------------------------------------------------------------------------

//SettingCategory OSZTÁLY ELEJE -------------------------------------------------------------------
class SettingCategory {
  //a listánkban ezzel az osztállyal tároljuk el a beállítások kategóriáit
  SettingCategory({
    required this.title,
    required this.items,
  });

  final String title;
  final List<SettingItem> items;
}

//SettingCategory OSZTÁLY VÉGE --------------------------------------------------------------------

//SettingItem OSZTÁLY ELEJE -----------------------------------------------------------------------
class SettingItem {
  //a listánkban ezzel az osztállyal tároljuk el a beállításokat
  SettingItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
}

//SettingItem OSZTÁLY VÉGE ------------------------------------------------------------------------
