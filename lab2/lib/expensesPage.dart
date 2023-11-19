import 'package:flutter/material.dart';
import 'package:lab2/domain/Category.dart';
import 'package:lab2/domain/currency.dart';


import 'addExpensePage.dart';
import 'ListExpenses.dart';
import 'domain/Expense.dart';

class ExpensesPage extends StatefulWidget {
  final String title;

  const ExpensesPage({super.key, required this.title});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<Expense> expenses = [Expense("ap", Category.FOOD, 98, Currency.EUR, DateTime.now(), "ddd"), Expense("apa", Category.FOOD, 98, Currency.EUR,DateTime(2014, 5, 7) , "ddd")];

  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
      expenses.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void updateExpense(Expense expense, Expense newExpense) {
    setState(() {
      final index = expenses.indexWhere((expense) => expense == expense);
      if (index != -1) {
        expenses[index] = newExpense;
        expenses.sort((a, b) => b.date.compareTo(a.date));
      }
    });
  }

  void deleteExpense(Expense expense) {
    setState(() {
      expenses.remove(expense);
    });
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