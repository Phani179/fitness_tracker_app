import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fitness_tracker_app/widgets/home_page_drawer.dart';
import 'package:fitness_tracker_app/providers/goals_provider.dart';
import 'package:fitness_tracker_app/screens/achievements.dart';
import 'package:fitness_tracker_app/screens/goals.dart';
import 'package:fitness_tracker_app/providers/user_info_provider.dart';
import 'package:fitness_tracker_app/screens/activities.dart';
import 'package:fitness_tracker_app/services/firebase_instances.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.user, super.key});

  final User user;

  static const routeName = '/HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<bool> _loadData;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _setUpPushNotification();
    _loadData = _fetchData(widget.user);
  }

  void _setUpPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    // final token = await fcm.getToken();
    fcm.subscribeToTopic('fitness');
  }

  Future<bool> _fetchData(User? user) async {
    DataSnapshot dataSnapshot =
        await firebaseDatabase.ref('users/${user?.uid}').get();
    if (context.mounted) {
      Provider.of<UserInfoProvider>(context, listen: false)
          .addUserData(dataSnapshot.value as Map<Object?, Object?>);
      Provider.of<GoalsProvider>(context, listen: false)
          .changeDailyStepsGoalCount((dataSnapshot.value
              as Map<Object?, Object?>)['dailyGoal'] as int);
      Provider.of<GoalsProvider>(context, listen: false)
          .changeWeeklyStepsGoalCount((dataSnapshot.value
              as Map<Object?, Object?>)['weeklyGoal'] as int);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            key: scaffoldKey,
            drawer: const HomePageDrawer(),
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  }),
              title: const Text(
                'Fitness Tracker',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.teal,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AchievementsScreen.routeName);
                  },
                  icon: const Icon(
                    Icons.star_border,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: firebaseAuth.signOut,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body:  FutureBuilder(
                future: _loadData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                return _selectedIndex == 0 ? const ActivitiesScreen() : const GoalsScreen();
              }
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index){
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedLabelStyle: const TextStyle(fontSize: 18, color: Colors.teal),
              unselectedLabelStyle: const TextStyle(fontSize: 16, color: Colors.teal),
              items: const [
                BottomNavigationBarItem(
                  label: 'Activities',
                  icon: Icon(Icons.access_time),
                ),
                BottomNavigationBarItem(
                  label: 'Goals',
                  icon: Icon(Icons.radar),
                ),
              ],
            ),
          );
  }
}
