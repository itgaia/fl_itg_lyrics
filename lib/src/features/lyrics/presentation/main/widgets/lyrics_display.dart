import 'package:flutter/material.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

class LyricsDisplay extends StatelessWidget {
  final LyricsEntity lyrics;
  const LyricsDisplay({Key? key, required this.lyrics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('>>>>>>> lyrics_display......');
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Expanded(
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              lyrics.toString(),
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
