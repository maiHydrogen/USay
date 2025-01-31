import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class MyNewChats extends StatefulWidget {
  const MyNewChats({super.key, required this.title, required this.controller});
  final String title;
  final MotionTabBarController controller;

  @override
  State<MyNewChats> createState() => __MyNewChatsState();
}

class __MyNewChatsState extends State<MyNewChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration:  const BoxDecoration(
            backgroundBlendMode: BlendMode.src,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[
                Color.fromARGB(255, 31, 148, 160),
                Color.fromARGB(255, 28, 108, 198),
                Color.fromARGB(255, 175, 68, 239),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          width: 250,
          height: 250,
          child: const Padding(
            padding:EdgeInsets.all(8.0),
            child:  Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Icon(
                  FontAwesomeIcons.circleExclamation,
                  color: Colors.white,
                  size: 100,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "We're working hard on this one",
                  style: TextStyle(color: Colors.white,
                  fontSize: 16,
                  fontFamily:  'kalam',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
