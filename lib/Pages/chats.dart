import 'package:flutter/cupertino.dart';
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
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  centerTitle: true,
                  title: Container(
                    decoration: const BoxDecoration(
                      backgroundBlendMode: BlendMode.src,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          Color.fromARGB(255, 31, 148, 160),
                          Color.fromARGB(255, 28, 108, 198),
                          Color.fromARGB(255, 175, 68, 239),
                        ], // Gradient from https://learnui.design/tools/gradient-generator.html
                        tileMode: TileMode.mirror,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 50,
                    child: Card(
                      color: Colors.white70,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: Icon(
                              _isSearching
                                  ? CupertinoIcons.clear_circled
                                  : FontAwesomeIcons.magnifyingGlass,
                              color: Colors.black54,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isSearching = !_isSearching;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearching = true;
                              });
                            },
                            child: SizedBox.fromSize(
                              size: Size.fromWidth(
                                  MediaQuery.of(context).size.width * 0.695),
                              child: _isSearching
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Name or Email',
                                            hintStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 18,
                                              fontFamily: 'kalam',
                                            )),
                                        autofocus: true,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontFamily: 'kalam',
                                        ),
                                        onChanged: (val) {
                                          _searchList.clear();
                                          for (var i in _list) {
                                            if (i.Name.toLowerCase().contains(
                                                    val.toLowerCase()) ||
                                                i.email.toLowerCase().contains(
                                                    val.toLowerCase())) {
                                              _searchList.add(i);
                                              setState(() {
                                                _searchList;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: const Text(
                                        "Search",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 18,
                                          fontFamily: 'kalam',
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SingleChildScrollView(
                        child: Column(children: [
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
                                      stream: APIs.getAllUsers(snapshot
                                              .data?.docs
                                              .map((e) => e.id)
                                              .toList() ??
                                          []),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          //if data is loading
                                          case ConnectionState.waiting:
                                          case ConnectionState.none:
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());

                                          //if some or all data is loaded then show it
                                          case ConnectionState.active:
                                          case ConnectionState.done:
                                            final data = snapshot.data?.docs;
                                            _list = data
                                                    ?.map((e) =>
                                                        ChatUser.fromJson(
                                                            e.data()))
                                                    .toList() ??
                                                [];

                                            if (_list.isNotEmpty) {
                                              return ListView.builder(
                                                itemCount: _isSearching
                                                    ? _searchList.length
                                                    : _list.length,
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                shrinkWrap: true,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Chatusercard(
                                                      user: _isSearching
                                                          ? _searchList[index]
                                                          : _list[index]);
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
                                                child: const Text(
                                                    'No Chats Found!',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.cyan)),
                                              );
                                            }
                                        }
                                      });
                              }
                            },
                          ),
                        ]),
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
