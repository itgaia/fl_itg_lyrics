import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/core/constants.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/add_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/edit_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/remove_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/search_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/bloc/lyric_add_edit.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/lyric_add_edit_screen.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/search/search_bar.dart';

import '../../../../itg_localization.dart';
import 'bloc/lyrics_search.dart';
import 'lyrics_search_list.dart';

class LyricsSearchPage extends StatelessWidget {
  // final AddLyricUsecase addLyricUsecase;
  // final EditLyricUsecase editLyricUsecase;
  // final SearchLyricsUsecase searchLyricsUsecase;
  // final RemoveLyricUsecase removeLyricUsecase;
  //
  // LyricsSearchPage({
  //   Key? key, required this.addLyricUsecase, required this.editLyricUsecase,
  //   required this.searchLyricsUsecase, required this.removeLyricUsecase}): super(key: key);

  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ItgLocalization.tr('app name')),
      ),
      body: Column(
        children: <Widget>[SearchBar(), LyricsSearchList()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LyricAddScreen()),
          );
        },
        child: Icon(Icons.add),
        key: keyButtonSearchPageAdd
      ),
    );
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider<LyricAddEditBloc>(
    //       create: (context) =>
    //         LyricAddEditBloc(
    //           addLyricUsecase: addLyricUsecase,
    //           editLyricUsecase: editLyricUsecase
    //         ),
    //     ),
    //     BlocProvider<LyricsSearchBloc>(
    //       create: (context) => LyricsSearchBloc(
    //         searchLyricsUsecase: searchLyricsUsecase,
    //         removeLyricUsecase: removeLyricUsecase,
    //         lyricAddEditBloc: BlocProvider.of<LyricAddEditBloc>(context)),
    //     ),
    //   ],
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: Text(ItgLocalization.tr('app name')),
    //     ),
    //     body: Column(
    //       children: <Widget>[SearchBar(), LyricsSearchList()],
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(builder: (context) => LyricAddScreen()),
    //         );
    //       },
    //       child: Icon(Icons.add),
    //     ),
    //   )
    // );
  }
}
