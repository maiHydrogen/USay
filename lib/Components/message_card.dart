import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:usay/Components/date&time.dart';
import 'package:usay/Components/dialogs.dart';
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
        onTap: () => FocusScope.of(context).unfocus(),
        onLongPress: (){
          FocusScope.of(context).unfocus();
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    final mq = MediaQuery.of(context).size;
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //message content
      Flexible(
        child: Container(
          padding: EdgeInsets.all(mq.width * .03),
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .03, vertical: mq.height * .01),
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
            MyDateTime.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 15, color: Colors.white)),
      )
    ]);
  }

  // our or user message
  Widget _greenMessage() {
    final mq = MediaQuery.of(context).size;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      if (widget.message.read.isNotEmpty)
        const Icon(FontAwesomeIcons.checkDouble, color: Colors.blue, size: 20),

      const SizedBox(
        width: 2,
      ),
      //message time
      Padding(
        padding: EdgeInsets.only(right: mq.width * 0.4),
        child: Text(
            MyDateTime.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 15, color: Colors.white)),
      ),
      //message content
      Flexible(
        child: Container(
          padding: EdgeInsets.all(widget.message.type == Type.image
              ? mq.width * .02
              : mq.width * .03),
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .03, vertical: mq.height * .01),
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

  //showing the bottomsheet
  void _showBottomSheet(isMe) {
    final mq = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03),
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: (ctx) async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          if (ctx.mounted) {
                            //for hiding bottom sheet
                            Navigator.pop(ctx);

                            Dialogs.showSnackBar(ctx, 'Text Copied!');
                          }
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: (ctx) async {
                        try {
                      log('Image Url: ${widget.message.msg}');
                      await GallerySaver.saveImage(widget.message.msg,
                          albumName: 'We Chat')
                          .then((success) {
                        if (ctx.mounted) {
                          //for hiding bottom sheet
                          Navigator.pop(ctx);
                          if (success != null && success) {
                            Dialogs.showSnackBar(
                                ctx, 'Image Successfully Saved!');
                          }
                        }
                      });
                    } catch (e) {
                      log('ErrorWhileSavingImg: $e');
                    }
                      }),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: (ctx) {
                      if (ctx.mounted) {
                        _showMessageUpdateDialog(ctx);

                        //for hiding bottom sheet
                        Navigator.pop(ctx);
                      }
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: (ctx) async {
                      //await APIs.deleteMessage(widget.message).then(
                        //(value) {
                          //for hiding bottom sheet
                          //if (ctx.mounted) Navigator.pop(ctx);
                        //},
                      //);
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateTime.getMessageTime(time: widget.message.sent)}',
                  onTap: (_) {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateTime.getMessageTime(time: widget.message.read)}',
                  onTap: (_) {}),
            ],
          );
        });
  }
  //dialog for updating message content
  void _showMessageUpdateDialog(final BuildContext ctx) {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: ctx,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),

          //title
          title: const Row(
            children: [
              Icon(
                Icons.message,
                color: Colors.blue,
                size: 28,
              ),
              Text(' Update Message')
            ],
          ),

          //content
          content: TextFormField(
            initialValue: updatedMsg,
            maxLines: null,
            onChanged: (value) => updatedMsg = value,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
          ),

          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )),

            //update button
            MaterialButton(
                onPressed: () {
                  APIs.updateMessage(widget.message, updatedMsg);
                  //hide alert dialog
                  Navigator.pop(ctx);

                  //for hiding bottom sheet
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ))
          ],
        ));
  }
}
//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final Function(BuildContext) onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return InkWell(
        onTap: () => onTap(context),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}