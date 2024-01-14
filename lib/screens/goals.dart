
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/services/firebase_instances.dart';
import 'package:fitness_tracker_app/providers/goals_provider.dart';
import 'package:fitness_tracker_app/widgets/set_goal.dart';
import 'package:fitness_tracker_app/widgets/steps_count.dart';
import 'package:fitness_tracker_app/providers/user_info_provider.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  _modifyDailyGoal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: SetGoalWidget(
            saveToFirebase: _saveDailyGoalToFirebase,
          ),
        );
      },
    );
  }

  _modifyWeeklyGoal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: SetGoalWidget(
            saveToFirebase: _saveWeeklyGoalToFirebase,
          ),
        );
      },
    );
  }

  _saveDailyGoalToFirebase(int steps) {
    Provider.of<GoalsProvider>(context, listen: false).changeDailyStepsGoalCount(steps);
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      firebaseDatabase.ref('users/${user.uid}').update({
        'dailyGoal': steps,
      });
    }
  }

  _saveWeeklyGoalToFirebase(int steps) {
    Provider.of<GoalsProvider>(context, listen: false).changeWeeklyStepsGoalCount(steps);
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      firebaseDatabase.ref('users/${user.uid}').update({
        'weeklyGoal': steps,
      });
    }
  }

  int _totalStepsOfThisWeek(Map<Object?, Object?> stepsList)
  {
    List<Object?> dates = [...stepsList.keys.toList()];
    List<DateTime> formattedDates = [];
    int steps = 0;
    for(final date in dates)
    {
      List<String>? splittedDate = (date as String).split('-');
      DateTime formattedDate = DateTime(int.parse(splittedDate[2]), int.parse(splittedDate[1]), int.parse(splittedDate[0]));
      formattedDates.add(formattedDate);
    }
    final DateTime today = DateTime.now();
    for(final date in formattedDates)
      {
        if(date.year == today.year && date.month == today.month)
          {
            int diff = (date.day - today.day).abs();
            if(diff < today.weekday)
              {
                 steps = steps + (stepsList['${date.day}-${date.month}-${date.year}'] as int);
              }
          }
      }
    return steps;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: _modifyDailyGoal,
            child: const Text(
              'Modify daily goal',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 300,
            child: Consumer2<UserInfoProvider, GoalsProvider>(
                builder: (context, userInfoProvider, goalsProvider, child) {
              return StepsCountWidget(
                steps: (userInfoProvider.steps[
                        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']!
                    as int),
                goal: goalsProvider.dailyStepsGoal,
              );
            }),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: _modifyWeeklyGoal,
            child: const Text(
              'Modify weekly goal',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 300,
            child: Consumer2<UserInfoProvider, GoalsProvider>(
                builder: (context, userInfoProvider, goalsProvider, child) {
                 int totalSteps = _totalStepsOfThisWeek(userInfoProvider.steps);
              return StepsCountWidget(
                steps: totalSteps,
                goal: goalsProvider.weeklyStepsGoal,
              );
            }),
          ),
        ],
      ),
    );
  }
}
