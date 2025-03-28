import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/features/auth/views/signup.dart';
import 'package:neosurge_fe/features/home/views/home.dart';
import 'package:neosurge_fe/global/controller/shared_preferences.dart';
import 'package:neosurge_fe/provider.dart';

class Splashscreen extends ConsumerStatefulWidget {
  const Splashscreen({super.key});

  @override
  ConsumerState<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends ConsumerState<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      final token = await ref.read(sharedPrefsControllerPovider).getCookie();
      final user = await ref.read(sharedPrefsControllerPovider).getUser();
      if (token != null && user != null) {
        ref.read(authTokenProvider.notifier).update((state) => token);
        ref.read(currentUserProvider.notifier).update((state) => user);
        mounted
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()))
            : null;
      } else {
        mounted
            ? Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()))
            : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
