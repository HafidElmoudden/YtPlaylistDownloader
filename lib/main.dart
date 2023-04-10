import 'package:flutter/material.dart';
import 'package:ytdownloader/home.dart';
import 'package:ytdownloader/screens/download.dart';
import 'package:ytdownloader/screens/playlists.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        DownloadScreen.routeName: (context) => const DownloadScreen(),
        PlaylistsScreen.routeName: (context) => const PlaylistsScreen(),
      },
    );
  }
}