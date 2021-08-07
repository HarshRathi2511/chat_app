import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'dart:math';
// import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome-screen';
  //to avoid initializing a whole new class to get a value =>static makes it more efficient
  //WelcomeScreen().property........WelcomeScreen.property
  //class wide variable
  //const for not changing it accidently in another class

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

//mixin for resuing a classes code in multiple class hierarhcy
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //SingleTickerProviderStateMixin->for a single animation
  //_WelcomeScreenState is the ticker provider

  AnimationController controller;

  Animation animation;
  Animation animateFlashImage;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      //manages the animation
      duration: Duration(seconds: 3),
      vsync:
          this, //object that gets created from the state class having the required mixin
      upperBound: 1,
    );

    animateFlashImage = CurvedAnimation(
        parent: controller, curve: Curves.easeIn); //see docs curve not linear
    //curves only have upper bound of 1
    //CurvedAnimation defines progress as a non linear curve

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    //tween interpolates between range of data as used by the object being animated

    controller
        .forward(); //Starts running this animation forwards (towards the end).

    // controller.reverse(from: 1.0);

    //use the Listeners and Status Listeners to monitor animation changes

    // animation.addStatusListener((status) { //we need status if we want to loop animations
    //   print(status); //AnimationStatus.completed =>of forward animation
    //AnimationStatus.dismissed =>of reverse animation
    //   if(status ==AnimationStatus.completed) {
    //     controller.reverse(from:1.0);
    //   }
    //   else if (status==AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      //function runs whenever value of controller changes
      setState(() {
        //rebuilds screen whenever controller changes
      });

      // print(controller
      //     .value); //ranges from lower bound to upper bound over the span of duration
      // print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 40.0,
      fontFamily: 'Horizon',
    );

    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                //starting hero widget
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    // height: 60.0,
                    // height: controller.value,
                    height: animateFlashImage.value * 100,
                  ),
                ),

                // AnimatedTextKit(
                //   animatedTexts: [
                //     ColorizeAnimatedText(
                //       'FLASH',
                //       textStyle: colorizeTextStyle,
                //       colors: colorizeColors,
                //     ),
                //     ColorizeAnimatedText(
                //       'CHAT',
                //       textStyle: colorizeTextStyle,
                //       colors: colorizeColors,
                //     ),
                //     // ColorizeAnimatedText(
                //     //   'Steve Jobs',
                //     //   textStyle: colorizeTextStyle,
                //     //   colors: colorizeColors,
                //     // ),
                //   ],
                //   isRepeatingAnimation: true,
                //   onTap: () {
                //     print("Tap Event");
                //   },
                // ),
                Text('FLASH CHAT',style: colorizeTextStyle),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton( //custom widget
                text: 'Log in',
                color: Colors.lightBlueAccent,
                onPressed: () =>
                    Navigator.of(context).pushNamed(LoginScreen.routeName)),
          
            RoundedButton(
                text: 'Register',
                color: Colors.blueAccent,
                onPressed: () =>
                    Navigator.of(context).pushNamed(RegistrationScreen.routeName)),
          ],
        ),
      ),
    );
  }
}

class ShakeCurve extends Curve {
  //to define a custom curve
  @override
  double transform(double t) => sin(t * pi * 2);
}
