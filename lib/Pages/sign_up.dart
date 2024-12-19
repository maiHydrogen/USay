import 'package:usay/Components/textfields.dart';
import 'package:usay/Pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../Components/toast.dart';
import '../api/api.dart';
import 'homepage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Register Now",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'kalam'),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: Column(
                    children: [
                      MyTextField(
                        controller: _usernameController,
                        hintText: "Username",
                        obscureText: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        controller: _emailController,
                        hintText: "Email ID",
                        obscureText: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                NeumorphicButton(
                  onPressed: () async {
                    _signUp();
                  },
                  style: const NeumorphicStyle(
                      depth: 2,
                      color: Colors.white,
                      lightSource: LightSource.bottomRight,
                      shadowLightColor: Colors.cyanAccent),
                  child: Center(
                    child: isSigningUp
                        ? const CircularProgressIndicator(
                            color: Colors.cyan,
                          )
                        : const Text(
                            "SIGN UP",
                            style: TextStyle(
                                fontFamily: 'instrument_serif',
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'kalam'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                            (route) => false);
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontFamily: 'kalam',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });
    if (user != null) {
      showToast(message: "User is successfully created");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHome(),
        ),
      );
    } else {
      showToast(message: "Some error happend");
    }
  }
}
