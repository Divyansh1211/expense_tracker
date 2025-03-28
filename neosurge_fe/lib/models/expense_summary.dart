class ExpenseSummary {
  final String? date;
  final int? amount;

  ExpenseSummary({this.date, this.amount});

  factory ExpenseSummary.fromJson(Map<String, dynamic> json) => ExpenseSummary(
        date: json['date'] as String?,
        amount: json["_sum"]['amount'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'amount': amount,
      };
}
