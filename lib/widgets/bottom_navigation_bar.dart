import 'package:flutter/material.dart';
import 'package:ytdownloader/home.dart';
import 'package:ytdownloader/screens/playlists.dart';

import '../screens/download.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar(
      {super.key,
      required this.index,
      required Function(int) this.indexHandler});

  final int index;
  final Function(int) indexHandler;
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 0.0,
      unselectedFontSize: 0.0,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.redAccent,
      items: [
        BottomNavigationBarItem(
            icon: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  widget.indexHandler(0);
                },
                icon: const Icon(Icons.home)),
            label: "Home"),
        BottomNavigationBarItem(
            icon: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  widget.indexHandler(1);
                },
                icon: const Icon(Icons.playlist_play)),
            label: "Playlists"),
      ],
      onTap: (index) {
        print("happened");
        widget.indexHandler(index);
      },
    );
  }
}
