import 'package:flutter/material.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

class LyricsListItem extends StatelessWidget {
  const LyricsListItem({Key? key, required this.lyric}) : super(key: key);

  final LyricsEntity lyric;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${lyric.id}', style: textTheme.caption),
        title: Text(lyric.title),
        isThreeLine: true,
        subtitle: Text(lyric.artist),
        dense: true,
      ),
    );
  }
}
