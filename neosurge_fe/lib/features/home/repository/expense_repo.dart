import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosurge_fe/config.dart';
import 'package:neosurge_fe/models/expense.dart';
import 'package:neosurge_fe/network.dart';

final expenseRepoProvider = Provider(
  (ref) => ExpenseRepo(
    api: ref.watch(networkRepoProvider),
    ref: ref,
  ),
);

class ExpenseRepo {
  final NetworkRepo _api;

  ExpenseRepo({required NetworkRepo api, required Ref ref})
      : _api = api;

  Future<Map<String, dynamic>> getSummary() async {
    final res =
        await _api.getRequest(url: Config.getSummary, requireAuth: true);
    return res;
  }

  Future<Map<String, dynamic>> getFilteredData({String? type}) async {
    final res = await _api.getRequest(
        url: "${Config.filterExpenses}${type ?? "daily"}", requireAuth: true);
    return res;
  }

  Future<Map<String, dynamic>> addExpense({required Expense expense}) async {
    final res = await _api.postRequest(
        url: Config.addExpense, requireAuth: false, body: expense.toJson());
    return res;
  }
}
