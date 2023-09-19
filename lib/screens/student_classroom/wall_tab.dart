import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/announcements.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/screens/student_classroom/announcement_page.dart';
import 'package:provider/provider.dart';

class WallTab extends StatefulWidget {
  @override
  _WallTabState createState() => _WallTabState();
}

class _WallTabState extends State<WallTab> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    var account = getAccount(user!.uid);
    if (notificationList.isEmpty) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: const Center(
              child: Text(
            "No notifications",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey, fontFamily: "Roboto", fontSize: 22),
          )));
    }

    return ListView.builder(
        itemCount: notificationList.length,
        itemBuilder: (context, int index) {
          if ((notificationList[index].classroom as ClassRooms)
              .students
              .contains(account)) {
            return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.
                key: UniqueKey(),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    notificationList.removeAt(index);
                  });

                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification dismissed')));
                },
                child: InkWell(
                    onTap: () {
                      notificationList[index].active = false;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AnnouncementPage(
                              announcement: notificationList[index])));
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 0.05)
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "${notificationList[index].user.userDp}"),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notificationList[index]
                                                        .user
                                                        .firstName +
                                                    " " +
                                                    notificationList[index]
                                                        .user
                                                        .lastName,
                                                style: const TextStyle(),
                                              ),
                                              Text(
                                                notificationList[index]
                                                    .dateTime,
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ]),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    margin: const EdgeInsets.only(
                                        left: 15, top: 5, bottom: 10),
                                    child: Text(notificationList[index].title,
                                        style: notificationList[index].active
                                            ? const TextStyle(
                                                fontWeight: FontWeight.bold)
                                            : null))
                              ],
                            )))));
          } else {
            return Container();
          }
        });
  }
}
