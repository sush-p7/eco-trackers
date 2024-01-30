import 'dart:async';
import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fourth_app/main.dart';
import 'package:fourth_app/widget/expenses/expenses.dart';
import 'package:fourth_app/widget/login/login_options.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (timer) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 30));
      setState(() => canResendEmail = true);
    } catch (e) {
      log(e.toString());
    }
  }

  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return isEmailVerified
        ? const Expenses()
        : Scaffold(
            appBar: AppBar(title: const Text("verify email")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Email has been sent to the specified email address please verify the email address!!!",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1500),
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: isDarkMode
                                  ? Border.all(color: Colors.white)
                                  : Border.all(color: Colors.black)),
                          child: MaterialButton(
                            minWidth: 150,
                            height: 60,
                            onPressed: () {
                              if (canResendEmail) {
                                sendVerificationEmail;
                              }
                            },
                            color: isDarkMode
                                ? kDarkColorScheme.secondaryContainer
                                : kColorScheme.secondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: const Text(
                              "Resend Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1500),
                        child: MaterialButton(
                          minWidth: 150,
                          height: 60,
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ));
                          },
                          shape: RoundedRectangleBorder(
                            side: isDarkMode
                                ? const BorderSide(color: Colors.white)
                                : const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            ),
          );
  }
}
