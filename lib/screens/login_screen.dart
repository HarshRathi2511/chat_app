import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String loginEmail; //email entered via logging in .
  String loginPassword;

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //for the welcome screen to the login screen
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                loginEmail = value;
              },
              decoration: kLoginTextFieldDecoration.copyWith(
                  hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                loginPassword = value;
              },
              decoration: kLoginTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
              //Creates a copy of this input decoration with the given fields replaced by the new values.
            ),
            SizedBox(
              height: 24.0,
            ),

            RoundedButton(
              onPressed: () async {
                //login functionality
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: loginEmail, password: loginPassword);

                  if(user!=null) {
                    Navigator.pushNamed(context, ChatScreen.routeName);
                  }    
                } catch (error) {
                  print(error);
                }
              },
              text: 'Log In',
              color: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
