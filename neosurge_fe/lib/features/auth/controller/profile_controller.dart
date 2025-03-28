import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/features/auth/views/login.dart';
import 'package:neosurge_fe/features/auth/repo/profile_repo.dart';
import 'package:neosurge_fe/features/home/views/home.dart';
import 'package:neosurge_fe/global/controller/shared_preferences.dart';
import 'package:neosurge_fe/models/user_data.dart';
import 'package:neosurge_fe/provider.dart';

final profileController = StateNotifierProvider<ProfileController, UserData>(
  (ref) => ProfileController(
    repo: ref.watch(profileRepoProvider),
    ref: ref,
  ),
);

class ProfileController extends StateNotifier<UserData> {
  final Ref _ref;
  final ProfileRepo _repo;

  ProfileController({
    required ProfileRepo repo,
    required Ref ref,
  })  : _ref = ref,
        _repo = repo,
        super(UserData());

  Future<Map<String, dynamic>> signUpUser(
      {required BuildContext context,
      required String name,
      required String email,
      required String password}) async {
    log('$name $email $password');
    final user = UserData(name: name, email: email, password: password);
    final result = await _repo.signUpUser(user);
    log('result: ${result.toString()}', name: 'signUpUser');
    if (result['success']) {
      context.mounted
          ? Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()))
          : null;
    }
    return result;
  }

  Future<Map<String, dynamic>> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final user = UserData(email: email, password: password);
    final result = await _repo.loginUser(user);
    if (result['success']) {
      final userData = UserData.fromJson(result['user']);
      _ref.read(currentUserProvider.notifier).update((state) => userData);
      _ref.read(authTokenProvider.notifier).update((state) => result['token']);
      _ref.read(sharedPrefsControllerPovider).setCookie(cookie: result['token']);
      _ref.read(sharedPrefsControllerPovider).setUser(user: userData);
      context.mounted
          ? Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()))
          : null;
    }
    return result;
  }
}
