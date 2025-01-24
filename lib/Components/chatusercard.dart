import 'package:usay/Components/date&time.dart';
import 'package:usay/Components/dialogs.dart';
import 'package:usay/Pages/chatscreen.dart';
import 'package:usay/api/api.dart';
import 'package:usay/models/chatuser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usay/models/messages.dart';

class Chatusercard extends StatefulWidget {
  final ChatUser user;
  const Chatusercard({super.key, required this.user});

  @override
  State<Chatusercard> createState() => _ChatusercardState();
}

class _ChatusercardState extends State<Chatusercard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        color: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(
            vertical: 4, horizontal: MediaQuery.of(context).size.width * 0.04),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  user: widget.user,
                ),
              ),
            );
          },
          child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) _message = list[0];
                return ListTile(
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(user: widget.user));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.1),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.width * 0.12,
                        imageUrl: widget.user.Image,
                        errorWidget: (context, url, error) => Icon(
                          FontAwesomeIcons.circleUser,
                          color: Colors.cyan,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    widget.user.Name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'image'
                            : _message!.msg
                        : widget.user.About,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: _message == null
                      ? null //show nothing when no message is sent
                      : _message!.read.isEmpty &&
                              _message!.fromId != APIs.user.uid
                          ? Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.cyanAccent,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          :
                          //message sent time
                          Text(
                              MyDateTime.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: const TextStyle(color: Colors.black54),
                            ),
                  //trailing: const Text('12:00 AM',
                  //style: TextStyle(color: Colors.white),),
                );
              }),
        ));
  }
}
