import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/screens/student_classroom/add_class.dart';
import 'package:online_classroom_app/screens/student_classroom/classes_tab.dart';
import 'package:online_classroom_app/screens/student_classroom/timeline_tab.dart';
import 'package:online_classroom_app/screens/student_classroom/wall_tab.dart';
import 'package:online_classroom_app/services/auth.dart';
import 'package:provider/provider.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final user = Provider.of<CustomUser?>(context);
    var account = getAccount(user!.uid);

    final tabs = [WallTab(), TimelineTab(), ClassesTab()];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          "Online Classroom",
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
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'ClassWork',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Classes",
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
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
