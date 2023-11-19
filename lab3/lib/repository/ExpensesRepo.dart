import 'package:postgres/postgres.dart';
import '../domain/Expense.dart';

class ExpensesRepository {
  final PostgreSQLConnection _connection;

  ExpensesRepository(this._connection);

  Future<void> openConnection() async {
    await _connection.open();
  }

  Future<void> closeConnection() async {
    await _connection.close();
  }

  // Create an Expense
  Future<void> addExpense(Expense expense) async {
    // Assuming your Expense model has properties that map to your database columns
    var query = 'INSERT INTO expenses (name, category, amount, currency, date, description) VALUES (@name, @category, @amount, @currency, @date, @description)';
    await _connection.query(query, substitutionValues: {
      'name': expense.name,
      'category': expense.category.name.toString(), // Assuming category is an enum or similar
      'amount': expense.amount,
      'currency': expense.currency.name.toString(), // Assuming currency is an enum or similar
      'date': expense.date.toIso8601String(),
      'description': expense.description,
    });
  }

  // Read all Expenses
  Future<List<Expense>> getExpenses() async {
    var query = 'SELECT * FROM expenses';
    var result = await _connection.mappedResultsQuery(query);
    return result.map((json) => Expense.fromJson(json)).toList();
    // Expense.fromMap will need to be implemented in your Expense model
  }

  // Update an Expense
  Future<void> updateExpense(Expense expense) async {
    var query = 'UPDATE expenses SET name = @name, category = @category, amount = @amount, currency = @currency, date = @date, description = @description WHERE id = @id';
    await _connection.query(query, substitutionValues: {
      'id': expense.id,
      'name': expense.name,
      'category': expense.category.name.toString(), // Assuming category is an enum or similar
      'amount': expense.amount,
      'currency': expense.currency.name.toString(),
      'date': expense.date.toIso8601String(),
      'description': expense.description,
    });
  }

  // Delete an Expense
  Future<void> deleteExpense(Expense expense) async {
    var query = 'DELETE FROM expenses WHERE id = @id';
    await _connection.query(query, substitutionValues: {
      'id': expense.id,
    });
  }
}
