
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/ExpenseRepository.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/toggle_view.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  late ExpenseRepository repo;
  final List<Expense> _registeredExpenses = [];
  final List<Expense> _visibleExpenses = [];
  ExpenseVisibility _visibleExpensesView = ExpenseVisibility.allTime;

  @override
  void initState() {
    super.initState();
    repo = ExpenseRepository();
    _updateExpenses();
  }

  void _updateExpenses() async {
    final expenses = await repo.getExpenses();
    _registeredExpenses.clear();
    _registeredExpenses.addAll(expenses);
    _updateView(_visibleExpensesView);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: _addExpense));
  }

  void _updateView(ExpenseVisibility visibility) {
    setState(() {
      final now = DateTime.now();
      _visibleExpensesView = visibility;
      _visibleExpenses.clear();
      switch (visibility) {
        case ExpenseVisibility.currentMonth:
          {
            for (var expense in _registeredExpenses) {
              if (now.year == expense.created.year &&
                  now.month == expense.created.month) {
                _visibleExpenses.add(expense);
              }
            }
          }
        case ExpenseVisibility.lastMonth:
          {
            for (var expense in _registeredExpenses) {
              if (now.year == expense.created.year &&
                  now.month == expense.created.month - 1) {
                _visibleExpenses.add(expense);
              } else if (now.year - 1 == expense.created.year &&
                  now.month == 1 &&
                  expense.created.month == 12) {
                _visibleExpenses.add(expense);
              }
            }
          }
        case ExpenseVisibility.currentYear:
          {
            for (var expense in _registeredExpenses) {
              if (now.year == expense.created.year) {
                _visibleExpenses.add(expense);
              }
            }
          }
        case ExpenseVisibility.lastYear:
          {
            for (var expense in _registeredExpenses) {
              if (now.year - 1 == expense.created.year) {
                _visibleExpenses.add(expense);
              }
            }
          }
        default:
          {
            _visibleExpenses.addAll(_registeredExpenses);
          }
      }
    });
  }

  void _addExpense(Expense expense) {
    _registeredExpenses.add(expense);
    final List<Expense> list = [];
    list.add(expense);
    repo.insertExpenses(list);
    setState(() {
      _updateView(_visibleExpensesView);
    });
  }

  void _removeExpense(Expense expense) {
    setState(() {
      _visibleExpenses.remove(expense);
      final expanseIndex = _registeredExpenses.indexOf(expense);
      _registeredExpenses.remove(expense);
      repo.delete(expense.id);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text("Expense has been removed"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expanseIndex, expense);
                final List<Expense> list = [];
                list.add(expense);
                repo.insertExpenses(list);
                _updateView(_visibleExpensesView);
              });
            }),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses yet'),
    );

    if (_visibleExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _visibleExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Expense Tracker"),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            ToggleView(
                onToggle: _updateView, currentView: _visibleExpensesView),
            Chart(expenses: _visibleExpenses),
            Expanded(
              child: mainContent,
            ),
          ],
        ));
  }
}
