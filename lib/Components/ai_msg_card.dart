import 'package:lottie/lottie.dart';
import 'package:usay/Components/profileimage.dart';
import 'package:flutter/material.dart';
import 'package:usay/models/messages.dart';

class AiMessageCard extends StatelessWidget {
  final AiMessage message;

  const AiMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    const r = Radius.circular(15);
    return message.msgType == MessageType.bot

    //bot
        ? Row(children: [
      const SizedBox(width: 6),

      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        child: Image.asset('Images/chatbot.png', width: 80),
      ),

      //
      Container(
        constraints: BoxConstraints(maxWidth: mq.width * .6),
        margin: EdgeInsets.only(
            bottom: mq.height * .02, left: mq.width * .02),
        padding: EdgeInsets.symmetric(
            vertical: mq.height * .01, horizontal: mq.width * .02),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: const BorderRadius.only(
                topLeft: r, topRight: r, bottomRight: r)),
        child: message.msg.isEmpty
            ? Lottie.asset('lib/models/ai.json', width: 35)
            : Text(message.msg, textAlign: TextAlign.center,style: const TextStyle(color: Colors.white),),
      )
    ])

    //user
        : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      //
      Container(
          constraints: BoxConstraints(maxWidth: mq.width * .6),
          margin: EdgeInsets.only(
              bottom: mq.height * .02, right: mq.width * .02),
          padding: EdgeInsets.symmetric(
              vertical: mq.height * .01, horizontal: mq.width * .02),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: const BorderRadius.only(
                  topLeft: r, topRight: r, bottomLeft: r)),
          child: Text(
            message.msg,
            textAlign: TextAlign.center,
          )),

      const ProfileImage(size: 35),

      const SizedBox(width: 6),
    ]);
  }
}