import 'package:equatable/equatable.dart';

class LyricsEntity extends Equatable {
  const LyricsEntity({required this.id, required this.title, required this.artist});

  final int id;
  final String title;
  final String artist;

  @override
  List<Object> get props => [id, title, artist];
}
