import 'package:applore_assignment/src/ui/login.dart';
import 'package:applore_assignment/src/ui/register.dart';
import 'package:flutter/material.dart';

class AuthenticatingPage extends StatefulWidget {
  const AuthenticatingPage({Key? key}) : super(key: key);

  @override
  _AuthenticatingPageState createState() => _AuthenticatingPageState();
}

class _AuthenticatingPageState extends State<AuthenticatingPage> {
  bool showLogin = true;
  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLogin){
      return Login(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}

