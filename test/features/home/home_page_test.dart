import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/src/core/custom_button.dart';
import 'package:itg_lyrics/src/features/home/home_page.dart';
import '../../test_helper.dart';

void main() {
  group('Home page widget tests', () {
    testWidgets('page class', (widgetTester) async {
      await testWidgetPageClass<HomePage>(widgetTester, createWidgetUnderTest);
    });

    testWidgets('page title', (widgetTester) async {
      await testWidgetPageTitle(widgetTester, createWidgetUnderTest, 'Lyrics App');
    });

    testWidgets('button for lyrics', (widgetTester) async {
      await widgetTester.pumpWidget(await createWidgetUnderTest());
      // var button = CustomButton(title: 'aaa', color: Colors.cyan, onPressed: () {},);
      expect(find.byType(CustomButton), findsOneWidget);
      // expect(find.byWidget(button), findsOneWidget);   // TODO: how can I find a specific button???
      expect(find.byKey(const Key('buttonLyricsPage')), findsOneWidget);
      expect(find.text('Lyrics Page'), findsOneWidget);
    });
  });
}