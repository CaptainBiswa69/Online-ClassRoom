import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/screens/teacher_classroom/class_room_page.dart';

class ClassesTab extends StatefulWidget {
  final Account? classTeacher;

  const ClassesTab(this.classTeacher, {super.key});

  @override
  State<ClassesTab> createState() => _ClassesTabState();
}

class _ClassesTabState extends State<ClassesTab> {

  @override
  Widget build(BuildContext context) {
    List _classRoomList = classRoomList.where((i) => i.creator == widget.classTeacher).toList();

    return ListView.builder(
        itemCount: _classRoomList.length,
        itemBuilder: (context, int index) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ClassRoomPage(
                  uiColor: _classRoomList[index].uiColor,
                  classRoom: _classRoomList[index],
                ))),
            child: Stack(
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   fit: BoxFit.cover, image: classRoomList[index].bannerImg,),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    color: _classRoomList[index].uiColor,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 30),
                  width: 220,
                  child: Text(
                    _classRoomList[index].className,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 58, left: 30),
                  child: Text(
                    _classRoomList[index].description,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        letterSpacing: 1),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 80, left: 30),
                  child: Text(
                    _classRoomList[index].creator.firstName! + " " + _classRoomList[index].creator.lastName!,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                        letterSpacing: 1),
                  ),
                )
              ],
            ),
          );
        });
  }
}
