import 'category.dart';
import 'currency.dart';

class Expense {
  int? id;
  String name;
  Category category;
  double amount;
  Currency currency;
  DateTime date;
  String description;
  bool isSynced;
  bool isNew;
  bool isUpdated;
  bool isDeleted;


  Expense({
    this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.currency,
    required this.date,
    required this.description,
    this.isSynced = true,  // Defaulting to false
    this.isNew = false,     // Defaulting to false
    this.isUpdated = false, // Defaulting to false
    this.isDeleted = false, // Defaulting to false
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      name: json['name'],
      category: CategoryExtension.fromString(json['category']),
      amount: json['amount'],
      currency: CurrencyExtension.fromString(json['currency']),
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category
          .toString()
          .split('.')
          .last, // Assuming this is an enum
      'amount': amount,
      'currency': currency
          .toString()
          .split('.')
          .last, // Assuming this is an enum
      'date': date.toIso8601String(), // Convert DateTime to ISO-8601 String
      'description': description,
    };
  }

  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'name': name,
      'category': category.toString().split('.').last, // Assuming this is an enum
      'amount': amount,
      'currency': currency.toString().split('.').last, // Assuming this is an enum
      'date': date.toIso8601String(), // Convert DateTime to ISO-8601 String
      'description': description,
      'is_new': isNew ? 1 : 0,
      'is_updated': isUpdated ? 1 : 0,
      'is_deleted': isDeleted ? 1 : 0,
      'is_synced': isSynced ? 1 : 0,
    };
  }

  // Create an Expense object from a map with sync flags
  static Expense fromLocalMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      name: map['name'],
      category: CategoryExtension.fromString(map['category']),
      amount: map['amount'],
      currency: CurrencyExtension.fromString(map['currency']),
      date: DateTime.parse(map['date']),
      description: map['description'],
      isNew: map['is_new'] == 1,
      isUpdated: map['is_updated'] == 1,
      isDeleted: map['is_deleted'] == 1,
      isSynced: map['is_synced'] == 1,
    );
  }
}