import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/screens/export_attendance.dart';
import 'package:online_classroom_app/screens/student_classroom/people_tab.dart';

import '../student_classroom/classwork_tab.dart';
import '../student_classroom/stream_tab.dart';

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
    String className = widget.classRoom.className;
    Color uiColor = widget.uiColor;

    final tabs = [
      StreamTab(className: className, uiColor: uiColor),
      ClassWork(className),
      PeopleTab(classRoom: widget.classRoom, uiColor: uiColor)
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: uiColor,
        elevation: 0.5,
        title: Text(
          className,
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
      floatingActionButton: FloatingActionButton(
        heroTag: "Attendance",
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => ExportAttendance(
                  classRoom: widget.classRoom,
                ),
              ))
              .then((_) => setState(() {}));
        },
        backgroundColor: widget.uiColor,
        child: const Icon(Icons.person_off, color: Colors.white, size: 32),
      ),
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
        selectedItemColor: uiColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
