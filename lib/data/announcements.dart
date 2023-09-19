import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/attachments.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/services/announcements_db.dart';

class Announcement {
  Account user;
  String dateTime;
  String dueDate;
  String title;
  String type;
  String description;
  ClassRooms classroom;
  bool active = true;
  List attachments;

  Announcement(
      {required this.user,
      required this.dateTime,
      this.dueDate = "",
      required this.type,
      required this.title,
      required this.description,
      required this.classroom,
      required this.attachments});
}

List announcementList = [];
List notificationList = List.from(announcementList);

// updates the announcementList with DB values
Future<bool> getAnnouncementList() async {
  announcementList = [];

  List? jsonList = await AnnouncementDB().createAnnouncementListDB();
  if (jsonList == null) return false;

  for (var element in jsonList) {
    var data = element.data();
    announcementList.insert(
        0,
        Announcement(
          title: data["title"],
          dateTime: data["dateTime"],
          type: data["type"],
          description: data["description"],
          dueDate: data["dueDate"],
          attachments: getAttachmentListForAnnouncement(data["title"]),
          user: getAccount(data["uid"])!,
          classroom: getClassroom(data["className"])!,
        ));
  }

  print("\t\t\t\tGot Announcements list");
  return true;
}

Announcement? getAnnouncement(className, assignment) {
  var data = announcementList.firstWhere(
      (element) =>
          element.classroom.className == className &&
          element.title == assignment,
      orElse: () => null);
  return data;
}



// List<Announcement> announcementList = [
//   Announcement(
//       user: classRoomList[0].creator,
//       dateTime: "Aug 28, 9:00 PM",
//       type: "Notice",
//       title: "Please submit Assignment 2",
//       description: "",
//       classroom: classRoomList[0],
//       attachments: []
//   ),
// ......................................
// ];

// List<Announcement> notificationList = List.from(announcementList);