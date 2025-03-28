import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/models/user_data.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

final currentUserProvider = StateProvider<UserData?>((ref) => null);
