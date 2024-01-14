
import 'package:flutter/material.dart';

class UserInfoProvider extends ChangeNotifier
{
  late String userName;
  late String age;
  late double height;
  double weight = 0;
  late String email;
  late String objectives;
  Map<Object?, Object?> steps = {'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}' : 0};

  void addUserData(Map<Object?, Object?> userData)
  {
    userName = userData['userName'] as String;
    email = userData['email'] as String;
    age = userData['age'] as String;
    height = double.parse(userData['height'].toString());
    weight = double.parse(userData['weight'].toString());
    objectives = userData['objectives'] as String;
    steps = userData['steps'] as Map<Object?, Object?>;
    if(!_addNewDate(steps))
      {
        steps['${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}'] = 0;
      }
    notifyListeners();
  }

  bool _addNewDate(Map<Object?, Object?> stepsList)
  {
    List<Object?> dates = [...stepsList.keys.toList()];
    List<DateTime> formattedDates = [];
    for(final date in dates)
    {
      List<String>? splittedDate = (date as String).split('-');
      DateTime formattedDate = DateTime(int.parse(splittedDate[2]), int.parse(splittedDate[1]), int.parse(splittedDate[0]));
      formattedDates.add(formattedDate);
    }
    final DateTime today = DateTime.now();
    for(final date in formattedDates)
    {
      if(date.year == today.year && date.month == today.month && date.day == today.day)
      {
       return true;
      }
    }
    return false;
  }
}