import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/Expense.dart';
import 'DatabaseHelper.dart';

class ExpenseService {
  final String baseUrl = "http://192.168.0.106:8080/api/expense";

  // Create (POST)
  Future<void> createExpense(Expense expenseData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/add"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expenseData.toLocalMap()),
      );
      if (response.statusCode != 200) {
        // Handle server-side errors
        throw Exception('Failed to create expense. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or unexpected errors
      throw Exception('Failed to create expense. Error: $e');
    }
  }

  // Read (GET)
  Future<List<Expense>> getExpenses() async {
    try {
      print("all");
      final response = await http.get(Uri.parse("$baseUrl/all"));
      if (response.statusCode == 200) {
        final List<dynamic> expensesJson = jsonDecode(response.body);
        return expensesJson.map((json) => Expense.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load expenses. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load expenses. Error: $e');
    }
  }

  // Update (PUT)
  Future<void> updateExpense(Expense expenseData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expenseData.toLocalMap()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update expense. Server responded with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update expense. Error: $e');
    }
  }

  // Delete (DELETE)
  Future<void> deleteExpense(Expense expenseData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expenseData.toLocalMap()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete expense. Server responded with message: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete expense. Error: $e');
    }
  }

  Future<void> syncWithServer() async {
    final dbHelper = DatabaseHelper.instance;

    try {
      // 1. Get local changes
      List<Map<String, dynamic>> localExpenseMaps = await dbHelper.getUnsyncedExpenses();
      List<Expense> localExpenses = localExpenseMaps.map((map) => Expense.fromLocalMap(map)).toList();
      print("sync");
      // 2. Upload local changes to server
      for (var expense in localExpenses) {
        print(expense.toLocalMap());
        if (expense.isNew) {
          await createExpense(expense);
        } else if (expense.isUpdated) {
          await updateExpense(expense);
        } else if (expense.isDeleted) {
          await deleteExpense(expense);
        }
        print("synced");
        // Mark the expense as synced in the local database
        await dbHelper.markAsSynced(expense);
      }

      // 3. Fetch latest data from the server
      List<Expense> latestExpenses = await getExpenses();

      // 4. Update local database with the latest data
      await dbHelper.updateLocalDatabase(latestExpenses);

    } catch (e) {
      // Handle errors (e.g., network errors, server errors)
      print('Error during sync: $e');
      // Optionally, rethrow the error or handle it as needed
    }
  }
}
