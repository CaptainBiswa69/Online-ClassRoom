import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/services/classes_db.dart';
import 'package:online_classroom_app/services/updatealldata.dart';
import 'package:provider/provider.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  String className = "";
  String description = "";
  Color uiColor = Colors.blue;
  Color _tempShadeColor = Colors.blue;

  // for form validation
  final _formKey = GlobalKey<FormState>();

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel'),
            ),
            TextButton(
              child: const Text('Select'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => uiColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Color picker",
      MaterialColorPicker(
          selectedColor: uiColor,
          onColorChange: (color) => setState(() => _tempShadeColor = color)),
    );
  }

  // build func
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
        // appbar part
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.5,
          title: const Text(
            "Add Class",
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
                          labelText: "Class Name",
                          border: OutlineInputBorder()),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter a class name' : null,
                      onChanged: (val) {
                        setState(() {
                          className = val;
                        });
                      },
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

                    const SizedBox(height: 20.0),

                    OutlinedButton(
                        onPressed: () {
                          _openColorPicker();
                          setState(() => {});
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Accent Color",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 14)),
                                  CircleColor(
                                    color: uiColor,
                                    circleSize: 30,
                                    onColorChoose: (color) {
                                      setState(() => uiColor = color);
                                    },
                                  ),
                                ]))),

                    const SizedBox(height: 20.0),

                    // Login  button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await ClassesDB(user: user)
                              .updateClasses(className, description, uiColor);
                          await updateAllData();
                          if (!mounted) return;
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
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
