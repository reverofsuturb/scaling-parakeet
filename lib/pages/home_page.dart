import 'package:dartpractice/helper/helper_function.dart';
import 'package:dartpractice/pages/auth/login_page.dart';
import 'package:dartpractice/pages/profile_page.dart';
import 'package:dartpractice/pages/search_page.dart';
import 'package:dartpractice/service/auth_service.dart';
import 'package:dartpractice/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    nextScreenReplace(context, const SearchPage());
                  },
                  icon: const Icon(
                    Icons.search,
                  ))
            ],
            elevation: 0,
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 101, 88, 221),
            title: const Text("Groups",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 29))),
        drawer: Drawer(
            child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 50),
                children: <Widget>[
              const Icon(Icons.account_circle, size: 150, color: Colors.grey),
              const SizedBox(height: 15),
              Text(userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const Divider(height: 2),
              ListTile(
                  onTap: () {},
                  selectedColor: const Color.fromARGB(255, 101, 88, 221),
                  selected: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.group),
                  title: const Text(
                    "Groups",
                    style: TextStyle(color: Colors.black),
                  )),
              ListTile(
                  onTap: () {
                    nextScreenReplace(
                        context, ProfilePage(userName: userName, email: email));
                  },
                  selectedColor: const Color.fromARGB(255, 101, 88, 221),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.group),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.black),
                  )),
              ListTile(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: const Text("Logout"),
                              content:
                                  const Text("Are you sure you want to logout"),
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                    onPressed: () async {
                                      authService.signOut().whenComplete(() {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()),
                                                (route) => false);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )),
                              ]);
                        });
                  },
                  selectedColor: const Color.fromARGB(255, 101, 88, 221),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.group),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.black),
                  )),
            ])));
  }
}
