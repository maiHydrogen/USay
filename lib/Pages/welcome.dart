import 'dart:async';
import 'package:usay/Components/square_tiles.dart';
import 'package:usay/api/api.dart';
import 'package:flutter/material.dart';
import 'package:usay/pages/homepage.dart';
import 'package:usay/pages/sign_in.dart';
import 'package:flutter/services.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => WelcomepageState();
}

class WelcomepageState extends State<Welcomepage> {
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SquareTile2(
                imagePath: 'Images/img.png',
                height: MediaQuery.of(context).size.height * 0.1),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
            ),
            const Text(
              'We\'re listening!',
              style: TextStyle(
                  fontFamily: 'Solitreo', fontSize: 26, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void moveToNext() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));

    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => APIs.auth.currentUser != null
                    ? const MyHome()
                    : const SignIn()));
      },
    );
    setState(() {});
  }
}
