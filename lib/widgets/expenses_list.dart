import 'package:expense_tracker/constants/dimens.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: mainPadding,
      child: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
          direction: DismissDirection.endToStart,
          key: ValueKey(expenses[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            alignment: Alignment.centerRight,
            margin: secondaryPadding,
            child: TextButton(
              onPressed: () {},
              child: const Icon(Icons.remove, color: Colors.white,),
            ),
          ),
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
          child: ExpenseItem(
            expenses[index],
          ),
        ),
      ),
    );
  }
}
