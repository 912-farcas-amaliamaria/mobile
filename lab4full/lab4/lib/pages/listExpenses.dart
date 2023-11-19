import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab2/pages/updateExpensePage.dart';


import '../domain/Expense.dart';

class ExpensesList extends StatefulWidget {
  final List<Expense> expenses;
  final Function(Expense) onDeleteExpense;
  final Function(Expense, Expense) onUpdateExpense;

  const ExpensesList({
    required this.expenses,
    required this.onDeleteExpense,
    required this.onUpdateExpense,
    Key? key,
  }) : super(key: key);

  @override
  _ExpensesListState createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {

  void _showDeleteConfirmationDialog(Expense expense) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Expense'),
          content: Text('Are you sure you want to delete this expense?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onDeleteExpense(expense); // Delete the expense
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.expenses.length,
      itemBuilder: (context, index) {
        final expense = widget.expenses[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: [
              // First Row: Name, Category, Amount, Currency, Edit Button
              Row(
                children: [
                  Expanded(
                    child: Text('${expense.name}, ${expense.category.name}', style: const TextStyle(fontSize: 16), ),
                  ),
                  Text(
                    '${expense.amount.toStringAsFixed(2)} ${expense.currency.name}', style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Handle the edit action
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            // Navigate to the UpdatePage and pass the expense to edit
                            return UpdatePage(
                              expenseToUpdate: expense,
                              onUpdateExpense: widget.onUpdateExpense,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Second Row: Description
              Row(
                children: [
                  Expanded(
                    child: Text(expense.description),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Handle the delete action
                      _showDeleteConfirmationDialog(expense);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
