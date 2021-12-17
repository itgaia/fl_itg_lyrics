import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/core/constants.dart';

import '../../../../../injection_container.dart';
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
    // _lyricSearchBloc = BlocProvider.of<LyricsSearchBloc>(context);
    _lyricSearchBloc = sl<LyricsSearchBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _lyricSearchController,
      onChanged: (text) {
        print('>>> SearchBar - Text changed: $text, _lyricSearchBloc: $_lyricSearchBloc');
        _lyricSearchBloc.add(LyricsSearchTextChangedEvent(query: text));
      },
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.search), hintText: ItgLocalization.tr('search lyrics')),
      key: keyTextFieldSearchBar
    );
  }

  @override
  void dispose() {
    // TODO: is it necessary? Sinc I use the get_it??? maybe is crwates a problem....
    _lyricSearchController.dispose();
    super.dispose();
  }
}
