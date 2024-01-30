// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fourth_app/widget/chart/chart.dart';
import 'package:fourth_app/widget/expenses_list/expenses_list.dart';
import 'package:fourth_app/models/expense.dart';
import 'package:fourth_app/widget/login/login.dart';
import 'package:fourth_app/widget/new_expense/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({
    super.key,
  });
  // List<Expense> expenselist;

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  //List<Expense> _expenseList = [];
  @override
  void initState() {
    ////: implement initState
    super.initState();
    getExpenses().then((value) {
      setState(() {
        _registerexpenses = value;
      });
    });
    // Future<List<Expense>> expenseList = getExpenses();
    // expenseList.then((value) {
    //   _registerexpenses = value;
    //   log('Expense');
    //   // _registerexpenses..addAll(expenseList);
    //   // log(expenseList.take(1).toString());
    // });
    // setState(() {});
  }

  // List<Expense> firebaseexpensesList = [];
  // final Future<List<Expense>> _registerexpensesfirebase = getExpenses();

  List<Expense> _registerexpenses = [];
  // [
  //   Expense(
  //       title: 'Flutter',
  //       category: Category.work,
  //       price: 500.20,
  //       date: DateTime.now()),
  //   Expense(
  //       category: Category.work,
  //       price: 500.20,
  //       date: DateTime.now(),
  //       title: 'full stack')
  // ];

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  void getexpense() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("expenses").get();
    log(snapshot.docs.toString());
    for (var doc in snapshot.docs) {
      log(doc.data().toString());
    }
  }

  void _addExpense(Expense expense) async {
    Map<String, dynamic> data = expense.toMap();
    data.addEntries([
      MapEntry('userid', FirebaseAuth.instance.currentUser!.uid.toString())
    ]);
    setState(() {
      _registerexpenses.add(expense);
      _firebaseFirestore.collection('expenses').add(data);
    });
  }

  void deleteFromFirestore(Expense expense) async {
    try {
      await Future.delayed(const Duration(seconds: 10));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('id', isEqualTo: expense.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('expenses')
            .doc(documentId)
            .delete();
        log('Expense deleted successfully');
      } else {
        log('Expense not found');
      }
    } catch (e) {
      log('Error deleting expense: $e');
    }
  }

  void _removeExpense(Expense expense) async {
    final expenseInndex = _registerexpenses.indexOf(expense);
    // var collection = await FirebaseFirestore.instance.collection('expenses');
    // var snapshort= collection
    //       .where('id', isEqualTo: expense.id)
    //       .get();
    //  await   snapshort.doc()
    deleteFromFirestore(expense);
    setState(() {
      _registerexpenses.remove(expense);

      log(expense.id);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registerexpenses.insert(expenseInndex, expense);
              });
            }),
        content: const Text('Expenses removed')));
  }

  void _openAddExpenseOverlay() {
    log(FirebaseAuth.instance.currentUser!.toString());
    // Create
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          // getexpense();
          return NewExpense(
            addOnExpense: _addExpense,
          );
        });
  }

  void logout() async {
    AlertDialog(
      title: const Text('logout'),
      content: const Text("Are you sure you want to log out"),
      actions: [
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.popUntil(context, (route) => route.isFirst);

            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return const LoginPage();
              },
            ));
          },
          child: const Text('Yes'),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // _registerexpensesfirebase.then(
    //   (value) {
    //     List<Expense> firebaseexpensesList = value;
    //     log("thi is test " + firebaseexpensesList.length.toString());
    //   },
    // );

    final width = (MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);
    Widget mainContent =
        const Center(child: Text("No Expense Found , Try Some Adding One"));
    if (_registerexpenses.isNotEmpty) {
      mainContent = ExpenseList(
        // expenses: _registerexpenses,
        expenses: _registerexpenses,
        removeExpenses: _removeExpense,
      );
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      // DeviceOrientation.portraitDown,
    ]);
    return PopScope(
      // onWillPop: () async =>false,
      canPop: false,

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
            IconButton(
              onPressed: () {
                showDialog(
                    builder: (context) {
                      // ignore: avoid_unnecessary_containers
                      return Container(
                        child: AlertDialog(
                          title: const Text('logout'),
                          content:
                              const Text("Are you sure you want to log out"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);

                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return const LoginPage();
                                  },
                                ));
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('No'))
                          ],
                        ),
                      );
                    },
                    context: context);
              },
              icon: const Icon(Icons.exit_to_app),
            )
          ],
          title: const Text('Expense Tracker'),
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registerexpenses),
                  Expanded(child: mainContent)
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registerexpenses)),
                  Expanded(child: mainContent)
                ],
              ),
      ),
    );
  }
}
