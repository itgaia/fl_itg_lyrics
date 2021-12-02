import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/core/loading.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/itg_localization.dart';

import '../../../../../injection_container.dart';
import 'bloc/lyric_add_edit.dart';
import 'lyric_add_edit_form.dart';

class LyricAddScreen extends StatefulWidget {
  final LyricsEntity? lyric;

  LyricAddScreen({this.lyric});

  @override
  State<StatefulWidget> createState() => LyricAddScreenState(
        lyric: lyric,
      );
}

class LyricAddScreenState extends State<StatefulWidget> {
  final LyricsEntity? lyric;

  LyricAddScreenState({this.lyric});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lyric?.id == null ? ItgLocalization.tr('add lyric') : ItgLocalization.tr('edit')),
      ),
      body: BlocBuilder(
        // bloc: BlocProvider.of<LyricAddEditBloc>(context),
        bloc: sl<LyricAddEditBloc>(),
        builder: (BuildContext context, LyricsAddEditState state) {
          return Stack(
            children: <Widget>[
              Container(
                child: LyricAddForm(lyric: lyric),
              ),
              Align(
                alignment: Alignment.center,
                child: Visibility(
                  child: BaseLoadingView(),
                  visible: state is LyricsAddEditLoadingState,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
