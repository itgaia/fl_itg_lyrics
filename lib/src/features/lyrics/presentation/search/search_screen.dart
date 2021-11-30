import 'package:flutter/material.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/lyric_add_edit_screen.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/search/search_bar.dart';

import '../../../../itg_localization.dart';
import 'lyrics_search_list.dart';

class SearchScreen extends StatelessWidget {
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
      ),
    );
  }
}
