import 'package:applore_assignment/src/services/authentication.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final Function toggleView;
  Login({required this.toggleView, Key? key}) : super(key: key);
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void unfocus(){
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        currentFocus.focusedChild!.unfocus();
      }
    }
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: unfocus,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade800,
        body: Center(
          child: Container(
            height: size.height*0.32,
            width: size.width*0.8,
            color: Colors.white.withOpacity(0.3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width*0.64,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                          ),
                          controller: _email,
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                          ),
                          obscureText: true,
                          controller: _password,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  ElevatedButton(
                    onPressed: (){
                      unfocus();
                      Authorization().login(_email.text, _password.text);
                    },
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                    onPressed: (){
                      toggleView();
                    },
                    child: const Text("Not Registered", style: TextStyle(color: Colors.white),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
