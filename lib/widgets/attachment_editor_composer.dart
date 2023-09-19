import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/services/attachments_db.dart';
import 'package:online_classroom_app/services/submissions_db.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

void _launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

class AttachmentEditorComposer extends StatefulWidget {
  final List attachmentList;
  String title = "";
  bool isTeacher = true;
  String className;

  AttachmentEditorComposer(
      {super.key,
      required this.attachmentList,
      this.title = "",
      this.isTeacher = true,
      this.className = ""});

  @override
  _AttachmentEditorComposerState createState() =>
      _AttachmentEditorComposerState();
}

class _AttachmentEditorComposerState extends State<AttachmentEditorComposer> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.attachmentList.length,
        itemBuilder: (context, int index) {
          return InkWell(
              onTap: () {
                _launchURL(widget.attachmentList[index].url);
                // OpenFile.open(widget.attachmentList[index].url);
              },
              child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(color: Colors.black87, blurRadius: 0.05)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            child: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.attachmentList[index].name,
                                style: const TextStyle(
                                    fontSize: 15, letterSpacing: 1),
                              ),
                            ],
                          )
                        ]),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: IconButton(
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.black,
                              size: 30,
                            ),
                            onPressed: () async {
                              String safeURL = widget.attachmentList[index].url
                                  .replaceAll(RegExp(r'[^\w\s]+'), '');
                              await AttachmentsDB().deleteAttachmentsDB(
                                  widget.attachmentList[index].name, safeURL);

                              debugPrint("Deleted attachment");

                              if (widget.title != "" && widget.isTeacher) {
                                await AttachmentsDB().deleteAttachAnnounceDB(
                                    widget.title, safeURL);
                                debugPrint(
                                    "Deleted reference to attachment on announcement");
                              } else {
                                await AttachmentsDB()
                                    .deleteAttachmentStudentsDB(
                                        user!.uid,
                                        safeURL,
                                        "${widget.className}__${widget.title}");
                                await SubmissionDB().updateSubmissions(user.uid,
                                    widget.className, widget.title, false);
                                debugPrint(
                                    "Deleted reference to attachment on announcement");
                              }
                              setState(
                                  () => widget.attachmentList.removeAt(index));
                            },
                          ),
                        ),
                      ],
                    ),
                  )));
        });
  }
}
