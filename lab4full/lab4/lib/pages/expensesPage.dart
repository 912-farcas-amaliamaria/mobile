import 'package:flutter/material.dart';

import '../service/DatabaseHelper.dart';
import '../service/expenseService.dart';
import 'addExpensePage.dart';
import 'ListExpenses.dart';
import '../domain/Expense.dart';

class ExpensesPage extends StatefulWidget {
  final String title;

  const ExpensesPage({super.key, required this.title});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final _service = ExpenseService();
  final _dbHelper = DatabaseHelper.instance; // Instance of DatabaseHelper
  List<Expense> expenses = [];

  void loadExpenses() async {
    try {
      _service.getExpenses();
      //_dbHelper.deleteAllExpensesAndResetIndex();
      // Fetch expenses from local database
      var fetchedExpenses = await _dbHelper.getExpenses();
      setState(() {
        expenses = fetchedExpenses;
      });
      print("sync");
      // Optionally, sync with server and update UI
      await _service.syncWithServer();
      var updatedExpenses = await _dbHelper.getExpenses();
      setState(() {
        expenses = updatedExpenses;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void addExpense(Expense expense) async {
    try {
      // Add expense to local database and update UI
      expense.isNew = true;
      await _dbHelper.createExpense(expense);
      setState(() {
        expenses.add(expense);
        expenses.sort((a, b) => b.date.compareTo(a.date));
      });

      // Sync with server
      await _service.syncWithServer();
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateExpense(Expense newExpense) async {
    try {
      newExpense.isUpdated = true;
      await _dbHelper.updateExpense(newExpense);
      setState(() {
        final index = expenses.indexWhere((e) => e.id == newExpense.id);
        if (index != -1) {
          expenses[index] = newExpense;
          expenses.sort((a, b) => b.date.compareTo(a.date));
        }
      });

      // Sync with server
      await _service.syncWithServer();
    } catch (e) {
      print("Error: $e");
    }
  }

  void deleteExpense(Expense expense) async {
    try {
      // Delete expense from local database and update UI
      expense.isDeleted = true;
      await _dbHelper.deleteExpense(expense);
      setState(() {
        expenses.removeWhere((e) => e.id == expense.id);
      });

      // Sync with server
      await _service.syncWithServer();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    expenses.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ExpensesList(
        expenses: expenses,
        onDeleteExpense: deleteExpense,
        onUpdateExpense: updateExpense,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return AddPage(addExpense);
          }));
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}