import 'package:flutter/material.dart';

import 'package:itg_lyrics/src/features/home/home_page.dart';
import '../injection_container.dart';
import 'features/lyrics/presentation/main/lyrics_page.dart';
import 'features/lyrics/presentation/search/lyrics_search_page.dart';
import 'features/settings/settings_controller.dart';
import 'features/settings/settings_view.dart';
import 'itg_localization.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    // required this.settingsController,
  }) : super(key: key);

  // final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = sl();
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          onGenerateTitle: (BuildContext context) => ItgLocalization.tr('appTitle'),

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case LyricsSearchPage.routeName:
                    // return LyricsSearchPage(addLyricUsecase: sl(), searchLyricsUsecase: sl(), removeLyricUsecase: sl(), editLyricUsecase: sl(),);
                    return LyricsSearchPage();
                  case LyricsPage.routeName:
                  // default:
                    return const LyricsPage(title: 'Lyrics');
                  // case LyricPage.routeName:
                  //   return LyricPage(lyricsCubit: LyricsCubit(),);
                  case HomePage.routeName:
                  default:
                    // return const HomePage();
                    return sl<SettingsController>().appMainPage;
                }
              },
            );
          },
        );
      },
    );
  }
}
