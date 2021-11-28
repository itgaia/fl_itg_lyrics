import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';

import '../../../../injection_container.dart';
import 'lyrics_bloc.dart';
import 'lyrics_list.dart';

class LyricsPage extends StatelessWidget {
  static const routeName = '/lyrics';

  final String title;

  const LyricsPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocProvider(
        create: (context) => sl<LyricsBloc>()..add(GetLyricsEvent()),
        // create: (_) => LyricsBloc(lyrics: GetLyricsUsecase())..add(GetLyricsEvent()),
        child: LyricsList(),
      ),
    );
  }
}

// class LyricsPage extends StatelessWidget {
//   // final LyricsCubit lyricsCubit;
//   final String title;
//
//   // const LyricsPage({Key? key, required this.title, required this.lyricsCubit}) : super(key: key);
//   const LyricsPage({Key? key, required this.title}) : super(key: key);
//
//   static const routeName = '/lyrics';
//
//   // Sending the Lyric to the next page:
//   // _goToLyricPage(BuildContext context, {LyricsEntity? lyric}) => Navigator.push(
//   //   context,
//   //   MaterialPageRoute(
//   //     builder: (context) => LyricPage(
//   //       lyricsCubit: lyricsCubit,
//   //       lyric: lyric,
//   //     ),
//   //   ),
//   // );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: SingleChildScrollView(
//         child: buildBody(context),
//       ),
//     );
//   }
//
//   BlocProvider<LyricsBloc> buildBody(BuildContext context) {
//     return BlocProvider(
//       create: (context) => sl<LyricsBloc>(),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               // Top half
//               BlocBuilder<LyricsBloc, LyricsState>(
//                 builder: (context, state) {
//                   if (state is Empty) {
//                     return const MessageDisplay(message: 'Start searching!');
//                   } else if (state is Loading) {
//                     return const LoadingWidget();
//                   } else if (state is Loaded) {
//                     return LyricsDisplay(lyrics: state.lyrics);
//                   } else if (state is Error) {
//                     return MessageDisplay(message: state.message);
//                   }
//                   return Container();
//                 },
//               ),
//               const SizedBox(height: 20),
//               // Bottom half
//               const LyricsControls(),
//
//               const SizedBox(height: 10),
//
//               SizedBox(
//                   height: MediaQuery.of(context).size.height / 3 - 31,
//                   child: Image.asset('assets/images/background.png')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
