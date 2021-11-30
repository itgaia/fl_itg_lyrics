import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:itg_lyrics/src/core/constants.dart';
import 'package:itg_lyrics/src/features/lyrics/api/search_result_error.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/bloc/lyric_add_edit.dart';
import 'package:rxdart/rxdart.dart';

import 'lyrics_search.dart';

class LyricsSearchBloc extends Bloc<LyricSearchEvent, LyricSearchState> {
  final LyricsRepository lyricsRepository;
  final LyricAddEditBloc lyricAddEditBloc;

  late StreamSubscription addEditBlocSubscription;

  LyricsSearchBloc({
    required this.lyricsRepository,
    required this.lyricAddEditBloc,
  }) : super(SearchStateEmpty()) {
    addEditBlocSubscription = lyricAddEditBloc.stream.listen((lyricAddEditState) {
      if (state is SearchStateSuccess) {
        if (lyricAddEditState is EditLyricStateSuccess) {
          add(LyricUpdated(lyric: lyricAddEditState.lyric));
        } else if (lyricAddEditState is AddLyricStateSuccess) {
          add(LyricAdded(lyric: lyricAddEditState.lyric));
        }
      }
    });
  }

  @override
  Stream<Transition<LyricSearchEvent, LyricSearchState>> transformEvents(
    Stream<LyricSearchEvent> events,
    TransitionFunction<LyricSearchEvent, LyricSearchState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is! TextChanged);

    final debounceStream =
        events.where((event) => event is TextChanged).debounceTime(
              Duration(milliseconds: DEFAULT_SEARCH_DEBOUNCE),
            );

    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LyricSearchState> mapEventToState(LyricSearchEvent event) async* {
    if (event is TextChanged) {
      yield* _mapLyricSearchTextChangedToState(event);
    }
    if (event is RemoveLyric) {
      yield* _mapLyricRemoveToState(event);
    }
    if (event is LyricUpdated) {
      yield* _mapLyricUpdateToState(event);
    }
    if (event is LyricAdded) {
      yield* _mapLyricAddedToState(event);
    }
  }

  Stream<LyricSearchState> _mapLyricSearchTextChangedToState(
      TextChanged event) async* {
    final String searchQuery = event.query;
    if (searchQuery.isEmpty) {
      yield SearchStateEmpty();
    } else {
      yield SearchStateLoading();
      try {
        final failureOrLyrics = await lyricsRepository.searchLyrics(searchQuery);
        if (failureOrLyrics.isRight()) {
          yield SearchStateSuccess(failureOrLyrics.toOption().toNullable()!, searchQuery);
        } else {
          yield SearchStateError('Error on search!');
        }
      } catch (error) {
        yield error is SearchResultError
            ? SearchStateError(error.message)
            : SearchStateError("Default error");
      }
    }
  }

  Stream<LyricSearchState> _mapLyricRemoveToState(RemoveLyric event) async* {
    await lyricsRepository.removeLyric(event.lyricID);
    if (state is SearchStateSuccess) {
      SearchStateSuccess searchState = state as SearchStateSuccess;
      searchState.lyrics.removeWhere((lyric) {
        return lyric.id == event.lyricID;
      });
      yield SearchStateSuccess(searchState.lyrics, searchState.query);
    }
  }

  Stream<LyricSearchState> _mapLyricUpdateToState(LyricUpdated event) async* {
    if (state is SearchStateSuccess) {
      SearchStateSuccess successState = state as SearchStateSuccess;
      List<LyricsEntity> updatedList = successState.lyrics;
      if (event.lyric.isInQuery(successState.query)) {
        updatedList = updatedList.map((lyric) {
          return lyric.id == event.lyric.id ? event.lyric : lyric;
        }).toList();
      } else {
        updatedList.removeWhere((lyric) => lyric.id == event.lyric.id);
      }
      yield SearchStateSuccess(updatedList, successState.query);
    }
  }

  Stream<LyricSearchState> _mapLyricAddedToState(LyricAdded event) async* {
    if (state is SearchStateSuccess) {
      SearchStateSuccess successState = state as SearchStateSuccess;
      List<LyricsEntity> updatedList = List.from(successState.lyrics);

      if (event.lyric.isInQuery(successState.query)) {
        updatedList.insert(0, event.lyric);
        yield SearchStateSuccess(updatedList, successState.query);
      }
    }
  }

  @override
  Future<void> close() {
    addEditBlocSubscription.cancel();
    return super.close();
  }
}
