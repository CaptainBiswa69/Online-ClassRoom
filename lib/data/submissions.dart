import 'package:flutter/foundation.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/announcements.dart';
import 'package:online_classroom_app/data/attachments.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/services/submissions_db.dart';

class Submission {
  Account user;
  String dateTime;
  ClassRooms classroom;
  Announcement assignment;
  bool submitted = false;
  List attachments;

  Submission(
      {required this.user,
      this.dateTime = "",
      required this.classroom,
      required this.assignment,
      this.submitted = false,
      required this.attachments});
}

List submissionList = [];

// updates the submissionList with DB values
Future<bool> getsubmissionList() async {
  submissionList = [];

  List? jsonList = await SubmissionDB().createSubmissionListDB();
  if (jsonList == null) return false;

  for (var element in jsonList) {
    var data = element.data();
    submissionList.add(Submission(
        user: getAccount(data["uid"])!,
        classroom: getClassroom(data["classroom"])!,
        assignment: getAnnouncement(data["classroom"], data["assignment"])!,
        dateTime: data["dateTime"],
        submitted: data["submitted"],
        attachments: getAttachmentListForStudent(
            data["uid"], data["classroom"], data["assignment"])));
  }

  debugPrint("\t\t\t\tGot submissions list");
  // print(submissionList);
  return true;
}


// List<Submission> submissionList = [
//   Submission(
//     user: accountList[0],
//     dateTime: 'Aug 25, 8:40 PM',
//     classroom: classRoomList[0],
//     assignment: announcementList[8],
//     submitted: true
//   ),
//   Submission(
//       user: accountList[1],
//       classroom: classRoomList[0],
//       assignment: announcementList[8],
//   ),
// ];