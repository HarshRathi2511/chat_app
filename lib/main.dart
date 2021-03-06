import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      
      // home: LoginScreen(),
      initialRoute: WelcomeScreen.routeName,
      routes: {
        ChatScreen.routeName:(ctx)=>ChatScreen(),
        LoginScreen.routeName:(ctx)=> LoginScreen(),
        WelcomeScreen.routeName:(ctx)=>WelcomeScreen(),
        RegistrationScreen.routeName:(ctx)=>RegistrationScreen(),
      },
    );
  }
}
