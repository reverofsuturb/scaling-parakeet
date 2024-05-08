import "package:cloud_firestore/cloud_firestore.dart";
import "package:dartpractice/helper/helper_function.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:dartpractice/pages/auth/register_page.dart";
import "package:dartpractice/pages/home_page.dart";
import "package:dartpractice/service/auth_service.dart";
import "package:dartpractice/service/database_service.dart";
import "package:dartpractice/widgets/widgets.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                    color: (Color.fromARGB(255, 101, 88, 221))))
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text("ChikChat",
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            const Text(
                                "Login now to see what they are talking about!",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400)),
                            const SizedBox(height: 15),
                            Image.asset("assets/login.png"),
                            const SizedBox(height: 15),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Email",
                                  prefixIcon: const Icon(Icons.email,
                                      color:
                                          Color.fromARGB(255, 101, 88, 221))),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please enter a valid email";
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "Password",
                                    prefixIcon: const Icon(Icons.lock,
                                        color:
                                            Color.fromARGB(255, 101, 88, 221))),
                                validator: (val) {
                                  if (val!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                }),
                            const SizedBox(height: 20),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: const Text("Sign In",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  onPressed: () {
                                    login();
                                  },
                                )),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                  text: "Don't have an account? ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Register here",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreen(
                                                context, const RegisterPage());
                                          })
                                  ]),
                            ),
                          ],
                        )))));
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preference state
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          //saving values to shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);

          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
