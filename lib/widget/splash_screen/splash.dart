import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fourth_app/widget/expenses/expenses.dart';

import 'package:fourth_app/widget/login/login_options.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    setState(() {
      Timer(const Duration(seconds: 3), () {
        if (FirebaseAuth.instance.currentUser != null) {
          // Future<List<Expense>> expenseList = getExpenses();
          // expenseList.then(
          //   (value) {
          //     List<Expense> expenseList = value;
          //     log('Expenses List:');
          //     for (var expense in expenseList) {
          //       log('ID: ${expense.id}');
          //       log('Title: ${expense.title}');
          //       log('Price: ${expense.price}');
          //       log('Date: ${expense.date}');
          //       log('Category: ${expense.category}');
          //       log('---------------------');
          //     }
          //     log(expenseList.take(1).toString());
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const Expenses(),
          //         ));
          //   },
          // );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Expenses(),
              ));
        } else {
          Navigator.pushReplacement(
              //Expenses()=> home page
              context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset('assets/animation/animation.json'))),
    );
  }
}
