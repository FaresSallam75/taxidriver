import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:chat/constant/class/colors.dart';
import 'package:chat/constant/functions/notifications.dart';
import 'package:chat/constant/functions/showalertdialog.dart';
import 'package:chat/presentation/screens/user/account.dart';
import 'package:chat/presentation/screens/user/activity.dart';
import 'package:chat/presentation/screens/user/home.dart';
import 'package:chat/presentation/screens/user/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}
  // hello //
List<Map> navigationBarItems = [
  {'icon': Icons.home, 'index': 0, "label": "Home"},
  {'icon': Icons.apps_rounded, 'index': 1, "label": "Services"},

  {'icon': Icons.receipt, 'index': 2, "label": "Activity"},
  {'icon': Icons.person, 'index': 3, "label": "Account"},
];

class _HomeState extends State<MainHome> {
  int _selectedIndex = 0;
  // ignore: strict_top_level_inference
  void goToPages(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    startOnInital(context, "booking");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HomeScreen(),
      const Services(),
      const Activity(),
      const Account(),
      // const DriversLocation(),
    ];

    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        List<ConnectivityResult> connectivity,
        Widget child,
      ) {
        final bool connected = !connectivity.contains(ConnectivityResult.none);
        if (!connected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              functionShowAlertDialog(
                context,
                "Connection Failed",
                "Please Check Your Internet Connection",
                "OK",
                "Setting",
                () {
                  Navigator.of(context).pop();
                },
                () {
                  AppSettings.openAppSettings(type: AppSettingsType.wifi);
                  Navigator.of(context).pop();
                },
              );
            }
          });

          return Scaffold(
            body: Center(
              child: Column(
                children: const [
                  Icon(Icons.signal_wifi_off, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Internet Connection',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        return child;
      },
      child: customLoadedScreen(screens),
    );
  }

  Widget customLoadedScreen(List<Widget> screens) {
    return Scaffold(
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () {
          showAlertDialog(
            context,
            "Watchout",
            "Are You Sure To Exit From App .",
            () {
              exit(0);
            },
            () {
              Navigator.of(context).pop();
            },
          );
          return Future.value(false);
        },
        child: SafeArea(child: screens[_selectedIndex]),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        mouseCursor: WidgetStateMouseCursor.textable,

        type: BottomNavigationBarType.fixed,

        backgroundColor: MyColors.grey01,

        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: [
          for (var navigationBarItem in navigationBarItems)
            BottomNavigationBarItem(
              activeIcon: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                height: 40.0,

                child: Column(
                  children: [
                    Expanded(
                      child: Icon(
                        navigationBarItem['icon'],
                        size: 20,
                        color:
                            _selectedIndex == navigationBarItem['index']
                                ? MyColors.black
                                : MyColors.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Text(
                          "${navigationBarItem['label']}",
                          style: TextStyle(
                            fontSize: 12.0,
                            color:
                                _selectedIndex == navigationBarItem['index']
                                    ? MyColors.black
                                    : MyColors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              icon: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        _selectedIndex == navigationBarItem['index']
                            ? const BorderSide(color: (MyColors.bg), width: 5)
                            : BorderSide.none,
                  ),
                ),
                child: Icon(
                  navigationBarItem['icon'],
                  color:
                      _selectedIndex == navigationBarItem['index']
                          ? (MyColors.bg)
                          : (MyColors.purple01),
                ),
              ),
              label: '',
            ),
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          goToPages(value);
        },
      ),
    );
  }
}
