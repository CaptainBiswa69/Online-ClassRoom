import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/screens/Authenticate/authenticate.dart';
import 'package:online_classroom_app/screens/student_homepage.dart';
import 'package:online_classroom_app/screens/teacher_homepage.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    // getting user from the Stream Provider
    final user = Provider.of<CustomUser?>(context);

    // logic for if logged in
    if (user != null && accountExists(user.uid)) {
      var typeOfCurrentUser = getAccount(user.uid)!.type;
      return typeOfCurrentUser == 'student'
          ? const StudentHomePage()
          : const TeacherHomePage();
    }

    // user isnt logged in
    else {
      return const Authenticate();
    }
  }
}
