import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: Colors.grey[850],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.deepPurpleAccent,
        elevation: 10,
        shadowColor: Colors.deepPurpleAccent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),

      // Az elsődleges színek (Pl. gombokhoz, ikonokhoz)
      colorScheme: const ColorScheme.dark(
        primary: Colors.deepPurpleAccent,
        secondary: Colors.deepPurpleAccent,
        surface: Colors.black45, // Kártyák, Tile-ok színe
      ),

      // Kártyák (Card) alapértelmezett dizájnja
      cardTheme: CardThemeData(
        color: Colors.black45,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
