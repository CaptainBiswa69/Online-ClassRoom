import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/screens/teacher_classroom/student_work_page.dart';
import 'package:online_classroom_app/widgets/profile_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class TeacherAttendance extends StatefulWidget {
  final ClassRooms classRoom;
  final Color uiColor;
  const TeacherAttendance(
      {super.key, required this.classRoom, required this.uiColor});

  @override
  State<TeacherAttendance> createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {
  DateTime _focusedDay = DateTime.now();
  List<String> weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  DraggableScrollableController controller = DraggableScrollableController();
  @override
  Widget build(BuildContext context) {
    double bodyHeight = MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        MediaQuery.of(context).padding.top -
        (Platform.isIOS ? 35 : 2);
    double minRatio = (bodyHeight - 355) / bodyHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.uiColor,
        elevation: 0.5,
        title: const Text(
          "Attendance",
          style: TextStyle(
              color: Colors.white, fontFamily: "Roboto", fontSize: 22),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Classes")
              .doc(widget.classRoom.className)
              .collection("Attendance")
              .doc(DateFormat("dd-MM-yyy").format(_focusedDay))
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> classDates = [];
              FirebaseFirestore.instance
                  .collection("Classes")
                  .doc(widget.classRoom.className)
                  .collection("Attendance")
                  .get()
                  .then((value) {
                classDates.addAll(value.docs.map((e) => e.id).toList());
              });
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: 340,
                          child: _calendar(snapshot.data!.data() != null)),
                    ],
                  ),
                  DraggableScrollableSheet(
                      initialChildSize: 0.98,
                      maxChildSize: 0.98,
                      minChildSize: minRatio,
                      controller: controller,
                      snap: true,
                      builder: (context, scrollConttroller) {
                        return SingleChildScrollView(
                          controller: scrollConttroller,
                          physics: const ClampingScrollPhysics(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            // height: bodyHeight * 0.98,
                            constraints:
                                BoxConstraints(minHeight: bodyHeight * 0.98),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: 5,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        color: const Color(0XFFD9D9D9),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                          text: DateFormat('EEE, ')
                                              .format(_focusedDay),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24,
                                              color: Colors.red)),
                                      TextSpan(
                                          text: DateFormat('d MMM')
                                              .format(_focusedDay),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 24,
                                              color: Colors.black))
                                    ])),
                                    InkWell(
                                        onTap: () {
                                          controller.animateTo(
                                              controller.size == minRatio
                                                  ? 0.98
                                                  : minRatio,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.ease);
                                        },
                                        child: const Icon(
                                            Icons.calendar_today_outlined))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: widget.classRoom.students.length,
                                    itemBuilder: (context, int index) {
                                      List<dynamic> students = snapshot.data!
                                                  .data() ==
                                              null
                                          ? []
                                          : snapshot.data!
                                                  .data()!["presentStudents"] ??
                                              [];
                                      if (students.isEmpty &&
                                          snapshot.data!.data() != null) {
                                        FirebaseFirestore.instance
                                            .collection("Classes")
                                            .doc(widget.classRoom.className)
                                            .collection("Attendance")
                                            .doc(DateFormat("dd-MM-yyy")
                                                .format(_focusedDay))
                                            .delete();
                                      }
                                      return InkWell(
                                          onTap: () => Navigator.of(
                                                  context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) =>
                                                      StudentWorkPage(
                                                          student: widget
                                                              .classRoom
                                                              .students[index],
                                                          classRoom: widget
                                                              .classRoom))),
                                          child: Row(
                                            children: [
                                              Profile(
                                                  user: widget.classRoom
                                                      .students[index]),
                                              const Spacer(),
                                              Switch(
                                                activeColor: Colors.amber,
                                                activeTrackColor: Colors.cyan,
                                                inactiveThumbColor:
                                                    Colors.blueGrey.shade600,
                                                inactiveTrackColor:
                                                    Colors.grey.shade400,
                                                splashRadius: 50.0,
                                                value: students.contains((widget
                                                            .classRoom
                                                            .students[index]
                                                        as Account)
                                                    .uid),
                                                onChanged: (value) async {
                                                  if (snapshot.data!.data() ==
                                                      null) {
                                                    FirebaseFirestore.instance
                                                        .collection("Classes")
                                                        .doc(widget.classRoom
                                                            .className)
                                                        .collection(
                                                            "Attendance")
                                                        .doc(DateFormat(
                                                                "dd-MM-yyy")
                                                            .format(
                                                                _focusedDay))
                                                        .set({
                                                      "presentStudents":
                                                          FieldValue
                                                              .arrayUnion([
                                                        (widget.classRoom
                                                                    .students[
                                                                index] as Account)
                                                            .uid
                                                      ])
                                                    });
                                                    return;
                                                  }
                                                  if (students.contains((widget
                                                              .classRoom
                                                              .students[index]
                                                          as Account)
                                                      .uid)) {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Classes")
                                                        .doc(widget.classRoom
                                                            .className)
                                                        .collection(
                                                            "Attendance")
                                                        .doc(DateFormat(
                                                                "dd-MM-yyy")
                                                            .format(
                                                                _focusedDay))
                                                        .update({
                                                      "presentStudents":
                                                          FieldValue
                                                              .arrayRemove([
                                                        (widget.classRoom
                                                                    .students[
                                                                index] as Account)
                                                            .uid
                                                      ])
                                                    });
                                                  } else {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Classes")
                                                        .doc(widget.classRoom
                                                            .className)
                                                        .collection(
                                                            "Attendance")
                                                        .doc(DateFormat(
                                                                "dd-MM-yyy")
                                                            .format(
                                                                _focusedDay))
                                                        .update({
                                                      "presentStudents":
                                                          FieldValue
                                                              .arrayUnion([
                                                        (widget.classRoom
                                                                    .students[
                                                                index] as Account)
                                                            .uid
                                                      ])
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ));
                                    })
                              ],
                            ),
                          ),
                        );
                      })
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget _calendar(bool isClass) {
    double width = MediaQuery.of(context).size.width;
    final todayDate = DateTime.now();

    TextStyle caldendarTextStyle = Theme.of(context).textTheme.titleMedium!;
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection("Classes")
            .doc(widget.classRoom.className)
            .collection("Attendance")
            .get(),
        builder: (context, snapshot) {
          List<DateTime> classDates = [];
          if (snapshot.hasData) {
            classDates.addAll(snapshot.data!.docs
                .map((e) => DateFormat("dd-MM-yyyy").parse(e.id))
                .toList());
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.007),
            child: TableCalendar(
              shouldFillViewport: true,
              currentDay: _focusedDay,
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2050),
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekHeight: 50,
              pageAnimationCurve: Curves.ease,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = selectedDay;
                });
              },
              eventLoader: (day) {
                List events = [];
                for (var element in classDates) {
                  if (element.day == day.day) {
                    events.add("Hello");
                  }
                }
                return events;
              },
              calendarBuilders: CalendarBuilders(
                headerTitleBuilder: (context, day) {
                  return Text(
                    DateFormat('MMMM, yyyy').format(day),
                    style: caldendarTextStyle.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: widget.uiColor),
                  );
                },
                defaultBuilder: (context, day, focusedDay) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(
                      day.day.toString(),
                      style: caldendarTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 15),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: widget.uiColor.withOpacity(0.5),
                      radius: 16,
                      child: Text(
                        day.day.toString(),
                        style: caldendarTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                      ),
                    ),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                  return Align(
                    alignment: Alignment.center,
                    child: Text(day.day.toString(),
                        style: caldendarTextStyle.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.4),
                        )),
                  );
                },
                dowBuilder: (context, day) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(weekdays[day.weekday - 1],
                          style: caldendarTextStyle.copyWith(
                            fontSize: 15,
                            fontWeight: day.weekday == todayDate.weekday
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: day.weekday == todayDate.weekday
                                ? const Color(0XFF1E1E1E)
                                : const Color(0XFF1E1E1E).withOpacity(0.6),
                          )),
                      const SizedBox(
                        height: 17,
                      ),
                      Container(
                        height: 0.5,
                        margin: EdgeInsets.only(
                            left: day.weekday == 1 ? 15 : 0,
                            right: day.weekday == 7 ? 15 : 0),
                        color: const Color(0XFF1E1E1E).withOpacity(0.3),
                      )
                    ],
                  );
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
                headerPadding: const EdgeInsets.symmetric(horizontal: 15),
                headerMargin: const EdgeInsets.symmetric(vertical: 15),
                titleTextStyle: caldendarTextStyle.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 22),
              ),
            ),
          );
        });
  }
}
