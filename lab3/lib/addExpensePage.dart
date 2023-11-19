import 'package:flutter/material.dart';


import 'domain/category.dart';
import 'domain/Expense.dart';
import 'domain/currency.dart';

class AddPage extends StatefulWidget {
  final Function(Expense) onAddExpense;

  AddPage(this.onAddExpense);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Category selectedCategory = Category.OTHER;
  Currency selectedCurrency = Currency.EUR;
  DateTime selectedDate = DateTime.now();

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
        title: const Text('Add Expense'),
      ),
      body: SingleChildScrollView(
      child: Column(
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
                final newExpense = Expense(1, name, selectedCategory, amount,
                    selectedCurrency, selectedDate, description);

                widget.onAddExpense(newExpense);

                Navigator.of(context).pop();
              }
            },
            child: const Text('Add Expense'),
          ),
        ],
      ),
      ),
    );
  }
}
