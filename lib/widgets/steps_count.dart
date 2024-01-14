
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/providers/user_info_provider.dart';
import 'package:fitness_tracker_app/services/firebase_instances.dart';
import 'package:fitness_tracker_app/services/steps_to_calories.dart';

class StepsCountWidget extends StatefulWidget {
  const StepsCountWidget({required this.steps, required this.goal, super.key});

  final int steps;
  final int goal;

  @override
  State<StepsCountWidget> createState() => _StepsCountWidgetState();
}

class _StepsCountWidgetState extends State<StepsCountWidget> {
  late StreamSubscription<StepCount> _stepCountSubscription;
  late StreamSubscription<PedestrianStatus> _pedestrianStatusSubscription;
  String _status = '?';

  @override
  void initState() {
    super.initState();
    if (mounted) {
      initPlatformState();
    } else {
      _pedestrianStatusSubscription.cancel();
      _stepCountSubscription.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pedestrianStatusSubscription.cancel();
    _stepCountSubscription.cancel();
  }

  void onStepCount(StepCount event) {
    if (previousSteps == event.steps) {
      return;
    }
    steps = Provider.of<UserInfoProvider>(context, listen: false).steps[
            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']
        as int;
    if (event.timeStamp.year >= previousEventTime!.year &&
        event.timeStamp.month >= previousEventTime!.month &&
        event.timeStamp.day > previousEventTime!.day) {
      count = count + steps;
      steps = 0;
      previousEventTime = event.timeStamp;
    }
    if (context.mounted) {
      if (count == 0) {
        count = event.steps;
        return;
      }
      steps = steps + (event.steps - count).abs();
      Provider.of<UserInfoProvider>(context, listen: false).addSteps(
          '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
          steps);
      _saveToFirebase(steps);
    }
    previousSteps = event.steps;
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (context.mounted) {
      setState(() {
        _status = event.status;
      });
    }
  }

  void _saveToFirebase(int steps) {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      DatabaseReference firebaseDatabaseRef =
          firebaseDatabase.ref('users/${user.uid}/steps');
      firebaseDatabaseRef.update({
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}':
            steps,
      });
    }
  }

  void initPlatformState() {
    _pedestrianStatusSubscription =
        Pedometer.pedestrianStatusStream.listen(onPedestrianStatusChanged);
    _stepCountSubscription = Pedometer.stepCountStream.listen(onStepCount);
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    double percentage = widget.steps / widget.goal;
    bool isDailyGoalAchieved = widget.steps >= widget.goal;
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: percentage,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: CupertinoColors.lightBackgroundGray,
                    valueColor: const AlwaysStoppedAnimation(Colors.teal),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isDailyGoalAchieved
                        ? SizedBox(
                            child: Column(
                              children: [
                                Text(
                                  'Goal Achieved 🔥',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.pinkAccent),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Consumer<UserInfoProvider>(builder:
                                        (context, userInfoProvider, child) {
                                      return Text(
                                        userInfoProvider.steps[
                                                '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20,
                                              color: Colors.teal,
                                            ),
                                      );
                                    }),
                                    _status == 'walking'
                                        ? const Icon(Icons.directions_run,
                                            size: 18, color: Colors.teal)
                                        : const Icon(Icons.man,
                                            size: 18, color: Colors.teal),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Consumer<UserInfoProvider>(
                            builder: (context, userInfoProvider, child) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  userInfoProvider.steps[
                                          '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}']
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 40,
                                          color: Colors.teal),
                                ),
                                _status == 'walking'
                                    ? const Icon(Icons.directions_run,
                                        size: 30, color: Colors.teal)
                                    : const Icon(Icons.man,
                                        size: 30, color: Colors.teal),
                              ],
                            );
                          }),
                    Text(
                      'Steps',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                      width: 150,
                      child: Divider(
                        color: Colors.teal.withOpacity(0.4),
                      ),
                    ),
                    Text(
                      'Goal : ${widget.goal} Steps',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.teal),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
