import 'package:applore_assignment/src/services/authentication.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  final Function toggleView;
  Register({required this.toggleView, Key? key}) : super(key: key);
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmpassword = TextEditingController();
  final TextEditingController _name = TextEditingController();

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
            height: size.height*0.42,
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
                              hintText: "Name",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                          ),
                          controller: _name,
                          style: const TextStyle(color: Colors.white),
                        ),
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
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))
                          ),
                          obscureText: true,
                          controller: _confirmpassword,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  ElevatedButton(
                    onPressed: (){
                      unfocus();
                      Authorization().register(_email.text, _password.text, _name.text);
                    },
                    child: const Text("Register"),
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                    onPressed: (){
                      toggleView();
                    },
                    child: const Text("Already have an account", style: TextStyle(color: Colors.white),),
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
