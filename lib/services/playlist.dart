import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ytdownloader/models/playlist_informations.dart';

Future<Playlist?> getPlaylistData(String playlistLink) async {
  if (playlistLink.isNotEmpty) {
    var yt = YoutubeExplode();
    var playlist = await yt.playlists.get(playlistLink);

    return playlist;
  }

  return null;
}

Future<String?> getPlaylistThumbnail(String? playlistId) async {
  if (playlistId == null) {
    return "";
  }

  if (playlistId.isNotEmpty) {
    var yt = YoutubeExplode();
    String thumbnail = "";
    await for (var video in yt.playlists.getVideos(playlistId)) {
      thumbnail = video.thumbnails.highResUrl;
      break;
    }
    return thumbnail;
  }
  return "";
}

Future<PlaylistInformations> getPlaylistInformations(
    String playlistLink) async {
  var playlistData = await getPlaylistData(playlistLink);
  var playlistThumbnail = await getPlaylistThumbnail(playlistData?.id.value);
  PlaylistInformations playlist =
      PlaylistInformations(playlistData, playlistThumbnail);

  return playlist;
}

Future<void> downloadPlaylistAudios(String playlistId) async {
  print("Downloading the playlist $playlistId");
  final yt = YoutubeExplode();
  final playlist = await yt.playlists.get(playlistId);
  //Some stuff aren't allowed on the file names, so i had to clean it first.
  final playlistName = playlist.title.replaceAll(RegExp(r'[^\w\s]+'), '');
  var dir;
  if (await Permission.storage.request().isGranted) {
    final appDir = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    dir = Directory('$appDir/YtDownloaderFlutter/$playlistName');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
  await for (final video in yt.playlists.getVideos(playlistId)) {
    final videoTitle = video.title.replaceAll(RegExp(r'[^\w\s]+'), '');
    final videoFilePath = path.join(dir.path, '$videoTitle.mp3');

    if (await File(videoFilePath).exists()) {
      continue;
    }

    try {
      var audioStreamManifest =
          await yt.videos.streamsClient.getManifest(video.id);
      if (audioStreamManifest.audioOnly.isNotEmpty) {
        final stream =
            yt.videos.streamsClient.get(audioStreamManifest.audioOnly.first);
            
        final file = File(videoFilePath);
        final output = file.openWrite();
        stream.listen((bytes) => output.add(bytes), onDone: () async {
          print("Done downloading file $videoTitle");
          await output.close();
        });
      } else {
        print('No audios for : $videoTitle');
      }
    } catch (e) {
      print("Download error : " + e.toString());
    }
  }

  yt.close();
}
