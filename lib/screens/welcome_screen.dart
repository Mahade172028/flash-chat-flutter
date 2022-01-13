import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'round_botton.dart';

class WelcomeScreen extends StatefulWidget {

  static String id="welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=AnimationController(
      duration: Duration(seconds: 3),
      vsync: this
    );
    // animation=CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation=ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(controller);
    controller.forward();

    /*animation.addStatusListener((status) {
      print(status);
      if(status==AnimationStatus.completed){
        controller.reverse(from: 1.0);
      }else if(status==AnimationStatus.dismissed){
        controller.forward();
      }
    });*/

    controller.addListener(() {
      setState(() {});
      //print(controller.value);
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
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height:60.0,    //animation.value*100,
                    ),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text:["Flash chat"],
                  textStyle: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(buttonText: 'Login',colorValue: Colors.blue,function: (){
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            RoundedButton(buttonText: 'Register',colorValue: Colors.green,function: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),
          ],
        ),
      ),
    );
  }
}

