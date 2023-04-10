import 'package:flutter/material.dart';
import 'package:ytdownloader/screens/download.dart';
import 'package:ytdownloader/screens/playlists.dart';
import 'package:ytdownloader/widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final tabs = [const DownloadScreen(), const PlaylistsScreen()];

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
          index: _currentIndex,
          indexHandler: (index) {
            setState(() {
              _currentIndex = index;
            });
          }),
      body: SafeArea(
        child: tabs[_currentIndex],
      ),
    );
  }
}
