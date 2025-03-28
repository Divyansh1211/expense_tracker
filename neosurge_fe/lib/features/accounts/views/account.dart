import 'package:flutter/material.dart';
import 'package:neosurge_fe/features/accounts/views/widgets/bar_chart.dart';
import 'package:neosurge_fe/features/accounts/views/widgets/pie_chart.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          PieChartIndicator(),
          BarChartIndicator(),
        ],
      ),
    );
  }
}
