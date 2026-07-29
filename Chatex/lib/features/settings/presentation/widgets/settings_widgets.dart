import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:chatex/l10n/app_localizations.dart';

class SettingCategory {
  SettingCategory({required this.title, required this.items});
  final String title;
  final List<SettingItem> items;
}

class SettingItem {
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

class SettingsSearchBar extends StatelessWidget {
  const SettingsSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final Function(String?) onChanged; // Ezzel küldjük vissza a szöveget a szülőnek
  final VoidCallback onClear; // Ezzel szólunk a szülőnek, hogy töröltek

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: 30, right: 10, left: 10, bottom: 20),
      child: FormBuilderTextField(
        key: const Key("settingsSearch"),
        name: "settings_search",
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        style: const TextStyle(color: Colors.white, fontSize: 17.0),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[800],
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: isFocused ? null : l10n.searchSettings,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
          labelText: isFocused ? l10n.searchSettings : null,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 17.0),
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 28),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: Colors.white, size: 30),
                  onPressed: onClear,
                )
              : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white70, width: 2.5),
          ),
        ),
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
        subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(color: Colors.grey[400], letterSpacing: 1)) : null,
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class SettingCategoryTitle extends StatelessWidget {
  const SettingCategoryTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }
}

class SettingDivider extends StatelessWidget {
  const SettingDivider({super.key});

  @override
  Widget build(BuildContext context) {
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
}
