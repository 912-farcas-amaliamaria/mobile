import 'category.dart';
import 'currency.dart';

class Expense {
  int id;
  String name;
  Category category;
  double amount;
  Currency currency;
  DateTime date;
  String description;

  Expense(this.id, this.name, this.category, this.amount, this.currency, this.date,
      this.description);

  factory Expense.fromJson(Map<String, dynamic> json) {
    var expenseJson = json['expenses'] as Map<String, dynamic>; // Accessing the nested 'expenses' map

    if (expenseJson['id'] == null) {
      throw ArgumentError('id is null in Expense.fromJson');
    }

    return Expense(
      expenseJson['id'] as int,
      expenseJson['name'] as String,
      CategoryExtension.fromString(expenseJson['category'] as String),
      (expenseJson['amount'] as num).toDouble(),
      CurrencyExtension.fromString(expenseJson['currency'] as String),
      expenseJson['date'],
      expenseJson['description'] as String,
    );
  }

}