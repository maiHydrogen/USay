import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usay/Pages/chats.dart';
import 'package:usay/Pages/homepage.dart';
import 'package:usay/models/chatuser.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
          decoration: const BoxDecoration(
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
          child: GestureDetector(
            onTap:() => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: _userBar(),
                toolbarHeight: mq.height * 0.07,
                elevation: 10,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height:  mq.height * 0.75,
                    ),
                    _userInput(),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _userBar() {
    final mq = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.cyanAccent,
            size: 20,
          ),
        ),
        ClipRRect(
          borderRadius:
              BorderRadius.circular(mq.width * 0.1),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            width: mq.width * 0.1,
            height: mq.width * 0.1,
            imageUrl: widget.user.Image,
            errorWidget: (context, url, error) => Icon(
              FontAwesomeIcons.circleUser,
              color: Colors.cyanAccent,
              size: mq.width * 0.1,
            ),
          ),
        ),
        SizedBox(
          width: mq.width * 0.03,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.Name,
              style: const TextStyle(
                fontFamily: 'Solitreo',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.cyanAccent,
              ),
            ),
            Text(
              "Last Active - ${widget.user.lastActive} ago",
              style: const TextStyle(
                fontFamily: 'Solitreo',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        SizedBox(
          width: mq.width * 0.4,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.phone,
            color: Colors.cyanAccent,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _userInput() {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: mq.width * 0.75,
            padding: EdgeInsets.symmetric(vertical: mq.height*0.005, horizontal: mq.width*0.02),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3,
                  offset:Offset(0,1),
                ),
              ],
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(mq.width*0.6),
              border:Border.all(color: Colors.black45) ,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.faceSmile,
                    color: Colors.cyan,
                    size: 30,
                  ),
                ),
                const Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Text here...',
                      border: InputBorder.none,
                    ),
                    autofocus: true,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.camera,
                    color: Colors.cyan,
                    size: 30,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.images,
                    color: Colors.cyan,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            color: Colors.cyan,
            elevation: 10,
            padding: EdgeInsets.all(mq.height * 0.015),
            onPressed: () {},
            shape: CircleBorder(),
            child: const Icon(
              FontAwesomeIcons.solidPaperPlane,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
