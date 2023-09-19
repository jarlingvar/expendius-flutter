import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work }

Category getCategoryByName(String name) {
  return Category.values.firstWhere((element) => element.name == name);
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

enum ExpenseVisibility {
  allTime("All Time"),
  currentMonth("Current Month"),
  lastMonth("Last Month"),
  currentYear("This Year"),
  lastYear("Last Year");
  const ExpenseVisibility(this.value);
  final String value;
}

class Expense {
  Expense(
      {required this.title,
      required this.amount,
      required this.created,
      required this.category})
      : id = uuid.v4();
  Expense.fromDb({
    required this.id,
    required this.title,
    required this.amount,
    required this.created,
    required this.category
});
  final String id;
  final String title;
  final int amount;
  final DateTime created;
  final Category category;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount.toInt(),
      'created': created.millisecondsSinceEpoch,
      'category': category.name,
    };
  }

  String get formattedDate {
    return formatter.format(created);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses.where((e) => e.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (var e in expenses) {
      sum += e.amount;
    }
    return sum;
  }
}
