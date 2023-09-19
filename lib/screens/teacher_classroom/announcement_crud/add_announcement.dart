import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/attachments.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/services/announcements_db.dart';
import 'package:online_classroom_app/services/attachments_db.dart';
import 'package:online_classroom_app/services/submissions_db.dart';
import 'package:online_classroom_app/services/updatealldata.dart';
import 'package:online_classroom_app/utils/datetime.dart';
import 'package:online_classroom_app/widgets/attachment_editor_composer.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

class AddAnnouncement extends StatefulWidget {
  final ClassRooms classRoom;

  const AddAnnouncement({super.key, required this.classRoom});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  String title = '';
  String description = '';
  String type = 'Notice';
  String dateTime = todayDate();
  String dueDate = todayDate();
  List attachments = [];

  UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return null;
    }
  }

  Future addFile(String user, String className) async {
    File? file;
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    file = File(path);

    final fileName = basename(file.path);
    final destination = user + "/" + className + '/$fileName';

    UploadTask? task = uploadFile(destination, file);

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    debugPrint('Download-Link: $urlDownload');

    String safeURL = urlDownload.replaceAll(RegExp(r'[^\w\s]+'), '');
    await AttachmentsDB().createAttachmentsDB(
        fileName, urlDownload, safeURL, lookupMimeType(fileName) as String);

    setState(() => attachments.add(Attachment(
        name: fileName,
        url: urlDownload,
        type: lookupMimeType(fileName) as String)));
  }

  // for form validation
  final _formKey = GlobalKey<FormState>();

  // build func
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    var account = getAccount(user!.uid);

    return Scaffold(
        // appbar part
        appBar: AppBar(
          backgroundColor: widget.classRoom.uiColor,
          elevation: 0.5,
          title: const Text(
            "Add Announcement",
            style: TextStyle(
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

        // body part
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),

                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Title", border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? 'Enter a title' : null,
                      onChanged: (val) {
                        setState(() {
                          title = val;
                        });
                      },
                    ),

                    const SizedBox(height: 20.0),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                          labelText: "Type", border: OutlineInputBorder()),
                      value: type,
                      onChanged: (newValue) {
                        setState(() {
                          type = newValue as String;
                        });
                      },
                      items: ['Notice', 'Assignment'].map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: new Text(location),
                        );
                      }).toList(),
                    ),

                    if (type == 'Assignment') const SizedBox(height: 20.0),

                    if (type == 'Assignment')
                      DateTimeField(
                        decoration: const InputDecoration(
                            labelText: "Due Date",
                            border: OutlineInputBorder()),
                        format: DateFormat('h:mm a EEE, MMM d, yyyy'),
                        initialValue: DateTime.now(),
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                        onChanged: (date) => dueDate = formatDate(date),
                      ),

                    const SizedBox(height: 20.0),

                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                      maxLines: 5,
                      onChanged: (val) {
                        setState(() {
                          description = val;
                        });
                      },
                    ),

                    const SizedBox(height: 10.0),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: const Text(
                          "Attachments:",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold),
                        )),
                    if (attachments.isNotEmpty)
                      AttachmentEditorComposer(attachmentList: attachments),

                    OutlinedButton(
                        onPressed: () {
                          addFile(account!.email as String,
                              widget.classRoom.className);
                          setState(() => {});
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Add Attachment",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 14)),
                                  Icon(
                                    Icons.add_circle_outline_outlined,
                                    color: widget.classRoom.uiColor,
                                    size: 32,
                                  )
                                ]))),

                    const SizedBox(height: 20.0),

                    // Login  button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await AnnouncementDB(user: user).addAnnouncements(
                              title,
                              type,
                              description,
                              widget.classRoom.className,
                              dateTime,
                              dueDate);

                          for (int i = 0; i < attachments.length; i++) {
                            String safeURL = attachments[i]
                                .url
                                .replaceAll(new RegExp(r'[^\w\s]+'), '');

                            await AttachmentsDB().createAttachAnnounceDB(
                                title, attachments[i].url, safeURL);
                          }

                          if (type == 'Assignment') {
                            for (int index = 0;
                                index < widget.classRoom.students.length;
                                index++) {
                              await SubmissionDB().addSubmissions(
                                  widget.classRoom.students[index].uid,
                                  widget.classRoom.className,
                                  title);
                            }
                          }
                          await updateAllData();
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: widget.classRoom.uiColor,
                        minimumSize: const Size(150, 50),
                      ),
                      child: const Text("Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Roboto",
                              fontSize: 22)),
                    )
                  ],
                ))
          ],
        ));
  }
}
