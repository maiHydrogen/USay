import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usay/Components/dialogs.dart';
import 'package:usay/Components/toast.dart';
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
  final _formkey = GlobalKey<FormState>();
  String? profileImage;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: <Color>[
              Color.fromARGB(255, 31, 148, 160),
              Color.fromARGB(255, 28, 108, 198),
              Color.fromARGB(255, 175, 68, 239),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
          ),
          backgroundBlendMode: BlendMode.src,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                        children: [
                          profileImage != null
                              ? //show local image
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.3),
                                  child: Image.file(
                                    File(profileImage!),
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height:
                                        MediaQuery.of(context).size.width * 0.6,
                                  ))
                              : // show server image
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.3),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height:
                                        MediaQuery.of(context).size.width * 0.6,
                                    imageUrl: widget.user.Image,
                                    errorWidget: (context, url, error) => Icon(
                                      FontAwesomeIcons.circleUser,
                                      color: Colors.cyanAccent,
                                      size: MediaQuery.of(context).size.width *
                                          0.5,
                                    ),
                                  ),
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                              onPressed: () {
                                AddImage();
                              },
                              elevation: 1,
                              shape: const CircleBorder(),
                              color: Colors.white,
                              child: const Icon(
                                FontAwesomeIcons.pencil,
                                color: Colors.cyan,
                              ),
                            ),
                          ),
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
                        onSaved: (val) => APIs.me.Name = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              FontAwesomeIcons.solidCircleUser,
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
                        onSaved: (val) => APIs.me.About = val ?? '',
                        validator: (val) => val != null && val.isNotEmpty
                            ? null
                            : 'Required Field',
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              FontAwesomeIcons.circleInfo,
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
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            log('inside validator');
                            _formkey.currentState!.save();
                            APIs.updateUserProfile().then((value) {
                              showToast(
                                  message: 'Profile Updated Successfully');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.4,
                              MediaQuery.of(context).size.height * 0.055),
                        ),
                        label: const Text(
                          'UPDATE',
                          style: TextStyle(fontSize: 24, fontFamily: 'kalam'),
                        ),
                        icon: const Icon(FontAwesomeIcons.cloudArrowUp),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: Colors.cyan,
                        label: const Text(
                          'Sign Out',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'kalam'),
                        ),
                        icon:
                            const Icon(FontAwesomeIcons.arrowRightFromBracket),
                        onPressed: () async {
                          Dialogs.showSnackBar(
                              context, 'Signed Out Successfully');
                          var shacyanPref =
                              await SharedPreferences.getInstance();
                          shacyanPref.setBool(WelcomepageState.keylogin, false);
                          await APIs.updateActiveStatus(false);
                          await APIs.auth.signOut().then(
                            (value) async {
                              await GoogleSignIn().signOut().then((value) {
                                Navigator.pop(context);
                                APIs.auth = FirebaseAuth.instance;
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignIn(),
                                  ),
                                );
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void AddImage() {
    final mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03),
            children: [
              const Text(
                'Choose a Profile Image',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontFamily: 'Solitreo'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        log('ImagePath: ${image.path}');
                        setState(() {
                          profileImage = image.path;
                        });
                        Navigator.pop(context);
                      } else {
                        log('Nothing found');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * 0.1),
                      child: Image.asset(
                        'Images/camera5.webp',
                        fit: BoxFit.cover,
                        height: mq.height * 0.1,
                        width: mq.height * 0.1,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        log('ImagePath: ${image.path}');
                        setState(() {
                          profileImage = image.path;
                        });
                        Navigator.pop(context);
                      } else {
                        log('Nothing found');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      elevation: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * 0.1),
                      child: Image.asset(
                        'Images/Gallery3.webp',
                        fit: BoxFit.cover,
                        height: mq.height * 0.1,
                        width: mq.height * 0.1,
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
