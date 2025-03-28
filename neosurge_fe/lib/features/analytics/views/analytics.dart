import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          color: Colors.red,
          child: Lottie.asset(
            "assets/noDataFound.json",
          ),
        ),
      ),
    );
  }
}
