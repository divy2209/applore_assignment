import 'package:applore_assignment/src/model/user.dart';
import 'package:applore_assignment/src/ui/authenticating_page.dart';
import 'package:applore_assignment/src/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserID?>(context);
    if(user==null){
      return const AuthenticatingPage();
    } else {
      return const Home();
    }
  }
}
