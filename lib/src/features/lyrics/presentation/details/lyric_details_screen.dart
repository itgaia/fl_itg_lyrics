import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/network_lyric.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/details/web_lyric_details.dart';

import 'local_song_details.dart';

class LyricDetailsScreen extends StatelessWidget {
  final LyricsEntity song;

  LyricDetailsScreen(this.song);

  @override
  Widget build(BuildContext context) {
    return song is LyricsModel
        ? LyricsModelDetails(song: song as LyricsModel)
        : WebSongDetails(songDetailsURL: (song as NetworkLyric).lyricsURL);
  }
}
