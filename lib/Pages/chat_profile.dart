import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usay/Components/date&time.dart';
import 'package:usay/models/chatuser.dart';
import '../api/api.dart';

class ChatProfile extends StatefulWidget {
  final ChatUser user;
  const ChatProfile({super.key, required this.user});
  @override
  State<ChatProfile> createState() => _ChatProfileState();
}

class _ChatProfileState extends State<ChatProfile> {
  String? profileImage;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      width: mq.width,
      height: mq.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment(0.8, 1),
          colors: <Color>[
            Color(0x00000000),
            Color.fromARGB(255, 21, 135, 152),
            Color(0x001D1639),
          ],
          // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            width: mq.width * 0.9,
            height: mq.height * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: APIs.getUserInfo(widget.user),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.width * 0.3),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          width: mq.width * 0.6,
                          height: mq.width * 0.6,
                          imageUrl: widget.user.Image,
                          errorWidget: (context, url, error) => Icon(
                            FontAwesomeIcons.circleUser,
                            color: Colors.cyanAccent,
                            size: mq.width * 0.5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      Text(
                        widget.user.Name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: mq.height * 0.025,
                        ),
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      Text(widget.user.About,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: mq.height * 0.0175,
                          )),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      Text(
                        widget.user.email,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: mq.height * 0.0175,
                          fontFamily: 'kalam',
                        ),
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : MyDateTime.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
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
          ),
        ),
      ),
    );
  }
}
