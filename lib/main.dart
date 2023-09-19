import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_classroom_app/data/custom_user.dart';
import 'package:online_classroom_app/firebase_options.dart';
import 'package:online_classroom_app/screens/wrapper.dart';
import 'package:online_classroom_app/services/auth.dart';
import 'package:online_classroom_app/services/updatealldata.dart';
import 'package:provider/provider.dart';

void main() async {
  // initializing firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await updateAllData();

  // running home Widget
  return runApp(const Home());
}

// it just returns basic settings for MaterialApp
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Stream provider for constantly getting the user data
    return StreamProvider<CustomUser?>.value(

      // value is the stream method declared in "services.auth.dart"
        value: AuthService().streamUser,
        initialData: null,

        // MaterialApp
        child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Wrapper()));
  }
}
