import 'package:templet/fitness_app/ui_view/wave_view.dart';
import 'package:templet/wave/config.dart';
import 'package:templet/wave/wave.dart';

import 'app_theme.dart';
import 'custom_drawer/drawer_user_controller.dart';
import 'custom_drawer/home_drawer.dart';
import 'feedback_screen.dart';
import 'help_screen.dart';
import 'home_screen.dart';
import 'invite_friend_screen.dart';
import 'package:flutter/material.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: AppTheme.nearlyWhite,
            body: Center(
                child: Container(
              width: 200,
              height: 400,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                  borderRadius: BorderRadius.circular(100)),
              child: WaveView(),
              // child: WaveWidget(
              //   config: CustomConfig(
              //     gradients: [
              //       [Colors.red, Color(0xEEF44336)],
              //       [Colors.red[800], Color(0x77E57373)],
              //       [Colors.orange, Color(0x66FF9800)],
              //       [Colors.yellow, Color(0x55FFEB3B)]
              //     ],
              //     durations: [35000, 19440, 10800, 6000],
              //     heightPercentages: [0.20, 0.23, 0.25, 0.30],
              //     blur: MaskFilter.blur(BlurStyle.solid, 10),
              //     gradientBegin: Alignment.bottomLeft,
              //     gradientEnd: Alignment.topRight,
              //   ),
              //   waveAmplitude: 0,
              //   heightPercentange: 0.2,
              //   backgroundColor: Colors.white,
              //   size: Size(
              //     double.infinity,
              //     double.infinity,
              //   ),
              // )
            ))),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = HelpScreen();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = FeedbackScreen();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = InviteFriend();
        });
      } else {
        //do in your way......
      }
    }
  }
}
