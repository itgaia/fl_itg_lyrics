import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/core/buttons.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

import '../../../../../injection_container.dart';
import '../../../../itg_localization.dart';
import 'bloc/lyric_add_edit.dart';

class LyricAddForm extends StatefulWidget {
  final LyricsEntity? lyric;

  LyricAddForm({this.lyric});

  @override
  State<StatefulWidget> createState() {
    return LyricAddState(lyric);
  }
}

class LyricAddState extends State<LyricAddForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _lyrics;
  String? _artist;
  String? _title;

  late LyricAddEditBloc _lyricAddEditBloc;

  final LyricsEntity? _lyric;

  LyricAddState(this._lyric);

  @override
  void initState() {
    super.initState();
    // _lyricAddEditBloc = BlocProvider.of<LyricAddEditBloc>(context);
    _lyricAddEditBloc = sl<LyricAddEditBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LyricAddEditBloc, LyricsAddEditState>(
      bloc: _lyricAddEditBloc,
      listener: (context, state) {
        if (state is LyricsAddEditAddLyricSuccessState || state is LyricsAddEditEditLyricSuccessState) {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _lyric?.title ?? "",
                decoration: InputDecoration(hintText: ItgLocalization.tr('title')),
                onSaved: (value) => _title = value,
                validator: (val) {
                  return val?.trim().isEmpty == true
                      ? ItgLocalization.tr('empty title')
                      : null;
                },
              ),
              TextFormField(
                initialValue: _lyric?.artist ?? "",
                decoration: InputDecoration(hintText: ItgLocalization.tr('artist')),
                onSaved: (value) => _artist = value,
                validator: (val) {
                  return val?.trim().isEmpty == true
                      ? ItgLocalization.tr('empty artist')
                      : null;
                },
              ),
              TextFormField(
                initialValue: _lyric?.content ?? "",
                decoration: InputDecoration(hintText: ItgLocalization.tr('lyrics')),
                onSaved: (value) => _lyrics = value,
                validator: (val) {
                  return val?.trim().isEmpty == true
                      ? ItgLocalization.tr('empty lyrics')
                      : null;
                },
                minLines: 5,
                maxLines: 20,
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: getBaseButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _formKey.currentState?.save();
                        // TODO: fix id
                        LyricsModel updatedLyric = LyricsModel(
                          id: _lyric?.id ?? -1,
                          title: _title ?? "",
                          content: _lyrics ?? "",
                          artist: _artist ?? "",
                        );
                        _lyric == null
                            ? _lyricAddEditBloc.addLyric(updatedLyric)
                            : _lyricAddEditBloc.editLyric(updatedLyric);
                      }
                    },
                    text: (_lyric != null ? ItgLocalization.tr('edit') : ItgLocalization.tr('add lyric'))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
