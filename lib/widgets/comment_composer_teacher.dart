import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/announcements.dart';
import 'package:online_classroom_app/screens/teacher_classroom/announcement_page.dart';

class CommentComposer extends StatefulWidget {
  String className;

  CommentComposer(this.className);

  @override
  _CommentComposerState createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  @override
  Widget build(BuildContext context) {
    List _announcementList = announcementList
        .where((i) => i.classroom.className == widget.className)
        .toList();

    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: _announcementList.length,
            itemBuilder: (context, int index) {
              return InkWell(
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => AnnouncementPage(
                            announcement: _announcementList[index]),
                      ))
                      .then((_) => setState(() {})),
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
                                            "${_announcementList[index].user.userDp}"),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _announcementList[index]
                                                      .user
                                                      .firstName +
                                                  " " +
                                                  _announcementList[index]
                                                      .user
                                                      .lastName,
                                              style: const TextStyle(),
                                            ),
                                            Text(
                                              _announcementList[index].dateTime,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ]),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  margin: const EdgeInsets.only(
                                      left: 15, top: 5, bottom: 10),
                                  child: Text(_announcementList[index].title))
                            ],
                          ))));
            }));
  }
}
