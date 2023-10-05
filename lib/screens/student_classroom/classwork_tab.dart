import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/announcements.dart';
import 'package:online_classroom_app/screens/student_classroom/announcement_page.dart';

class ClassWork extends StatefulWidget {
  final String className;

  ClassWork(this.className);

  @override
  _ClassWorkState createState() => _ClassWorkState();
}

class _ClassWorkState extends State<ClassWork> {
  @override
  Widget build(BuildContext context) {
    List _classWorkList = announcementList
        .where((i) =>
            i.type == "Assignment" && i.classroom.className == widget.className)
        .toList();

    return ListView.builder(
        itemCount: _classWorkList.length,
        itemBuilder: (context, int index) {
          return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      AnnouncementPage(announcement: _classWorkList[index]))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: _classWorkList[index].classroom.uiColor),
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
                          _classWorkList[index].title,
                          style: const TextStyle(letterSpacing: 1),
                        ),
                        Text(
                          "Due " + _classWorkList[index].dueDate,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}
