import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/global/repo/shared_preferences.dart';
import 'package:neosurge_fe/models/user_data.dart';

final sharedPrefsControllerPovider = Provider((ref) {
  final repo = ref.watch(sharedPrefsRepoProvider);
  return SharedPrefsController(repo: repo);
});

class SharedPrefsController {
  final SharedPrefsRepo _repo;

  SharedPrefsController({required SharedPrefsRepo repo}) : _repo = repo;

  Future<String?> getCookie() async {
    return _repo.getCookie();
  }

  Future<void> setCookie({required String cookie}) async {
    await _repo.setCookie(cookie);
  }

  Future<UserData?> getUser() async {
    return _repo.getCurrentUser();
  }

  Future<void> setUser({required UserData user}) async {
    _repo.setCurrentUser(user);
  }

  Future<void> clear() async {
    return _repo.clear();
  }
}
