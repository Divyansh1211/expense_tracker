import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PieChartIndicator(),
      ],
    );
  }
}

class PieChartIndicator extends StatelessWidget {
  const PieChartIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(10),
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
          border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Expenses Structure",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 1,
                      child: Text("Today"),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text("This Week"),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text("This Month"),
                    ),
                  ];
                },
              ),
            ],
          ),
          const Text(
            "Last 30 Days",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC0C0C0)),
          ),
          const Text(
            "₹ 10,000",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: PieChart(
              duration: const Duration(milliseconds: 150),
              curve: Curves.linear,
              PieChartData(
                // centerSpaceRadius: 60,
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: 40,
                    title: '40%',
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: 60,
                    title: '60%',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: null,
            child: const Row(
              children: [
                Icon(
                  Icons.download_outlined,
                  color: Color(0xFF01AA71),
                ),
                SizedBox(width: 5),
                Text(
                  "Download Report",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF01AA71),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
