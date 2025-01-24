import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usay/Components/date&time.dart';
import 'package:usay/Components/profileimage.dart';
import 'package:usay/api/api.dart';
import 'package:usay/models/chatuser.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.cyan,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void loading(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Colors.cyan,
        ),
      ),
    );
  }
}

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      content: SizedBox(
          width: mq.width * .6,
          height: mq.height * .35,
          child: Stack(
            children: [
              //user profile picture
              Positioned(
                top: mq.height * .075,
                left: mq.width * .085,
                child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: <Color>[
                          Color.fromARGB(255, 31, 148, 160),
                          Color.fromARGB(255, 28, 108, 198),
                          Color.fromARGB(255, 175, 68, 239),
                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ProfileImage(size: mq.width * .5, url: user.Image),
                    )),
              ),

              //user name
              Positioned(
                left: mq.width * .04,
                top: mq.height * .02,
                width: mq.width * .55,
                child: Text(user.Name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),

              //info button
              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () {
                      //for hiding image dialog
                      Navigator.pop(context);

                      //move to view profile screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ChatProfile(user: user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(CupertinoIcons.exclamationmark_circle,
                        color: Colors.blue, size: 30),
                  ))
            ],
          )),
    );
  }
}

class ChatProfile extends StatelessWidget {
  const ChatProfile({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: SizedBox(
        width: mq.width * 0.9,
        height: mq.height * 0.8,
        child: StreamBuilder(
          stream: APIs.getUserInfo(user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        //FontAwesomeIcons.arrowLeft,
                        size: mq.width * 0.08,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.phone,
                        size: mq.width * 0.08,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: <Color>[
                        Color.fromARGB(255, 31, 148, 160),
                        Color.fromARGB(255, 28, 108, 198),
                        Color.fromARGB(255, 175, 68, 239),
                      ], // Gradient from https://learnui.design/tools/gradient-generator.html
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.width * 0.3),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: mq.width * 0.6,
                        height: mq.width * 0.6,
                        imageUrl: user.Image,
                        errorWidget: (context, url, error) => Icon(
                          FontAwesomeIcons.circleUser,
                          color: Colors.cyanAccent,
                          size: mq.width * 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                Text(
                  user.Name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mq.height * 0.025,
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                Text(user.About,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: mq.height * 0.0175,
                    )),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mq.height * 0.0175,
                    fontFamily: 'kalam',
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.1,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        shape: const CircleBorder(),
                        elevation: 10,
                        padding: EdgeInsets.all(mq.width * 0.035),
                        fixedSize: Size(
                          mq.width * 0.25,
                          mq.width * 0.25,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.videocam,
                            size: mq.width * 0.1,
                          ),
                          const Text('Video Call'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        shape: const CircleBorder(),
                        elevation: 10,
                        padding: EdgeInsets.all(mq.width * 0.035),
                        fixedSize: Size(
                          mq.width * 0.25,
                          mq.width * 0.25,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.star,
                            size: mq.width * 0.08,
                          ),
                          const Text('Star Friend'),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        elevation: 10,
                        padding: EdgeInsets.all(mq.width * 0.035),
                        fixedSize: Size(
                          mq.width * 0.25,
                          mq.width * 0.25,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.bell_slash,
                            size: mq.width * 0.08,
                          ),
                          const Text('Mute'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                Text(
                  list.isNotEmpty
                      ? list[0].isOnline
                          ? 'Online'
                          : MyDateTime.getLastActiveTime(
                              context: context, lastActive: list[0].lastActive)
                      : MyDateTime.getLastActiveTime(
                          context: context, lastActive: user.lastActive),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mq.height * 0.0175,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
