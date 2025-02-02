import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usay/Components/date&time.dart';
import 'package:usay/Components/dialogs.dart';
import 'package:usay/Components/message_card.dart';
import 'package:usay/api/api.dart';
import 'package:usay/models/chatuser.dart';
import 'package:usay/models/messages.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
  //for storing all messages
  List<Message> list = [];
  //for handling message text changes
  final _textController = TextEditingController();
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Images/SplashBC.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
                padding: EdgeInsets.only(top: mq.height * 0.04),
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color.fromARGB(255, 31, 148, 160),
                      Color.fromARGB(255, 28, 108, 198),
                      Color.fromARGB(255, 175, 68, 239),
                    ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  ),
                ),
                child: _userBar()),
            toolbarHeight: mq.height * 0.05,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: mq.height * 0.8,
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Align(
                                      alignment: Alignment.topRight,
                                      child: MessageCard(message: list[index]));
                                });
                          } else {
                            return const Center(
                              child: Text('Say Hii! 👋',
                                  style: TextStyle(fontSize: 20,
                                  color: Colors.white)),
                            );
                          }
                      }
                    },
                  ),
                ),
                //progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),
                _userInput(),
                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: const Config(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userBar() {
    final mq = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatProfile(
              user: widget.user,
            ),
          ),
        );
      },
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  imageUrl: list.isNotEmpty ? list[0].Image : widget.user.Image,
                  errorWidget: (context, url, error) => Icon(
                    FontAwesomeIcons.circleUser,
                    color: Colors.cyanAccent,
                    size: mq.width * 0.1,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.isNotEmpty ? list[0].Name : widget.user.Name,
                    style: const TextStyle(
                      fontFamily: 'Solitreo',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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
                    style: const TextStyle(
                      fontFamily: 'Solitreo',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.phone,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.videocam,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _userInput() {
    final mq = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: mq.width * 0.8,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(mq.width * 0.6),
            border: Border.all(color: Colors.black45),
          ),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  setState(() => _showEmoji = !_showEmoji);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(0),
                  elevation: 10,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.1),
                  child: Image.asset(
                    'Images/emoji.jpg',
                    fit: BoxFit.cover,
                    height: mq.height * 0.04,
                    width: mq.height * 0.04,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onTap: () {
                    if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Text here...',
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() => _isUploading = !_isUploading);
                    log('ImagePath: ${image.path}');
                    setState(() => _isUploading = !_isUploading);
                  } else {
                    log('Nothing found');
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 10,
                  padding: const EdgeInsets.all(0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.1),
                  child: Image.asset(
                    'Images/camera5.webp',
                    fit: BoxFit.cover,
                    height: mq.height * 0.04,
                    width: mq.height * 0.04,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final List<XFile> image =
                      await picker.pickMultiImage(imageQuality: 80);
                  for (var i in image) {
                    setState(() => _isUploading = !_isUploading);
                    log('ImagePath: ${i.path}');
                    setState(() => _isUploading = !_isUploading);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 10,
                  padding: const EdgeInsets.all(0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.1),
                  child: Image.asset(
                    'Images/Gallery3.webp',
                    fit: BoxFit.cover,
                    height: mq.height * 0.04,
                    width: mq.height * 0.04,
                  ),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text,Type.text);
                _textController.text = '';
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              elevation: 10,
              padding: const EdgeInsets.all(0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * 0.07),
              child: Image.asset(
                'Images/send.webp',
                fit: BoxFit.cover,
                height: mq.height * 0.07,
                width: mq.height * 0.07,
              ),
            )),
      ],
    );
  }
}
