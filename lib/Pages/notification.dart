import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usay/Pages/sign_in.dart';
import 'package:usay/Pages/welcome.dart';


import '../api/api.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
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
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            width: 250,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Icon(
                    FontAwesomeIcons.circleExclamation,
                    color: Colors.white,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "We're working hard on this one",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'kalam',
                    ),
                  ),
                  IconButton( icon: const Icon(FontAwesomeIcons.arrowRightFromBracket),
                    onPressed: () async {
                      await APIs.auth.signOut();
                      await GoogleSignIn().signOut();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignIn(),
                        ),
                      );
                    },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
