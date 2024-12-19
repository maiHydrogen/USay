import 'package:usay/models/chatuser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Chatusercard extends StatefulWidget {
  final ChatUser user;
  const Chatusercard({super.key, required this.user});

  @override
  State<Chatusercard> createState() => _ChatusercardState();
}

class _ChatusercardState extends State<Chatusercard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.symmetric(
            vertical: 4, horizontal: MediaQuery.of(context).size.width * 0.04),
        child: InkWell(
          onTap: () {},
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.1),
              child: CachedNetworkImage(fit: BoxFit.cover,
               width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                imageUrl: widget.user.Image,
                errorWidget: (context, url, error) => Icon(
                  FontAwesomeIcons.circleUser,
                  color: Colors.cyanAccent,
                  size: MediaQuery.of(context).size.width * 0.1,
                ),
              ),
            ),
            title: Text(
              widget.user.Name,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              widget.user.About,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.cyanAccent,
                  borderRadius: BorderRadius.circular(10)),
            ),
            //trailing: const Text('12:00 AM',
            //style: TextStyle(color: Colors.white),),
          ),
        ));
  }
}
