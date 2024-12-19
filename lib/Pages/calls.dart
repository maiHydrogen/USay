import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';


 class MyCalls extends StatefulWidget {
  const MyCalls({super.key, required this.title, required this.controller});
  final String title;
  final MotionTabBarController controller;

  @override
  State<MyCalls> createState() => __MyCallsState();
}

class __MyCallsState extends State<MyCalls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            backgroundBlendMode: BlendMode.src,
           gradient:  LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
             Color(0x00000000),
             Color.fromARGB(255, 21, 135, 152),
             Color(0x001D1639),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.clamp,
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