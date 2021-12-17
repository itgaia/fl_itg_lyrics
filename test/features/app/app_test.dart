import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/src/features/home/home_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helper.dart';

void main() {
  group('MyApp', () {
    testWidgets('page class', (widgetTester) async {
      await testWidgetPageClass<HomePage>(widgetTester, createWidgetUnderTest);
    });

    testWidgets('page title', (widgetTester) async {
      await testWidgetPageTitle(widgetTester, createWidgetUnderTest, 'Lyrics App');
    });
  });
}
