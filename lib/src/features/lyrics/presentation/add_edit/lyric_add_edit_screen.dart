import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/core/loading.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/itg_localization.dart';

import 'bloc/lyric_add_edit.dart';
import 'lyric_add_edit_form.dart';

class LyricAddScreen extends StatefulWidget {
  final LyricsModel? lyric;

  LyricAddScreen({this.lyric});

  @override
  State<StatefulWidget> createState() => LyricAddScreenState(
        lyric: lyric,
      );
}

class LyricAddScreenState extends State<StatefulWidget> {
  final LyricsModel? lyric;

  LyricAddScreenState({this.lyric});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lyric?.id == null ? ItgLocalization.tr('add lyric') : ItgLocalization.tr('edit')),
      ),
      body: BlocBuilder(
        bloc: BlocProvider.of<LyricAddEditBloc>(context),
        builder: (BuildContext context, LyricAddEditState state) {
          return Stack(
            children: <Widget>[
              Container(
                child: LyricAddForm(lyric: lyric),
              ),
              Align(
                alignment: Alignment.center,
                child: Visibility(
                  child: BaseLoadingView(),
                  visible: state is StateLoading,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
