import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/features/home/controller/expense_controller.dart';

class BarChartIndicator extends ConsumerWidget {
  const BarChartIndicator({
    super.key,
  });

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blueAccent,
          width: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseSummary = ref.watch(expenseSummaryControllerProvider);
    final Map<String, double> expenseMap = {};
    final now = DateTime.now();

    final last15Days = List.generate(15, (i) => now.subtract(Duration(days: i)))
        .reversed
        .toList();

    for (var e in expenseSummary) {
      final dateFormat = DateTime.parse(e.date!);
      final date = dateFormat.day;
      final amount = e.amount!.toDouble();
      expenseMap.update(date.toString(), (value) => value + amount,
          ifAbsent: () => amount);
    }

    final barGroups = last15Days.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value.day.toString();
      final amount = expenseMap[date] ?? 0.0;
      return makeGroupData(index, amount);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0),
          )
        ],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Last 15 days",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: expenseSummary.fold(
                  0,
                  (large, item) {
                    return math.max(large!, item.amount!.toDouble());
                  },
                ),
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final dayIndex = value.toInt();
                        if (dayIndex >= 0 && dayIndex < last15Days.length) {
                          final date = last15Days[dayIndex];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${date.day}'),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(enabled: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
