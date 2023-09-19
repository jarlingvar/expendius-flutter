import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';


class ToggleView extends StatelessWidget {
  const ToggleView(
      {super.key, required this.onToggle, required this.currentView});

  final void Function(ExpenseVisibility visibility) onToggle;
  final ExpenseVisibility currentView;

  @override
  Widget build(BuildContext context) {
    final currentIndex = ExpenseVisibility.values.indexOf(currentView);
    const allViews = ExpenseVisibility.values;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: currentIndex >= 1 ? () {onToggle(allViews[currentIndex - 1]);} : null,
            icon: const Icon(Icons.arrow_back)),
        DropdownButton(
            value: currentView,
            iconSize: 0,
            alignment: Alignment.center,
            items: ExpenseVisibility.values
                .map((category) =>
                DropdownMenuItem(
                    value: category,
                    child: Text(category.value, style: const TextStyle(fontSize: 16))))
                .toList(),
            onChanged: (view) {
              onToggle(view!);
            }),
        IconButton(
            onPressed: currentIndex < allViews.length - 1 ? () {onToggle(allViews[currentIndex + 1]);} : null,
            icon: const Icon(Icons.arrow_forward)),
      ],
    );
  }
}
