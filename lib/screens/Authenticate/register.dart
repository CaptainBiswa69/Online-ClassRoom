import 'package:flutter/material.dart';
import 'package:online_classroom_app/screens/Authenticate/userform.dart';
import 'package:online_classroom_app/screens/loading.dart';
import 'package:online_classroom_app/services/auth.dart';
import 'package:online_classroom_app/services/updatealldata.dart';

class Register extends StatefulWidget {
  final Function toggle_reg_log;
  const Register({super.key, required this.toggle_reg_log});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Authservice object for accessing all auth related functions
  // More details inside "services/auth.dart" file
  final AuthService _auth = AuthService();

  // email and password strings
  String email = '';
  String password = '';
  String error = '';

  // for form validation
  final _formKey = GlobalKey<FormState>();

  // for loading screen
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            // appbar part
            appBar: AppBar(
              title: const Text(
                "Register",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
              actions: [
                // login button on the top right corner of appbar
                TextButton.icon(
                  onPressed: () {
                    widget.toggle_reg_log();
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Login'),
                  style: TextButton.styleFrom(primary: Colors.black),
                )
              ],
            ),

            // body part
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

                      // textbox for email
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Email", border: OutlineInputBorder()),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20.0),

                      // textbox for password
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder()),
                        obscureText: true,
                        validator: (val) => val!.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),

                      const SizedBox(height: 20.0),

                      // register button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);

                            // Registering new student
                            var result =
                                await _auth.registerStudent(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error =
                                    'Some error in Registering! Please check again';
                              });
                            } else {
                              await updateAllData();

                              setState(() => loading = false);
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Userform()));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          minimumSize: const Size(150, 50),
                        ),
                        child: const Text("Register",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Roboto",
                                fontSize: 22)),
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
