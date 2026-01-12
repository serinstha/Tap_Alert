import 'package:college_project/contact/screen/contact.dart';
import 'package:college_project/map/screen/map.dart';
import 'package:college_project/screen/home_dashboard/alert.dart';
import 'package:college_project/screen/home_dashboard/personalDaasboard.dart';
import 'package:college_project/screen/home_dashboard/setting.dart';
import 'package:college_project/contact/contact_repository/contact_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;
  final repo = ContactRepository();

  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 1); // Alert is center
  }


  List<Widget> _buildScreens() {
    return [
      EmergencyContactPage(uid: user?.uid ?? ""),
      const Alert(),
      const MapScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.phone),
        title: "Contact",
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
       icon:  const Icon(Icons.home,color: Colors.black,),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.map),
        title: "Map",
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Homepage",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo[300],
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Personaldaasboard()),
              );
            },
            child: const Icon(Icons.person),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Setting()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.settings, color: Colors.black),
              ),
            ),
          ],
        ),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          //navBarHeight: 100,
          confineToSafeArea: true,
          backgroundColor: Colors.grey.shade300,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(20),
            colorBehindNavBar: Colors.grey.shade300,
          ),
          navBarStyle:
              NavBarStyle.style15, 
        ),
      ),
    );
  }
}
