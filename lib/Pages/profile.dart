import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usay/Pages/sign_in.dart';
import 'package:usay/Pages/welcome.dart';
import 'package:usay/models/chatuser.dart';

import '../api/api.dart';

class MyProfile extends StatefulWidget {
  final ChatUser user;
  const MyProfile({super.key, required this.user});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        backgroundBlendMode: BlendMode.src,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0x00000000),
            Color.fromARGB(255, 21, 135, 152),
            Color(0x001D1639),
          ], // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
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
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Stack(
                    children: [ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.2),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        imageUrl: widget.user.Image,
                        errorWidget: (context, url, error) => Icon(
                          FontAwesomeIcons.circleUser,
                          color: Colors.cyanAccent,
                          size: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ),
                    ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(onPressed: (){},
                       elevation: 1,
                        shape: const CircleBorder(),
                        color: Colors.white,
                        child: const Icon(Icons.edit, color: Colors.cyan,),
                      ),),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'kalam',
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    initialValue: widget.user.Name,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.cyan,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text("Name"),
                        hintText: 'Lewis Hamilton'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  TextFormField(
                    initialValue: widget.user.About,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.cyan,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        label: const Text("About"),
                        hintText: '7 times F1 World Champion'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.4,
                          MediaQuery.of(context).size.height * 0.055),
                    ),
                    child: const Text(
                      'UPDATE',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'kalam'),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.cyan,
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'kalam'),
                    ),
                    icon: const Icon(FontAwesomeIcons.arrowRightFromBracket),
                    onPressed: () async {
                      var shacyanPref = await SharedPreferences.getInstance();
                      shacyanPref.setBool(WelcomepageState.keylogin, false);
                      await APIs.auth.signOut().then((value)async{
                        await GoogleSignIn().signOut().then((value){
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignIn(),
                            ),
                          );
                        });
                      },);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
