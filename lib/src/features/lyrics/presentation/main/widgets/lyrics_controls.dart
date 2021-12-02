import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/bloc/lyrics_bloc.dart';

import '../../../../../../injection_container.dart';

class LyricsControls extends StatefulWidget {
  const LyricsControls({
    Key? key,
  }) : super(key: key);

  @override
  _LyricsControlsState createState() => _LyricsControlsState();
}

class _LyricsControlsState extends State<LyricsControls> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('>>>>>>> lyrics_controls......');
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        // style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
        onPressed: dispatchLyrics,
        child: const Text('Get lyrics'),
      ),
    );
  }

  void dispatchLyrics() {
    controller.clear();
    // BlocProvider.of<LyricsBloc>(context).add(GetLyricsEvent());
    sl<LyricsBloc>().add(GetLyricsEvent());
  }
}
