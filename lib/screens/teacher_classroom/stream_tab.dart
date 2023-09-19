import 'package:flutter/material.dart';
import 'package:online_classroom_app/widgets/comment_composer_teacher.dart';

class StreamTab extends StatefulWidget {
  final String className;
  final Color uiColor;

  const StreamTab({super.key, required this.className, required this.uiColor});

  @override
  State<StreamTab> createState() => _StreamTabState();
}

class _StreamTabState extends State<StreamTab> {
  @override
  Widget build(BuildContext context) {
    return CommentComposer(widget.className);
  }
}
