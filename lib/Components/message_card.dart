import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usay/Components/date&time.dart';
import 'package:usay/api/api.dart';
import 'package:usay/models/messages.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        //onLongPress: () => _showBottomSheet(isMe),
        child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    final mq = MediaQuery.of(context).size;
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log('Date time updated');
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //message content
      Flexible(
        child: Container(
          padding: EdgeInsets.all(
              mq.width * .04),
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              //making borders curved
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ),
      //message time
      Padding(
        padding: EdgeInsets.only(right: mq.width * 0.4),
        child: Text(
            MyDateTime.getFormattedTime(context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 15, color: Colors.white)
        ),
      )
    ]);
  }

  // our or user message
  Widget _greenMessage() {
    final mq = MediaQuery.of(context).size;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Icon(FontAwesomeIcons.checkDouble),
      const SizedBox(width: 2,),
      //message time
      Padding(
        padding: EdgeInsets.only(right: mq.width * 0.4),
        child: Text(
          MyDateTime.getFormattedTime(context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 15, color: Colors.white)
        ),
      ),
      //message content
      Flexible(
        child: Container(
          padding: EdgeInsets.all(widget.message.type == Type.image
              ? mq.width * .03
              : mq.width * .04),
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 255, 176),
              border: Border.all(color: Colors.lightGreen),
              //making borders curved
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ),
    ]);
  }
}
