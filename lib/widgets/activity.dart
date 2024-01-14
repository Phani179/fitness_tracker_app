
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

class ActivityWidget extends StatefulWidget {
  const ActivityWidget({super.key});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  final activityRecognition = FlutterActivityRecognition.instance;
  final StreamController<Activity> _activityStreamController =
      StreamController<Activity>.broadcast();
  StreamSubscription<Activity>? _activityStreamSubscription;

  @override
  initState() {
    super.initState();
    isPermissionGrants();
    if(mounted)
      {
        _activityStreamSubscription =
            activityRecognition.activityStream.listen(_onActivity);
      }
    else
      {
        _activityStreamController.close();
      }
  }

  Future<bool> isPermissionGrants() async {
    // Check if the user has granted permission. If not, request permission.
    PermissionRequestResult reqResult;
    reqResult = await activityRecognition.checkPermission();
    if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
      return false;
    } else if (reqResult == PermissionRequestResult.DENIED) {
      reqResult = await activityRecognition.requestPermission();
      if (reqResult != PermissionRequestResult.GRANTED) {
        return false;
      }
    }
    return true;
  }

  void _onActivity(Activity activity) {
    _activityStreamController.sink.add(activity);
  }

  @override
  void dispose() {
    _activityStreamController.close();
    _activityStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: StreamBuilder<Activity>(
        stream: _activityStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.device_unknown, color: Colors.teal),
                      Text(
                        'UNKNOWN',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Activity',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if ((snapshot.data as Activity).type == ActivityType.STILL)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.man, color: Colors.teal),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Standing',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                if ((snapshot.data as Activity).type == ActivityType.WALKING)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.directions_run, color: Colors.teal),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Walking',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                if ((snapshot.data as Activity).type == ActivityType.RUNNING)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.directions_run, color: Colors.teal),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Running',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                if ((snapshot.data as Activity).type == ActivityType.ON_BICYCLE)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.directions_bike, color: Colors.teal),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Cycling',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                if ((snapshot.data as Activity).type == ActivityType.IN_VEHICLE)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.local_taxi, color: Colors.teal),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'In Vechile',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                if ((snapshot.data as Activity).type == ActivityType.UNKNOWN)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.device_unknown, color: Colors.teal),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'UNKNOWN',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                Text(
                  'Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
