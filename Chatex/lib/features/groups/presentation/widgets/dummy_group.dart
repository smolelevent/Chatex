import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DummyGroup extends StatelessWidget {
  const DummyGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(),
        backgroundColor: Colors.grey[850],
        body: const Center(
          child: AutoSizeText(
            textAlign: TextAlign.center,
            "Sajnos a csoportok funkció elkészítése nem sikerült a vizsgára... További információt a nehézségekről a vizsgán lévő bemutatónkból lesz hallható!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: const Text("fasz"),
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
}
