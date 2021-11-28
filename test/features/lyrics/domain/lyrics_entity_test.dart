import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

import '../lyrics_test_helper.dart';

void main() {
  final LyricsEntity lyric = lyricsTestData().first;

  test('test 1', () {
    expect(lyric.id, 1);
    expect(lyric.title, "test song 1");
    expect(lyric.artist, "test artist 1");
  });
}