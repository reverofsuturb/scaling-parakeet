import "package:cloud_firestore/cloud_firestore.dart";
import "package:dartpractice/helper/helper_function.dart";
import "package:dartpractice/service/database_service.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 101, 88, 221),
            title: const Text(
              "Search",
              style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            body: Column(children: [
              Container(
                  color: const Color.fromARGB(255, 101, 88, 221),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(children: [
                    Expanded(
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            (
                              border: InputBorder.none,
                              hintText: "Search groups...",
                              hintStyle:
                                  TextStyle(color: Colors.white, fontSize: 16)
                            ),
                          ),
                        ), GestureDetector(onTap: () {
                      initiateSearchMethod();
                    }, child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(40)), child: const Icon(Icons.search, color: Colors.white,),),],),), isLoading ? Center(child: CircularProgressIndicator(color: const Color.fromARGB(255, 101, 88, 221),) : groupList(),], ), ); }}

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searchController.text).then((snapshot) {
isLoading = false;
hasUserSearched = true;
      });
    };
  }
