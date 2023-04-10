import 'package:shared_preferences/shared_preferences.dart';

void savePlaylist(String playlistLink) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? playlists = prefs.getStringList('playlists');
  playlists ??= [];
  playlists.add(playlistLink);
  await prefs.setStringList('playlists', playlists);
}

void removePlaylist(index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? playlists = prefs.getStringList('playlists');
  playlists ??= [];
  playlists.removeAt(index);
  await prefs.setStringList('playlists', playlists);
}

Future<List<String>> getSavedPlaylists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> playlists = prefs.getStringList('playlists') ?? [];
  return playlists;
}
