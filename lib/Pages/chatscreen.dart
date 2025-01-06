
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usay/Components/date&time.dart';
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
        onTap: () => FocusScope.of(context).unfocus(),
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
                SizedBox(
                  height: mq.height * 0.75,
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
                                  style: TextStyle(fontSize: 20)),
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
    ));
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
          borderRadius: BorderRadius.circular(mq.width * 0.1),
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
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.cyanAccent,
              ),
            ),
            Text(
              MyDateTime.getLastActiveTime(
                  context: context, lastActive: widget.user.lastActive),
              style: TextStyle(
                fontFamily: 'Solitreo',
                fontSize: mq.width * 0.03,
                fontWeight: FontWeight.w500,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
        SizedBox(
          width: mq.width * 0.3,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            FontAwesomeIcons.phone,
            color: Colors.cyanAccent,
            size: mq.width * 0.07,
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
                      log('ImagePath: ${image.path}');
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
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      log('ImagePath: ${image.path}');
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
                  APIs.sendMessage(widget.user, _textController.text);
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
      ),
    );
  }
}
