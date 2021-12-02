import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/bloc/lyric_add_edit.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/lyric_add_edit_screen.dart';

import '../../../../../injection_container.dart';
import '../../../../itg_localization.dart';

class LyricsModelDetails extends StatefulWidget {
  final LyricsModel song;

  LyricsModelDetails({required this.song});

  @override
  State<StatefulWidget> createState() {
    return LyricsModelDetailsState(song);
  }
}

class LyricsModelDetailsState extends State<LyricsModelDetails> {
  LyricsEntity lyric;

  late LyricAddEditBloc _lyricAddEditBloc;

  LyricsModelDetailsState(this.lyric);

  @override
  void initState() {
    super.initState();
    // _lyricAddEditBloc = BlocProvider.of<LyricAddEditBloc>(context);
    _lyricAddEditBloc = sl<LyricAddEditBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Change to BlocBuilder
    return BlocListener<LyricAddEditBloc, LyricsAddEditState>(
      bloc: _lyricAddEditBloc,
      listener: (context, state) {
        if (state is LyricsAddEditEditLyricSuccessState) {
          setState(() {
            lyric = state.lyric;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(ItgLocalization.tr('song details')),
        ),
        body: _getScreenBody(context),
        floatingActionButton: _getFloatingButton(context),
      ),
    );
  }

  Padding _getScreenBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
              Text(
                lyric.artist,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
              Text(
                lyric.title,
                style: Theme.of(context).textTheme.headline6,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
              ),
              Text(
                lyric.content,
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
        ),
      );

  FloatingActionButton _getFloatingButton(BuildContext context) =>
      FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LyricAddScreen(lyric: lyric),
            ),
          );
        },
        tooltip: ItgLocalization.tr('edit'),
        child: Icon(Icons.edit),
      );
}
