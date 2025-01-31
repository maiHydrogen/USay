import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:usay/Pages/calls.dart';
import 'package:usay/Pages/chats.dart';
import 'package:usay/Pages/newchats.dart';
import 'package:usay/Pages/profile.dart';
import 'package:usay/Pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:usay/api/api.dart';
import 'notification.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> with TickerProviderStateMixin {
  // TabController _tabController;
  MotionTabBarController? _motionTabBarController;
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Images/SplashBC.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          key: _key,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            toolbarHeight: MediaQuery.of(context).size.height*0.07,
            title: const Text(
                'Usay',
              ),
            titleTextStyle: const TextStyle(
              fontFamily: 'GreatVibes',
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            leading: IconButton(
              onPressed: () {
                // if (!Platform.isAndroid && !Platform.isIOS) {
                //   _controller.setExtended(true);
                // }
                _key.currentState?.openDrawer();
              },
              icon: const Icon(
                FontAwesomeIcons.bars,
                color: Colors.white,
                size: 26,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:15.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                        Color.fromARGB(255, 31, 148, 160),
                        Color.fromARGB(255, 28, 108, 198),
                        Color.fromARGB(255, 175, 68, 239),
                      ], // Gradient from https://learnui.design/tools/gradient-generator.html
                    ),
                    borderRadius: BorderRadius.circular(100),),
                  child: IconButton(
                    onPressed: () => _key.currentState?.openEndDrawer(),
                    icon: const Icon(
                      FontAwesomeIcons.bell,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          drawer: MyProfile(user: APIs.me),
          endDrawer: const Notifications(),
          bottomNavigationBar: MotionTabBar(
            controller: _motionTabBarController,
            initialSelectedTab: "Chats",
            useSafeArea: true,
            labels: const ["Chats", "New Chat", "Calls", "Settings"],
            icons: const [
              CupertinoIcons.chat_bubble_2_fill,
              CupertinoIcons.add_circled,
              CupertinoIcons.phone,
              CupertinoIcons.gear,
            ],
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 134, 28, 194),
            ),
            tabSize: 40,
            tabBarHeight: 50,
            tabIconColor: Color.fromARGB(255, 134, 28, 194),
            tabIconSize: 40,
            tabIconSelectedSize: 28,
            tabSelectedColor:const Color.fromARGB(255, 134, 28, 194),
            tabIconSelectedColor: Colors.white,
            tabBarColor:Colors.white54,
            onTabItemSelected: (int value) {
              setState(() {
                _motionTabBarController!.index = value;
              });
            },
          ),
          body: SafeArea(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: _motionTabBarController,
              children: <Widget>[
                MyChats(title: "Chats", controller: _motionTabBarController!),
                MyNewChats(
                    title: "NewChats", controller: _motionTabBarController!),
                MyCalls(title: "Calls", controller: _motionTabBarController!),
                MySettings(
                    title: "Settings", controller: _motionTabBarController!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
