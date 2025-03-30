import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/features/accounts/views/widgets/indicator.dart';
import 'package:neosurge_fe/features/home/controller/expense_controller.dart';
import 'package:neosurge_fe/models/expense.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PieChartIndicator extends ConsumerStatefulWidget {
  const PieChartIndicator({
    super.key,
  });

  @override
  ConsumerState<PieChartIndicator> createState() => _PieChartIndicatorState();
}

class _PieChartIndicatorState extends ConsumerState<PieChartIndicator> {
  String dataType = "Today";
  int touchedIndex = -1;
  Color getColor(String category) {
    switch (category) {
      case "Food":
        return Colors.red;
      case "Transportation":
        return Colors.green;
      case "Entertainment":
        return Colors.purple;
      case "Shopping":
        return Colors.yellow;
      default:
        return Colors.blue;
    }
  }

  Future<void> exportToCsv(List<Expense> expenses) async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
      if (await Permission.manageExternalStorage.request().isDenied) {
        log("Manage external storage permission denied");
        return;
      }
    }
    if (await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted) {
      List<List<String>> csvData = [
        ["Amount (INR)", "Category"],
        ...expenses.map((e) => ["${e.amount}", e.category ?? "Unknown"])
      ];

      String csv = const ListToCsvConverter().convert(csvData);

      final directory = await getDownloadsDirectory();
      final path =
          '${directory!.path}/expenses_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File(path);
      await file.writeAsString(csv);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Expenses exported to $path'),
        ));
      }
      try {
        await OpenFile.open(path);
      } catch (e) {
        log(e.toString());
      }
    } else {
      log("Permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseControllerProvider);
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
        border: Border.all(color: Colors.black),
      ),
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
                    PopupMenuItem(
                      onTap: () {
                        setState(() {
                          ref
                              .read(expenseControllerProvider.notifier)
                              .getFilteredData(type: "daily");
                          dataType = "Today";
                        });
                      },
                      value: 1,
                      child: const Text("Today"),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        setState(() {
                          ref
                              .read(expenseControllerProvider.notifier)
                              .getFilteredData(type: "weekly");
                          dataType = "This Week";
                        });
                      },
                      value: 2,
                      child: const Text("This Week"),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        setState(() {
                          ref
                              .read(expenseControllerProvider.notifier)
                              .getFilteredData(type: "monthly");
                          dataType = "This Month";
                        });
                      },
                      value: 3,
                      child: const Text("This Month"),
                    ),
                  ];
                },
              ),
            ],
          ),
          Text(
            dataType,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC0C0C0)),
          ),
          Text(
            "₹ ${expenses.fold(0.0, (sum, expense) => sum + expense.amount!).toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.linear,
                    PieChartData(
                      centerSpaceRadius: 40,
                      titleSunbeamLayout: true,
                      sections: expenses.map((expense) {
                        return PieChartSectionData(
                          color: getColor(expense.category!),
                          value: expense.amount!.toDouble(),
                          showTitle: false,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: expenses.map((expense) {
                  return Indicator(
                    color: getColor(expense.category!),
                    text: expense.category!,
                    isSquare: true,
                  );
                }).toList(),
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async => await exportToCsv(expenses),
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
