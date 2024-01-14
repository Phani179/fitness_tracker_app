
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/providers/user_info_provider.dart';

class DailyActivityWidget extends StatefulWidget {
  const DailyActivityWidget({super.key});

  @override
  State<DailyActivityWidget> createState() => _DailyActivityWidgetState();
}

class _DailyActivityWidgetState extends State<DailyActivityWidget> {

  int maxSteps(final steps)
  {
    int maxSteps = 0;
    for(final i in steps.keys)
      {
        maxSteps = max(maxSteps, steps[i]);
      }
    return maxSteps;
  }

  List<String> _orderDates(List<Object?> dates)
  {
    List<DateTime> formattedDates = [];
    List<String> orderedDates = [];
    for(final date in dates)
      {
        List<String>? splittedDate = (date as String).split('-');
        DateTime formattedDate = DateTime(int.parse(splittedDate[2]), int.parse(splittedDate[1]), int.parse(splittedDate[0]));
        formattedDates.add(formattedDate);
      }
    for(int i = 0; i < formattedDates.length - 1; i++)
      {
        for(int j = i + 1; j < formattedDates.length ; j++)
          {
            if(formattedDates[i].isAfter(formattedDates[j]))
              {
                DateTime temp = formattedDates[i];
                formattedDates[i] = formattedDates[j];
                formattedDates[j] = temp;
              }
          }
      }
    
    for(final date in formattedDates)
      {
        String format = '${date.day}-${date.month}-${date.year}';
        orderedDates.add(format);
      }
    return orderedDates;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          elevation: 10,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Daily Activity',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Consumer<UserInfoProvider>(
                builder: (context, userInfoProvider, child) {
                  int highestSteps = maxSteps(userInfoProvider.steps);
                  List<String> keys = _orderDates(userInfoProvider.steps.keys.toList());
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for(final date in keys)
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(userInfoProvider.steps[date]!.toString(), style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height : 260,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: FractionallySizedBox(
                                    alignment: Alignment.bottomCenter,
                                    heightFactor: highestSteps == 0 ? 0 : (userInfoProvider.steps[date]! as int)/highestSteps,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                date.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                              ),
                                const SizedBox(
                                  height: 10,
                                ),
                            ],
                            ),
                          )
                      ],
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
