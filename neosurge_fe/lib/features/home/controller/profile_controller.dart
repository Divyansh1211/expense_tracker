import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/models/user_data.dart';

class ProfileController extends StateNotifier<UserData> {
  final Ref _ref;
  final ProfileRepository _repo;

  ProfileController({
    required ProfileRepository repo,
    required Ref ref,
    required UserData user,
  })  : _ref = ref,
        _repo = repo,
        super(user);

  Future<void> updateProfile({
    required BuildContext context,
    required UserData profile,
    WidgetRef? ref,
  }) async {}
}
