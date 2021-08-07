import 'package:flash_chat/constants.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registration-screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance; //static instance of that class

  String email;
  String password;

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
            //ending hero widget
            Hero(
              tag: 'logo', //matches the previous tag of the hero widget
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
                email = value;
              },
              decoration: kRegistrationTextFieldDecoration.copyWith(
                  hintText: 'Enter your email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: kRegistrationTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                text: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  //register a new user 
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password:
                            password); //we can access the user by user.currentUser();
                    print(newUser.toString());
                    // FirebaseUser({uid: z8Qkv9Ui4BUJ8olOgXKoV6ZN4Tf1, isAnonymous: false, providerData: [{uid: z8Qkv9Ui4BUJ8olOgXKoV6ZN4Tf1, providerId: firebase, email: test123@gmail.com}, {uid: test123@gmail.com, providerId: password, email: test123@gmail.com}], providerId: firebase, creationTimestamp: 1628321780043, lastSignInTimestamp: 1628321780043, email: test123@gmail.com, isEmailVerified: false})
                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.routeName);
                    }
                  } catch (e) {
                    print(e);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
