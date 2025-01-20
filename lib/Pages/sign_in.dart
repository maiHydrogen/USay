// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';
import 'package:usay/Components/dialogs.dart';
import 'package:usay/Pages/homepage.dart';
import 'package:usay/Pages/sign_up.dart';
import 'package:usay/Components/square_tiles.dart';
import 'package:usay/Pages/welcome.dart';
import 'package:usay/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/textfields.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => SignInState();
}

class SignInState extends State<SignIn> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  // Google SignIn
  _googleButton() {
    Dialogs.loading(context);
    _signInWithGoogle().then(
      (user) async {
        Navigator.pop(context);

        if (user != null) {
          log('\nUser: ${user.user}');
          log('\nUserAdditionalInfo: ${user.additionalUserInfo}');
          if ((await APIs.userExists())) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHome(),
              ),
            );
          } else {
            await APIs.createUser().then(
              (value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHome(),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackBar(context, 'Oops! Something went wrong.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0x00000000),
            Color.fromARGB(255, 21, 135, 152),
            Color(0x001D1639),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Icon(
                    FontAwesomeIcons.userLock,
                    size: 80,
                    color: Color.fromARGB(255, 225, 225, 230),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                        fontFamily: 'kalam',
                        fontSize: 18,
                        color: Color.fromARGB(255, 226, 226, 230)),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Let\'s get started by signing in first.',
                    style: TextStyle(
                        fontFamily: 'kalam',
                        fontSize: 18,
                        color: Color.fromARGB(255, 230, 233, 236)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                            controller: _emailController,
                            hintText: 'Email address',
                            obscureText: false),
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            obscureText: true),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => (){},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'kalam',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  NeumorphicButton(
                    onPressed: ()async{
                      _signIn();
                    var sharedPref = await SharedPreferences.getInstance();
                      sharedPref.setBool(WelcomepageState.keylogin, true);
                      var pref = await SharedPreferences.getInstance();
                      //await APIs.updateActiveStatus(true);
                    },
                    style: const NeumorphicStyle(
                        depth: 2,
                        color: Colors.white,
                        lightSource: LightSource.bottomRight,
                        shadowLightColor: Colors.cyanAccent),
                    child: const Text(
                      'SIGN IN',
                      style: TextStyle(
                          fontFamily: 'instrument_serif',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2.5,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  NeumorphicButton(
                    onPressed: () => _googleButton(),
                    style: const NeumorphicStyle(
                        depth: 2,
                        lightSource: LightSource.bottomRight,
                        shadowLightColor: Colors.cyanAccent),
                    child:
                        const SquareTile1(imagePath: 'Images/google-logo.png'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member ?',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'kalam'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () =>  Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        ),
                        child: const Text(
                          'Register Now ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'kalam',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      Dialogs.showSnackBar(context, "User is successfully signed in");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHome()),
      );
    } else {
      Dialogs.showSnackBar(context,"some error occured");
    }
  }

}
