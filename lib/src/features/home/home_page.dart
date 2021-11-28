import 'package:flutter/material.dart';
import 'package:itg_lyrics/src/core/custom_button.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/lyrics_page.dart';

import '../settings/settings_view.dart';

class HomePage extends StatelessWidget {
  static const keyButtonLyricsPage = Key('buttonLyricsPage');

  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lyrics App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      body: Row(
        children: [
          CustomButton(
            title: 'Lyrics Page',
            color: Colors.cyan,
            onPressed: () {
              Navigator.restorablePushNamed(
                context,
                LyricsPage.routeName,
              );
            },
            key: keyButtonLyricsPage
          ),
        ],
      ),
    );
  }
}
