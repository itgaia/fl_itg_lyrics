import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:itg_lyrics/src/core/constants.dart';
import 'package:itg_lyrics/src/features/lyrics/api/search_result_error.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/remove_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/search_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/bloc/lyric_add_edit.dart';
import 'package:rxdart/rxdart.dart';

import 'lyrics_search.dart';

class LyricsSearchBloc extends Bloc<LyricsSearchEvent, LyricsSearchState> {
  // final LyricsRepository lyricsRepository;
  final SearchLyricsUsecase searchLyricsUsecase;
  final RemoveLyricUsecase removeLyricUsecase;
  final LyricAddEditBloc lyricAddEditBloc;

  late StreamSubscription addEditBlocSubscription;

  LyricsSearchBloc({
    // required this.lyricsRepository,
    required this.searchLyricsUsecase,
    required this.removeLyricUsecase,
    required this.lyricAddEditBloc,
  }) : super(LyricsSearchEmptyState()) {
    print('>>> LyricsSearchBloc - lyricAddEditBloc: $lyricAddEditBloc');
    addEditBlocSubscription = lyricAddEditBloc.stream.listen((lyricAddEditState) {
      print('>>> LyricsSearchBloc/addEditBlocSubscription - lyricAddEditState: $lyricAddEditState');
      if (state is LyricsSearchSuccessState) {
        if (lyricAddEditState is LyricsAddEditEditLyricSuccessState) {
          add(LyricsSearchLyricUpdatedEvent(lyric: lyricAddEditState.lyric));
        } else if (lyricAddEditState is LyricsAddEditAddLyricSuccessState) {
          add(LyricsSearchLyricAddedEvent(lyric: lyricAddEditState.lyric));
        }
      }
    });
  }

  @override
  Stream<Transition<LyricsSearchEvent, LyricsSearchState>> transformEvents(
    Stream<LyricsSearchEvent> events,
    TransitionFunction<LyricsSearchEvent, LyricsSearchState> transitionFn,
  ) {
    print('>>> LyricsSearchBloc.transformEvents - events: $events');
    final nonDebounceStream = events.where((event) => event is! LyricsSearchTextChangedEvent);

    final debounceStream =
        events.where((event) => event is LyricsSearchTextChangedEvent).debounceTime(
              Duration(milliseconds: defaultSearchDebounce),
            );

    return super.transformEvents(
      MergeStream([nonDebounceStream, debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LyricsSearchState> mapEventToState(LyricsSearchEvent event) async* {
    print('>>> LyricsSearchBloc.mapEventToState - event: $event');
    if (event is LyricsSearchTextChangedEvent) {
      yield* _mapLyricSearchTextChangedToState(event);
    }
    if (event is LyricsSearchLyricRemovedEvent) {
      yield* _mapLyricRemoveToState(event);
    }
    if (event is LyricsSearchLyricUpdatedEvent) {
      yield* _mapLyricUpdateToState(event);
    }
    if (event is LyricsSearchLyricAddedEvent) {
      yield* _mapLyricAddedToState(event);
    }
  }

  Stream<LyricsSearchState> _mapLyricSearchTextChangedToState(
      LyricsSearchTextChangedEvent event) async* {
    print('>>> LyricsSearchBloc._mapLyricSearchTextChangedToState - event: $event');
    final String searchQuery = event.query;
    if (searchQuery.isEmpty) {
      yield LyricsSearchEmptyState();
    } else {
      yield LyricsSearchLoadingState();
      try {
        // final failureOrLyrics = await lyricsRepository.searchLyrics(searchQuery);
        print('>>> LyricsSearchBloc._mapLyricSearchTextChangedToState - bef call searchLyricsUsecase');
        // final failureOrLyrics = await searchLyricsUsecase(searchQuery);
        var failureOrLyrics;
        try {
          failureOrLyrics = await searchLyricsUsecase(searchQuery);
        } catch (e) {
          print('>>> LyricsSearchBloc._mapLyricSearchTextChangedToState - call searchLyricsUsecase error: $e');
        }
        print('>>> LyricsSearchBloc._mapLyricSearchTextChangedToState - failureOrLyrics: $failureOrLyrics');
        if (failureOrLyrics.isRight()) {
          print('>>> LyricsSearchBloc._mapLyricSearchTextChangedToState - success: ${failureOrLyrics.toOption().toNullable()!}');
          yield LyricsSearchSuccessState(failureOrLyrics.toOption().toNullable()!, searchQuery);
        } else {
          yield LyricsSearchErrorState('Error on search!');
        }
      } catch (error) {
        yield error is SearchResultError
            ? LyricsSearchErrorState(error.message)
            : LyricsSearchErrorState("Default error");
      }
    }
  }

  Stream<LyricsSearchState> _mapLyricAddedToState(LyricsSearchLyricAddedEvent event) async* {
    print('>>> LyricsSearchBloc._mapLyricAddedToState - event: $event');
    if (state is LyricsSearchSuccessState) {
      LyricsSearchSuccessState successState = state as LyricsSearchSuccessState;
      List<LyricsEntity> updatedList = List.from(successState.lyrics);

      if (event.lyric.isInQuery(successState.query)) {
        updatedList.insert(0, event.lyric);
        yield LyricsSearchSuccessState(updatedList, successState.query);
      }
    }
  }

  Stream<LyricsSearchState> _mapLyricUpdateToState(LyricsSearchLyricUpdatedEvent event) async* {
    print('>>> LyricsSearchBloc._mapLyricUpdateToState - event: $event');
    if (state is LyricsSearchSuccessState) {
      LyricsSearchSuccessState successState = state as LyricsSearchSuccessState;
      List<LyricsEntity> updatedList = successState.lyrics;
      if (event.lyric.isInQuery(successState.query)) {
        updatedList = updatedList.map((lyric) {
          return lyric.id == event.lyric.id ? event.lyric : lyric;
        }).toList();
      } else {
        updatedList.removeWhere((lyric) => lyric.id == event.lyric.id);
      }
      yield LyricsSearchSuccessState(updatedList, successState.query);
    }
  }

  Stream<LyricsSearchState> _mapLyricRemoveToState(LyricsSearchLyricRemovedEvent event) async* {
    print('>>> LyricsSearchBloc._mapLyricRemoveToState - event: $event');
    // await lyricsRepository.removeLyric(event.lyricID);
    await removeLyricUsecase(event.lyricID);
    print('>>> LyricsSearchBloc._mapLyricRemoveToState - state: $state');
    if (state is LyricsSearchSuccessState) {
      LyricsSearchSuccessState searchState = state as LyricsSearchSuccessState;
      print('>>> LyricsSearchBloc._mapLyricRemoveToState - bef removeWhere - searchState.lyrics: ${searchState.lyrics}');
      searchState.lyrics.removeWhere((lyric) {
        print('>>> LyricsSearchBloc._mapLyricRemoveToState - removeWhere - lyric: $lyric, event.lyricID: ${event.lyricID}, lyric.id: ${lyric.id}');
        return lyric.id == event.lyricID;
      });
      print('>>> LyricsSearchBloc._mapLyricRemoveToState - aft removeWhere - searchState.lyrics: ${searchState.lyrics}');
      print('>>> LyricsSearchBloc._mapLyricRemoveToState - searchState.lyrics: ${searchState.lyrics}, searchState.query: ${searchState.query}');
      yield LyricsSearchSuccessState(searchState.lyrics, searchState.query);
    }
  }

  @override
  Future<void> close() {
    addEditBlocSubscription.cancel();
    return super.close();
  }
}
