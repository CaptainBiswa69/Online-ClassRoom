import 'package:flutter/material.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/screens/loading.dart';
import 'package:online_classroom_app/screens/wrapper.dart';
import 'package:online_classroom_app/services/accounts_db.dart';
import 'package:online_classroom_app/services/updatealldata.dart';
import 'package:provider/provider.dart';

class Userform extends StatefulWidget {
  const Userform({Key? key}) : super(key: key);

  @override
  _UserformState createState() => _UserformState();
}

class _UserformState extends State<Userform> {
  String firstname = "";
  String lastname = "";
  String type = "student";
  String error = "";

  // for form validation
  final _formKey = GlobalKey<FormState>();

  // for loading screen
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    final AccountsDB pointer = AccountsDB(user: user!);

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                "User Details",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            body: Form(

                // form key for validation( check above)
                key: _formKey,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),

                      // textbox for name
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "First Name",
                            border: OutlineInputBorder()),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an First Name' : null,
                        onChanged: (val) {
                          setState(() {
                            firstname = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20.0),

                      // textbox for name
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Last Name",
                            border: OutlineInputBorder()),
                        onChanged: (val) {
                          setState(() {
                            lastname = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20.0),

                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                            labelText: "Category",
                            border: OutlineInputBorder()),
                        value: "Student",
                        onChanged: (newValue) {
                          setState(() {
                            type = (newValue as String).toLowerCase();
                          });
                        },
                        items: ['Student', 'Teacher'].map((location) {
                          return DropdownMenuItem(
                            value: location,
                            child: Text(location),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20.0),

                      // register button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);

                            // adding to db
                            await pointer.updateAccounts(
                                firstname, lastname, type);

                            await updateAllData();

                            setState(() => loading = false);
                            if (!mounted) return;
                            // popping to Wrapper to go to class
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Wrapper()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        ),
                        child: const Text("Register"),
                      ),

                      const SizedBox(height: 12.0),

                      // Prints error if any while registering
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                ))));
  }
}
