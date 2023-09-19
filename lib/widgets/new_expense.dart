import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: lastDate);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _changeCategory(Category? cat) {
    if (cat == null) return;
    setState(() {
      _selectedCategory = cat;
    });
  }

  void _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final isAmountInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text
        .trim()
        .isEmpty ||
        isAmountInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                icon: const Icon(Icons.error),
                title: const Text("Invalid input"),
                content: const Text("Valid input required"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Try again"))
                ],
              ));
      return;
    } else {
      final expense = Expense(
          title: _titleController.text,
          amount: int.parse(_amountController.text),
          created: _selectedDate!.toLocal(),
          category: _selectedCategory);
      widget.onAddExpense(expense);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(label: Text("Title")),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    maxLength: 30,
                    decoration: const InputDecoration(
                        label: Text("Amount"), prefixText: "\$ "),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDate == null
                            ? "No date selected"
                            : formatter.format(_selectedDate!)),
                        IconButton(
                            onPressed: _showDatePicker,
                            icon: const Icon(Icons.calendar_month))
                      ],
                    ))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map((category) =>
                        DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase())))
                        .toList(),
                    onChanged: (category) {
                      _changeCategory(category);
                    }),
                const Spacer(),
                ElevatedButton(
                    onPressed: _submitData, child: const Text("Save")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"))
              ],
            )
          ],
        ));
  }
}
