import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Category { food, travel, leaisure, work }

final formater = DateFormat.yMd();
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.leaisure: Icons.movie,
  Category.work: Icons.work,
  Category.travel: Icons.flight_takeoff,
};
Future<List<Expense>> getExpenses() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('expenses')
      .where('userid',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
      .get();

  List<Expense> expenses = [];

  for (var document in snapshot.docs) {
    var data = document.data();

    // Convert data to Expense instance
    Expense expense = Expense(
      id: data["id"],
      title: data['title'],
      price: data['price'],
      date: DateTime.parse(data['date']),
      category: Category.values
          .firstWhere((e) => e.toString() == 'Category.${data['category']}'),
    );

    expenses.add(expense);
  }

  return expenses;
}

// const categoryIcon

class Expense {
  Expense(
      {required this.title,
      required this.price,
      required this.date,
      required this.category,
      required this.id});
  // : id = uuid.v4();

  final String id;
  final String title;
  final double price;
  final DateTime date;
  final Category category;

  String get formatedDate {
    return formater.format(date);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'date': date.toIso8601String(),
      'category': category.toString().split('.').last,
    };
  }
}

// bucket class
class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  double get totalExpense {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.price;
    }
    return sum;
  }
}
