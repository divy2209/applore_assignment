import 'package:applore_assignment/src/model/user.dart';
import 'package:applore_assignment/src/services/authentication.dart';
import 'package:applore_assignment/src/services/config.dart';
import 'package:applore_assignment/src/ui/authentication_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Local.sharedPreferences = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserID?>.value(
      value: Authorization().user,
      initialData: null,
      child: const MaterialApp(
        title: "Applore Assignment",
        debugShowCheckedModeBanner: false,
        home: AuthenticationWrapper(),
      ),
    );
  }
}
