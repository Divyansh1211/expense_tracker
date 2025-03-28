import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/config.dart';
import 'package:neosurge_fe/models/user_data.dart';
import 'package:neosurge_fe/network.dart';

final profileRepoProvider = Provider(
  (ref) => ProfileRepo(api: ref.watch(networkRepoProvider), ref: ref),
);

class ProfileRepo {
  final NetworkRepo _api;

  ProfileRepo({required NetworkRepo api, required Ref ref}) : _api = api;

  Future<Map<String, dynamic>> signUpUser(UserData user) async {
    final res = await _api.postRequest(
      url: Config.createUser,
      requireAuth: false,
      body: user.toJson(),
    );
    return res;
  }

  Future<Map<String, dynamic>> loginUser(UserData user) async {
    final res = await _api.postRequest(
        url: Config.login, requireAuth: false, body: user.toJson());
    return res;
  }
}
