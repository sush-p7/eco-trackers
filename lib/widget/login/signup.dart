// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/widget/login/login.dart';
import 'package:expense_tracker/widget/login/verify.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _repassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _repassword.dispose();
  }

  void createAccount() async {
    String email = _email.text.trim();
    String password = _password.text.trim();
    String confirmpass = _repassword.text.trim();
    if (email == "" || password == "" || confirmpass == "") {
      log('error');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter Valid Input')));
    } else if (confirmpass != password) {
      log('pass unmatched');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password does not match')));
    } else {
      //create a new account
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (userCredential.user != null) {
          // Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VerifyEmail(),
              ));
        }
      } on FirebaseAuthException catch (ex) {
        log(ex.code.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(ex.code.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Text(
                        "Create an account, It's free",
                        style: TextStyle(
                            fontSize: 15,
                            color:
                                isDarkMode ? Colors.white : Colors.grey[700]),
                      )),
                ],
              ),
              Column(
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
                  FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: makeInput(
                          label: "Confirm Password",
                          obscureText: true,
                          context: context,
                          controller: _repassword)),
                ],
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
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () => createAccount(),
                      color: isDarkMode
                          ? kDarkColorScheme.secondaryContainer
                          : kColorScheme.secondary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  )),
              FadeInUp(
                  duration: const Duration(milliseconds: 1600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account?"),
                      TextButton(
                        child: Text(
                          " Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                      ),
                    ],
                  )),
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
