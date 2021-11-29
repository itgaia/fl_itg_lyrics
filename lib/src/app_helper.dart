import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/lyrics/domain/get_lyrics_usecase.dart';
import 'features/lyrics/presentation/main/bloc/lyrics_bloc.dart';

// Exists here for the temp fix of the issue with DataConnectionChecker in Web
class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}
