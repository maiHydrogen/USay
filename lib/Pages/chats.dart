import 'package:usay/Components/chatusercard.dart';
import 'package:usay/api/api.dart';
import 'package:usay/models/chatuser.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class MyChats extends StatefulWidget {
  const MyChats({super.key, required this.title, required this.controller});
  final String title;
  final MotionTabBarController controller;

  @override
  State<MyChats> createState() => MyChatsState();
}

class MyChatsState extends State<MyChats> {
  List<ChatUser> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: Container(
              decoration: BoxDecoration(
                backgroundBlendMode: BlendMode.src,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(1, 1),
                  colors: <Color>[
                    Color(0x00000000),
                    Color.fromARGB(255, 21, 135, 152),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  tileMode: TileMode.mirror,
                ),
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              height: 50,
              child: const Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Search",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'kalam',
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                      stream: APIs.getMyUsersId(),

                      //get id of only known user
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //if data is loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                                child: CircularProgressIndicator());

                          //if some or all data is loaded then show it
                          case ConnectionState.active:
                          case ConnectionState.done:
                            return StreamBuilder(
                                //get only those user, who's ids are provided
                                stream: APIs.getAllUsers(snapshot.data?.docs
                                        .map((e) => e.id)
                                        .toList() ??
                                    []),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    //if data is loading
                                    case ConnectionState.waiting:
                                    case ConnectionState.none:
                                    // return const Center(
                                    //     child: CircularProgressIndicator());

                                    //if some or all data is loaded then show it
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      final data = snapshot.data?.docs;
                                      list = data
                                              ?.map((e) =>
                                                  ChatUser.fromJson(e.data()))
                                              .toList() ??
                                          [];

                                      if (list.isNotEmpty) {
                                        return ListView.builder(
                                          itemCount: list.length,
                                          padding: EdgeInsetsDirectional.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Chatusercard(
                                                user: list[index]);
                                            //return Text('Name: ${list[index]}');
                                          },
                                        );
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.38,
                                          ),
                                          child: const Text('No Chats Found!',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.cyan)),
                                        );
                                      }
                                  }
                                });
                        }
                      }),
                ],
              ),
            )
          ]))
        ],
      ),
    );
  }
}
