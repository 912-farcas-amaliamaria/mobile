import 'package:flutter/material.dart';
import 'package:lab2/repository/ExpensesRepo.dart';


import 'addExpensePage.dart';
import 'ListExpenses.dart';
import 'domain/Expense.dart';

class ExpensesPage extends StatefulWidget {
  final String title;
  final ExpensesRepository repo;
  const ExpensesPage({super.key, required this.title, required this.repo});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late List<Expense> expenses;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      var fetchedExpenses = await widget.repo.getExpenses(); // Assuming this method is defined in your repository
      setState(() {
        expenses = fetchedExpenses;
      });
    } catch (e) {
      print("error"+e.toString());
    }
  }

  void addExpense(Expense expense) async {
    try {
      await widget.repo.addExpense(expense); // Add to database
      setState(() {
        expenses.add(expense);
        expenses.sort((a, b) => b.date.compareTo(a.date));
      });
    } catch (e) {
      // Handle exceptions
    }
  }

  void updateExpense(Expense newExpense) async {
    try {
      await widget.repo.updateExpense(newExpense); // Update in database
      setState(() {
        final index = expenses.indexWhere((expense) => expense.id == newExpense.id); // Assuming each expense has a unique ID
        if (index != -1) {
          expenses[index] = newExpense;
          expenses.sort((a, b) => b.date.compareTo(a.date));
        }
      });
    } catch (e) {
      // Handle exceptions
    }
  }

  void deleteExpense(Expense expense) async {
    try {
      await widget.repo.deleteExpense(expense); // Delete from database
      setState(() {
        expenses.removeWhere((e) => e.id == expense.id); // Assuming each expense has a unique ID
      });
    } catch (e) {
      // Handle exceptions
    }
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
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}