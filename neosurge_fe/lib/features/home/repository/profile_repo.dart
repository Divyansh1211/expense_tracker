import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/network.dart';

class ProfileRepo {
  final NetworkRepo _api;
  final Ref _ref;
  ProfileRepo({required NetworkRepo api, required Ref ref}) : _api = api, _ref = ref;

  }