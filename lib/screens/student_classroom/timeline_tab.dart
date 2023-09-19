import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/announcements.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/screens/student_classroom/announcement_page.dart';
import 'package:provider/provider.dart';

class TimelineTab extends StatefulWidget {
  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    var account = getAccount(user!.uid);

    List classWorkList = announcementList
        .where((i) =>
            i.type == "Assignment" && i.classroom.students.contains(account))
        .toList();

    return ListView.builder(
        itemCount: classWorkList.length,
        itemBuilder: (context, int index) {
          return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      AnnouncementPage(announcement: classWorkList[index]))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: classWorkList[index].classroom.uiColor),
                      child: const Icon(
                        Icons.assignment,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classWorkList[index].title,
                          style: const TextStyle(letterSpacing: 1),
                        ),
                        Text(
                          classWorkList[index].classroom.className,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "Due " + classWorkList[index].dueDate,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}
