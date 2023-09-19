import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/screens/teacher_classroom/student_work_page.dart';
import 'package:online_classroom_app/widgets/profile_tile.dart';

class PeopleTab extends StatefulWidget {
  final ClassRooms classRoom;
  final Color uiColor;

  const PeopleTab({super.key, required this.classRoom, required this.uiColor});

  @override
  State<PeopleTab> createState() => _PeopleTabState();
}

class _PeopleTabState extends State<PeopleTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 15, left: 15, bottom: 10),
          child: Text(
            "Students",
            style: TextStyle(
                fontSize: 30, color: widget.uiColor, letterSpacing: 1),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15),
          width: MediaQuery.of(context).size.width - 30,
          height: 2,
          color: widget.uiColor,
        ),
        ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: widget.classRoom.students.length,
            itemBuilder: (context, int index) {
              return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => StudentWorkPage(
                          student:  widget.classRoom.students[index],
                          classRoom: widget.classRoom
                      ))),
                  child: Profile(
                      user: widget.classRoom.students[index]
                  ));
            })
      ],
    );
  }
}
