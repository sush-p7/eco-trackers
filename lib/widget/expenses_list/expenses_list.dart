import 'package:flutter/material.dart';
import 'package:fourth_app/models/expense.dart';
import 'package:fourth_app/widget/expenses_list/expenses_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.removeExpenses});
  final List<Expense> expenses;
  final void Function(Expense expense) removeExpenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(expenses[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(.75),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          onDismissed: (direction) {
            removeExpenses(expenses[index]);
          },
          child: ExpensesItem(expense: expenses[index])),
    );
  }
}
