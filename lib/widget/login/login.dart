import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widget/expenses/expenses.dart';
import 'package:expense_tracker/widget/login/signup.dart';
import 'package:expense_tracker/widget/login/verify.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  Future<List<Expense>>? _expenseLists;

  void loginuser() async {
    String email = _email.text.trim();
    String password = _password.text.trim();
    if (email == "" || password == "") {
      log('error');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please enter Valid Email and Password')));
    } else {
      try {
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        // if (!mounted) return;
        if (credential.user != null) {
          // Navigator.popUntil(context, (route) => route.isFirst);
          _expenseLists = getExpenses();
          _expenseLists!.then(
            (value) {
              List<Expense> expenseList = value;
              log(expenseList.take(1).toString());
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Expenses(),
                    ),
                    (route) => false);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const Expenses(),
                //     ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerifyEmail(),
                    ));
              }
            },
          );
        }
      } on FirebaseAuthException catch (ex) {
        log(ex.code.toString());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(ex.message.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final width = (MediaQuery.of(context).size.width);

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            // color: Colors.black,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: width < 600
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeInUp(
                                duration: const Duration(milliseconds: 1200),
                                child: Text(
                                  "Login to your account",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.grey[700]),
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1200),
                                  child: makeInput(
                                      label: "Email",
                                      context: context,
                                      controller: _email)),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1300),
                                  child: makeInput(
                                      label: "Password",
                                      obscureText: true,
                                      context: context,
                                      controller: _password)),
                            ],
                          ),
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Container(
                                padding: const EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 60,
                                  onPressed: () => loginuser(),
                                  color: isDarkMode
                                      ? kDarkColorScheme.secondaryContainer
                                      : kColorScheme.secondary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1500),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Don't have an account?"),
                                TextButton(
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupPage()));
                                  },
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/background.png'),
                                fit: BoxFit.cover)),
                      ))
                ],
              )
            : Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1000),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1200),
                                  child: Text(
                                    "Login to your account",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.grey[700]),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: <Widget>[
                                FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    child: makeInput(
                                        label: "Email",
                                        context: context,
                                        controller: _email)),
                                FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1300),
                                    child: makeInput(
                                        label: "Password",
                                        obscureText: true,
                                        context: context,
                                        controller: _password)),
                              ],
                            ),
                          ),
                          FadeInUp(
                              duration: const Duration(milliseconds: 1400),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 3, left: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  child: MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: () => loginuser(),
                                    color: isDarkMode
                                        ? kDarkColorScheme.secondaryContainer
                                        : kColorScheme.secondary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                              )),
                          FadeInUp(
                              duration: const Duration(milliseconds: 1500),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text("Don't have an account?"),
                                  TextButton(
                                    child: Text(
                                      "Sign up",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignupPage()));
                                    },
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/background.png'),
                                  fit: BoxFit.cover)),
                        ))
                  ],
                ),
              ),
      ),
    );
  }

  Widget makeInput(
      {label,
      obscureText = false,
      required BuildContext context,
      required TextEditingController controller}) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: isDarkMode ? Colors.white : Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
