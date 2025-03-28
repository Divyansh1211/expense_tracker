class Expense {
  final String? category;
  final int? amount;
  final String? description;
  final String? date;

  Expense({this.category, this.amount, this.description, this.date});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      category: json['category'],
      amount: json["_sum"]['amount'],
      description: json['description'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category,
        'amount': amount,
        'description': description,
        'date': date,
      };
}
