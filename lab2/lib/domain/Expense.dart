import 'Category.dart';
import 'currency.dart';

class Expense {
  String name;
  Category category;
  double amount;
  Currency currency;
  DateTime date;
  String description;

  Expense(this.name, this.category, this.amount, this.currency, this.date,
      this.description);
}