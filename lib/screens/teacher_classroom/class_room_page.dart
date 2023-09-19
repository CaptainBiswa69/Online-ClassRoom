import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/screens/teacher_classroom/announcement_crud/add_announcement.dart';
import 'package:online_classroom_app/screens/teacher_classroom/attendance_screen.dart';
import 'package:online_classroom_app/screens/teacher_classroom/people_tab.dart';

import '../teacher_classroom/classwork_tab.dart';
import '../teacher_classroom/stream_tab.dart';

class ClassRoomPage extends StatefulWidget {
  final ClassRooms classRoom;
  final Color uiColor;

  const ClassRoomPage(
      {super.key, required this.classRoom, required this.uiColor});

  @override
  State<ClassRoomPage> createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<ClassRoomPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      StreamTab(className: widget.classRoom.className, uiColor: widget.uiColor),
      ClassWork(widget.classRoom.className),
      PeopleTab(classRoom: widget.classRoom, uiColor: widget.uiColor),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.uiColor,
        elevation: 0.5,
        title: Text(
          widget.classRoom.className,
          style: const TextStyle(
              color: Colors.white, fontFamily: "Roboto", fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Stream",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Classwork',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'People',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: widget.uiColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) =>
                        AddAnnouncement(classRoom: widget.classRoom),
                  ))
                  .then((_) => setState(() {}));
            },
            backgroundColor: widget.uiColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "Attendance",
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => TeacherAttendance(
                      classRoom: widget.classRoom,
                      uiColor: widget.uiColor,
                    ),
                  ))
                  .then((_) => setState(() {}));
            },
            backgroundColor: widget.uiColor,
            child: const Icon(
              Icons.person_off,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
