import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:neosurge_fe/features/auth/controller/profile_controller.dart';
import 'package:neosurge_fe/features/home/repository/expense_repo.dart';
import 'package:neosurge_fe/models/expense.dart';
import 'package:neosurge_fe/models/expense_summary.dart';

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, List<Expense>>((ref) =>
        ExpenseController(
            ref: ref, expenseRepo: ref.watch(expenseRepoProvider)));

class ExpenseController extends StateNotifier<List<Expense>> {
  final Ref _ref;
  final ExpenseRepo _expenseRepo;

  ExpenseController({required Ref ref, required ExpenseRepo expenseRepo})
      : _expenseRepo = expenseRepo,
        _ref = ref,
        super([]);

  Future<Map<String, dynamic>> getFilteredData({String? type}) async {
    final res = await _expenseRepo.getFilteredData(type: type);
    final expenseList = res['expenses']
        .map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList();
    state = List<Expense>.from(expenseList);
    return res;
  }

  Future<Map<String, dynamic>> addExpense(
      {required BuildContext context,
      required int amount,
      required String description,
      required String category,
      required DateTime dateTime}) async {
    final expense = Expense(
      amount: amount,
      description: description,
      category: category,
      date: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(dateTime),
    );
    final res = await _expenseRepo.addExpense(expense: expense);
    if (res["success"]) {
      getFilteredData();
      await _ref.read(expenseSummaryControllerProvider.notifier).getSummary();
      context.mounted ? Navigator.pop(context) : null;
    }
    _ref.read(profileController.notifier).setLoading(false);
    return res;
  }
}

final expenseSummaryControllerProvider =
    StateNotifierProvider<ExpenseSummaryController, List<ExpenseSummary>>(
  (ref) => ExpenseSummaryController(
    ref: ref,
    expenseRepo: ref.watch(expenseRepoProvider),
  ),
);

class ExpenseSummaryController extends StateNotifier<List<ExpenseSummary>> {
  final ExpenseRepo _expenseRepo;

  ExpenseSummaryController({required Ref ref, required ExpenseRepo expenseRepo})
      : _expenseRepo = expenseRepo,
        super([]);

  Future<Map<String, dynamic>> getSummary() async {
    final res = await _expenseRepo.getSummary();
    final expenseList = res['summary']
        .map((e) => ExpenseSummary.fromJson(e as Map<String, dynamic>))
        .toList();
    state = List<ExpenseSummary>.from(expenseList);
    return res;
  }
}
