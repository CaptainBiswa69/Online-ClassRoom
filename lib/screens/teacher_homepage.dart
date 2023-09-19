import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/screens/teacher_classroom/add_class.dart';
import 'package:online_classroom_app/screens/teacher_classroom/classes_tab.dart';
import 'package:online_classroom_app/services/auth.dart';
import 'package:provider/provider.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final user = Provider.of<CustomUser?>(context);
    var account = getAccount(user!.uid);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          "My Classes",
          style: TextStyle(
              color: Colors.black, fontFamily: "Roboto", fontSize: 22),
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Welcome, ${account!.firstName as String}",
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black87,
              size: 30,
            ),
            onPressed: () async {
              await auth.signOut();
            },
          ),
        ],
      ),
      body: ClassesTab(account),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => const AddClass(),
              ))
              .then((_) => setState(() {}));
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
