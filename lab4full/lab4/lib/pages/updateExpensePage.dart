import 'package:flutter/material.dart';
import '../domain/category.dart';
import '../domain/Expense.dart';
import '../domain/currency.dart';

class UpdatePage extends StatefulWidget {
  final Function(Expense, Expense) onUpdateExpense;
  final Expense expenseToUpdate;

  UpdatePage({required this.onUpdateExpense, required this.expenseToUpdate});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  late Category selectedCategory;
  late Currency selectedCurrency;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize the input fields with the data from the expense to update
    _nameController.text = widget.expenseToUpdate.name;
    _amountController.text = widget.expenseToUpdate.amount.toString();
    _descriptionController.text = widget.expenseToUpdate.description;
    selectedCategory = widget.expenseToUpdate.category;
    selectedCurrency = widget.expenseToUpdate.currency;
    selectedDate = widget.expenseToUpdate.date;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Update Expense'),
      ),
      body: SingleChildScrollView(
      child:Column(
        children: <Widget>[
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Expense Name'),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Expense Amount'),
            keyboardType: TextInputType.number,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Expense Date'),
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          DropdownButton<Category>(
            value: selectedCategory,
            items: Category.values.map((category) {
              return DropdownMenuItem<Category>(
                value: category,
                child: Text(category.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
          DropdownButton<Currency>(
            value: selectedCurrency,
            items: Currency.values.map((currency) {
              return DropdownMenuItem<Currency>(
                value: currency,
                child: Text(currency.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCurrency = value!;
              });
            },
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              final amount = double.tryParse(_amountController.text);
              final description = _descriptionController.text;

              if (name.isNotEmpty && amount != null) {
                final updatedExpense = Expense(
                  id: widget.expenseToUpdate.id,
                  name: name,
                  category: selectedCategory,
                  amount: amount,
                  currency: selectedCurrency,
                  date: selectedDate,
                  description: description,
                );

                widget.onUpdateExpense(widget.expenseToUpdate, updatedExpense);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update Expense'),
          ),
        ],
      ),
      ),
    );
  }
}
