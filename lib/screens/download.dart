import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownloader/models/playlist_informations.dart';
import 'package:ytdownloader/services/playlist.dart';

import '../services/shared_preferences.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  static const routeName = "/download";

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  Widget build(BuildContext context) {
    var playlistLink = TextEditingController();
    PlaylistInformations playlistInfos;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: playlistLink,
                    decoration: const InputDecoration(
                      focusColor: Colors.redAccent,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32))),
                      hintText: 'Paste youtube playlist link here',
                      prefixIcon: Icon(Icons.link, color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    icon: const Icon(
                      Icons.paste,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Clipboard.getData("text/plain").then((value) =>
                          playlistLink.text = (value?.text) as String);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 125,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      var playlistInformations =
                          getPlaylistInformations(playlistLink.text)
                              .then((value) {
                        if (value.playlistData == null || value == null) {
                          return;
                        }
                        setState(() {
                          playlistInfos = value;
                        });
                        showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) => SizedBox(
                                height: 600,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Playlist found",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(height: 20),
                                      Image.network(
                                        value.thumbnail!,
                                        width: 800,
                                        height: 160,
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Title : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(value.playlistData!.title),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Author : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(value.playlistData!.author),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Number of videos : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(value.playlistData!.videoCount
                                              .toString()),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            height: 46,
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                if (await Permission.storage
                                                    .request()
                                                    .isGranted) {
                                                  downloadPlaylistAudios(
                                                      playlistLink.text);
                                                }
                                              },
                                              child: Text("Download",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Colors.black),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          32)))),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          SizedBox(
                                            width: 125,
                                            height: 46,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                savePlaylist(playlistLink.text);
                                              },
                                              child: const Text("Add"),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          32)))),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32)))),
                    child: const Text("Get Playlist"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
