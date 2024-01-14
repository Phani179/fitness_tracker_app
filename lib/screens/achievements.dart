
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/providers/user_info_provider.dart';
import 'package:fitness_tracker_app/services/steps_to_calories.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  static const String routeName = '/Achievements';

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {

  List<int> stepsAchievements = [100, 1000, 2000, 5000, 7500, 10000, 15000, 20000, 30000];

  List<int> distanceAchievements = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  List<int> calorieAchievements = [10, 20, 50, 70, 100, 130, 150];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: const Text(
          'Achievements',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 5),
            child: Text(
              'Daily Steps',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stepsAchievements.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: 140,
                  width: 100,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<UserInfoProvider>(
                            builder: (context, userInfoProvider, child) {
                          int steps = userInfoProvider.steps[
                                  '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']
                              as int;
                          return SvgPicture.asset(
                            'assets/images/achievement.svg',
                            height: 60,
                            colorFilter: steps > stepsAchievements[index]
                                ? null
                                : const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${stepsAchievements[index]}',
                          style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 5),
            child: Text(
              'Distance',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: distanceAchievements.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: 140,
                  width: 100,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<UserInfoProvider>(
                            builder: (context, userInfoProvider, child) {
                          int steps = userInfoProvider.steps[
                                  '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']
                              as int;
                          double distance = distanceCovered(steps);
                          return SvgPicture.asset(
                            'assets/images/achievement.svg',
                            height: 60,
                            colorFilter: distance > distanceAchievements[index]
                                ? null
                                : const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${distanceAchievements[index]} KM',
                          style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, top: 5),
            child: Text(
              'Calories',
              style: TextStyle(
                  color: Colors.teal,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: calorieAchievements.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  height: 140,
                  width: 100,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<UserInfoProvider>(
                            builder: (context, userInfoProvider, child) {
                          int steps = userInfoProvider.steps[
                                  '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']
                              as int;
                          double calories = calculateCaloriesBurned(
                              steps, userInfoProvider.weight);
                          return SvgPicture.asset(
                            'assets/images/achievement.svg',
                            height: 60,
                            colorFilter: calories > calorieAchievements[index]
                                ? null
                                : const ColorFilter.mode(
                                    Colors.grey,
                                    BlendMode.srcIn,
                                  ),
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${calorieAchievements[index]} Kcal',
                          style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
