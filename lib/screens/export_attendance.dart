import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/accounts.dart';
import 'package:online_classroom_app/data/classrooms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';

class ExportAttendance extends StatefulWidget {
  final ClassRooms classRoom;
  const ExportAttendance({super.key, required this.classRoom});

  @override
  State<ExportAttendance> createState() => _ExportAttendanceState();
}

class _ExportAttendanceState extends State<ExportAttendance> {
  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>? snapshotData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Export"),
        actions: [
          IconButton(
              onPressed: () {
                generateAndDisplayPDF(context, snapshotData!, widget.classRoom);
              },
              icon: const Icon(Icons.abc))
        ],
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("Classes")
              .doc(widget.classRoom.className)
              .collection("Attendance")
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshotData = snapshot;
              return attendanceTable(snapshot, widget.classRoom);
            } else {
              return Container();
            }
          }),
    );
  }
}

dynamic attendanceTable(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
    ClassRooms classRoom) {
  return DataTable(columns: [
    const DataColumn(
      label: Text('Name'),
    ),
    ...List.generate(snapshot.data!.docs.length,
        (index) => DataColumn(label: Text(snapshot.data!.docs[index].id))),
    const DataColumn(label: Text("Total"))
  ], rows: [
    ...List.generate(
        classRoom.students.length,
        (index) => DataRow(cells: [
              DataCell(Text((classRoom.students[index] as Account).firstName!)),
              ...List.generate(
                  snapshot.data!.docs.length,
                  (i) => DataCell(snapshot.data!.docs[i]
                          .data()["presentStudents"]
                          .contains((classRoom.students[index] as Account).uid)
                      ? const Text("Present")
                      : const Text("Absent"))),
              DataCell(Text(getTotalPresent(
                  snapshot, (classRoom.students[index] as Account).uid!))),
            ])),
    DataRow(cells: [
      const DataCell(Text("Total")),
      ...List.generate(
          snapshot.data!.docs.length,
          (i) => DataCell(Text(snapshot.data!.docs[i]
              .data()["presentStudents"]
              .length
              .toString()))),
      DataCell(Text(classRoom.students.length.toString()))
    ])
  ]);
}

String getTotalPresent(
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, String uid) {
  int totalPresent = 0;
  for (var element in snapshot.data!.docs) {
    if (element.data()["presentStudents"].contains(uid)) {
      totalPresent++;
    }
  }
  return totalPresent.toString();
}

Future<void> generateAndDisplayPDF(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
    ClassRooms classRoom) async {
  final PdfDocument document = PdfDocument();
  final PdfPage page = document.pages.add();
  final PdfGrid grid = PdfGrid();

  DataTable myDataTable = attendanceTable(snapshot, classRoom);

  // Specify the number of columns for the PDF grid based on DataColumn count.
  grid.columns.add(count: myDataTable.columns.length);

  // Create a header row in the PDF grid.
  final PdfGridRow headerRow = grid.headers.add(1)[0];
  for (int i = 0; i < myDataTable.columns.length; i++) {
    headerRow.cells[i].value = (myDataTable.columns[i].label as Text).data;
  }

  // Set header font.
  headerRow.style.font =
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

  // Add rows to the grid based on your DataRow(s).
  for (var row in myDataTable.rows) {
    final PdfGridRow pdfRow = grid.rows.add();
    for (int i = 0; i < row.cells.length; i++) {
      pdfRow.cells[i].value = (row.cells[i].child as Text).data;
    }
  }

  // Set grid format.
  grid.style.cellPadding = PdfPaddings(left: 5, top: 5);

  // Draw the table on the PDF page.
  grid.draw(
    page: page,
    bounds: Rect.fromLTWH(
      0,
      0,
      page.getClientSize().width,
      page.getClientSize().height,
    ),
  );

  // Save the PDF document.
  Directory appDocDirectory = await getApplicationDocumentsDirectory();
  File pdf = await File('${appDocDirectory.path}PDFTable.pdf')
      .writeAsBytes(document.saveSync());
  OpenFile.open(pdf.path);
  document.dispose();
}
