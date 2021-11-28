# ITG Lyrics Flutter App

based on:
* [itg_notes app](https://github.com/itgaia/fl-itg_notes)
* Getting Started With Flutter BLoC
  https://www.netguru.com/blog/flutter-bloc
  Kacper Kogut - Nov 12, 2019
* Mastering Mocking In Flutter In 15 Minutes
  https://fredgrott.medium.com/mastering-mocking-in-flutter-in-15-minutes-8f829e0efbdd
  https://github.com/fredgrott/not_in_flutter_docs/tree/master/gtdd/gtdd_ten
  Fred Grott - Nov 7 2021

### Goals

* test how the BLoC pattern will work with multiple data sources.
* Business logic is free from any platform-dependent code
* Be testable, to make sure everything works as you planned.
* Utilise declarative nature of Flutter
* Be granular as much as needed, so people can work together.

### Nusiness Requirements

A simple app for fetching song lyrics.
User can search for lyrics from the Genius API.
User can create, update and delete their own lyrics

### Design

a Search Screen with the option to search for song lyrics.
show list of lyrics resuls
each lyric:
has song title, artist name, lyrics
has buttons: add, edit & delete lyric
click on a lyric

#### Search screen events:

* TextChanged: shows that input in the search field has changed, and new song list should be fetched.

#### Search screen states that could be in:

* StateEmpty: it should be active when there is no user input in the search bar, it would be the BLoC’s initial state.
* StateError: the state should be passed with an error message when something goes wrong.
* StateLyricsLoaded: this state will be passed, with a list of songs, upon the successful fetching songs from the repository.
* StateLoading: defines that the repository is waiting for the response from the server, or is processing data.

### Testing

* Widget testing
* Unit testing
* Integration testing

I want to test:

* Lyrics are showing at LyricsScreen
* Deleting a Lyric is working at LyricsScreen
* Lyric can be editd at LyricsScreen

### Implementation steps to follow

data sources and repository
BLoC
Create widget test for lyrics screen

### API

