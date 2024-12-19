import 'dart:async';
import 'dart:developer';
import 'package:usay/Components/square_tiles.dart';
import 'package:usay/api/api.dart';
import 'package:flutter/material.dart';
import 'package:usay/pages/homepage.dart';
import 'package:usay/pages/sign_in.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => WelcomepageState();
}

class WelcomepageState extends State<Welcomepage> {
  static const String keylogin = "login";
  @override
  void initState() {
    super.initState();
    moveToNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/SplashBC.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: SquareTile2(imagePath: 'Images/img.png', height: MediaQuery.of(context).size.height*0.1),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.6 ,),
                const Text(
                  'A proud',
                  style: TextStyle(
                      fontFamily: 'Solitreo',
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'MAKE IN INDIA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Product',
                  style: TextStyle(
                      fontFamily: 'Solitreo',
                      fontSize: 16,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
        ),
    );
  }

  void moveToNext() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(keylogin);

    Timer(
      const Duration(seconds: 3),
      () {
        if (isLoggedIn != null) {
          if (APIs.auth.currentUser != null) {
            log('\nUser: ${APIs.auth.currentUser}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHome()),
            );
          }
          if (isLoggedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHome()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignIn()),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }
      },
    );
    setState(() {});
  }
}
