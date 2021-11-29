import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/widgets/bottom_loader.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/widgets/loading_widget.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/widgets/lyrics_display.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/widgets/lyrics_list_item.dart';

import 'bloc/lyrics_bloc.dart';

class LyricsList extends StatefulWidget {
  @override
  _LyricsListState createState() => _LyricsListState();
}

class _LyricsListState extends State<LyricsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LyricsBloc, LyricsState>(
      builder: (context, state) {
        print('>>> [LyricsList/BlocBuilder] state: $state');
        if (state is Empty) {
          return const Center(child: Text('no lyrics'));
        } else if (state is Loading) {
          return const LoadingWidget();
        } else if (state is Loaded) {
          // return LyricsDisplay(lyrics: state.lyrics);
          print('>>> [LyricsList/BlocBuilder] state is Loaded...');
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              print('>>> [LyricsList/ListView.builder] index: $index, state.lyrics.length: ${state.lyrics.length}');
              return index >= state.lyrics.length
                  ? BottomLoader()
                  : LyricsListItem(lyric: state.lyrics[index]);
            },
            itemCount: state.hasReachedMax
                ? state.lyrics.length
                : state.lyrics.length + 1,
            controller: _scrollController,
          );
        } else if (state is Error) {
          // return MessageDisplay(message: state.message);
          return const Center(child: Text('failed to fetch lyrics'));
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<LyricsBloc>().add(GetLyricsEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
