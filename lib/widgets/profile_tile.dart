import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/accounts.dart';

class Profile extends StatelessWidget {
  final Account user;

  const Profile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 15),
          CircleAvatar(
            backgroundImage: AssetImage(user.userDp),
          ),
          const SizedBox(
            width: 10,
          ),
          Text("${user.firstName!} ${user.lastName!}")
        ],
      ),
    );
  }
}
