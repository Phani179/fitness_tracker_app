
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/providers/user_info_provider.dart';
import 'package:fitness_tracker_app/services/steps_to_calories.dart';
import 'package:fitness_tracker_app/widgets/daily_activity.dart';
import 'package:fitness_tracker_app/widgets/steps_count.dart';
import 'package:fitness_tracker_app/providers/goals_provider.dart';
import 'package:fitness_tracker_app/widgets/activity.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: Consumer2<UserInfoProvider, GoalsProvider>(
                builder: (context, userInfoProvider, goalsProvider, child) {
                  return StepsCountWidget(steps: (userInfoProvider.steps['${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']! as int), goal: goalsProvider.dailyStepsGoal,);
                }
              ),
            ),
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔥'),
                      Consumer<UserInfoProvider>(
                        builder: (context, userInfoProvider, child) {
                          int caloriesBurned = calculateCaloriesBurned(
                              userInfoProvider.steps['${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']! as int,
                              userInfoProvider.weight)
                              .toInt();
                          return Text(
                            '$caloriesBurned',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                          );
                        }
                      ),
                      Text(
                        'Kcal burnt',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    thickness: 2,
                  ),
                  const ActivityWidget(),
                  const VerticalDivider(
                    thickness: 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.red.withOpacity(0.9),
                      ),
                      Consumer<UserInfoProvider>(
                          builder: (context, userInfoProvider, child) {
                            String distance = distanceCovered(
                                Provider.of<UserInfoProvider>(context, listen: false).steps['${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']! as int)
                                .toStringAsFixed(2);
                          return Text(
                            '$distance KM',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                          );
                        }
                      ),
                      Text(
                        'Distance',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const DailyActivityWidget(),
          ],
        ),
      ),
    );
  }
}
