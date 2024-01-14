
import 'package:flutter/material.dart';

class GoalsProvider extends ChangeNotifier
{
  int dailyStepsGoal = 1000;
  int weeklyStepsGoal = 10000;

  void changeDailyStepsGoalCount(int goal)
  {
    dailyStepsGoal = goal;
    notifyListeners();
  }

  void changeWeeklyStepsGoalCount(int goal)
  {
    weeklyStepsGoal = goal;
    notifyListeners();
  }
}