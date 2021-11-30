import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/network_lyric.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/details/lyric_details_screen.dart';

import '../../../../itg_localization.dart';
import 'bloc/lyrics_search.dart';

class LyricsSearchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LyricsSearchBloc, LyricSearchState>(
      bloc: BlocProvider.of<LyricsSearchBloc>(context),
      builder: (BuildContext context, LyricSearchState state) {
        if (state is SearchStateLoading) {
          return const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is SearchStateError) {
          return Text(state.error);
        }
        if (state is SearchStateSuccess) {
          return state.lyrics.isEmpty
              ? Text(ItgLocalization.tr('empty list'))
              : Expanded(
                  child: _LyricsSearchResults(
                    lyricsList: state.lyrics,
                  ),
                );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(ItgLocalization.tr('enter song title')),
          );
        }
      },
    );
  }
}

class _LyricsSearchResults extends StatelessWidget {
  final List<LyricsEntity> lyricsList;

  const _LyricsSearchResults({Key? key, required this.lyricsList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lyricsList.length,
      itemBuilder: (BuildContext context, int index) {
        return _LyricSearchResultItem(
          lyric: lyricsList[index],
        );
      },
    );
  }
}

class _LyricSearchResultItem extends StatelessWidget {
  final LyricsEntity lyric;

  const _LyricSearchResultItem({Key? key, required this.lyric}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return lyric is NetworkLyric
        ? _getLyricDetailsLayout(context)
        : Dismissible(
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) {
              BlocProvider.of<LyricsSearchBloc>(context).add(
                RemoveLyric(lyricID: lyric.id),
              );
            },
            key: Key(UniqueKey().toString()),
            child: _getLyricDetailsLayout(context),
          );
  }

  Padding _getLyricDetailsLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: lyric is LyricsModel
            ? Icon(Icons.sd_card)
            : Image.network(
                (lyric as NetworkLyric).albumThumbnail,
              ),
        title: Text(lyric.title),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LyricDetailsScreen(lyric)),
          );
        },
      ),
    );
  }
}
