import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../itg_localization.dart';
import 'bloc/lyrics_search.dart';

class SearchBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _lyricSearchController = TextEditingController();
  late LyricsSearchBloc _lyricSearchBloc;

  @override
  void initState() {
    super.initState();
    _lyricSearchBloc = BlocProvider.of<LyricsSearchBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _lyricSearchController,
      onChanged: (text) {
        _lyricSearchBloc.add(TextChanged(query: text));
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: ItgLocalization.tr('search lyrics')),
    );
  }

  @override
  void dispose() {
    _lyricSearchController.dispose();
    super.dispose();
  }
}
