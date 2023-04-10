import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownloader/models/playlist_informations.dart';
import 'package:ytdownloader/services/shared_preferences.dart';

import '../services/playlist.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({Key? key}) : super(key: key);

  static const routeName = "/playlists";

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistsScreen> {
  List<String> playlists = [];

  @override
  void initState() {
    super.initState();
    loadPlaylists();
  }

  Future<List<String>> loadPlaylists() async {
    List<String> savedPlaylists = await getSavedPlaylists();

    setState(() {
      playlists = savedPlaylists;
    });
    return savedPlaylists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: playlists.isEmpty
          ? const Center(
              child: Text("No playlists found"),
            )
          : ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return FutureBuilder<PlaylistInformations>(
                  future: getPlaylistInformations(playlists[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final playlist = snapshot.data!;
                      return ListTile(
                        leading: Image.network(playlist.thumbnail!),
                        title: Text(
                          playlist.playlistData!.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle:
                            Text("${playlist.playlistData!.videoCount} videos"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () {
                                Widget cancelButton = TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                                Widget downloadButton = TextButton(
                                  child: Text("Download"),
                                  onPressed: () {
                                    downloadPlaylistAudios(playlists[index]);
                                    Navigator.pop(context);
                                  },
                                );

                                AlertDialog alert = AlertDialog(
                                  title: Text("Warning"),
                                  content: Text(
                                      "Are you sure you want to download this playlist?"),
                                  actions: [
                                    cancelButton,
                                    downloadButton,
                                  ],
                                );

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                Widget cancelButton = TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                                Widget deleteButton = TextButton(
                                  child: Text("Delete"),
                                  onPressed: () {
                                    removePlaylist(index);
                                    Navigator.pop(context);
                                  },
                                );

                                AlertDialog alert = AlertDialog(
                                  title: Text("Warning"),
                                  content: Text(
                                      "Are you sure you want to delete this playlist?"),
                                  actions: [
                                    cancelButton,
                                    deleteButton,
                                  ],
                                );

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          downloadPlaylistAudios(playlists[index]);
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              },
            ),
    );
  }
}
