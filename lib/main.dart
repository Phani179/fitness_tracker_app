
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/firebase_options.dart';
import 'package:fitness_tracker_app/providers/auth_provider.dart';
import 'package:fitness_tracker_app/providers/goals_provider.dart';
import 'package:fitness_tracker_app/providers/user_info_provider.dart';
import 'package:fitness_tracker_app/screens/auth.dart';
import 'package:fitness_tracker_app/screens/home.dart';
import 'package:fitness_tracker_app/services/firebase_instances.dart';
import 'package:fitness_tracker_app/services/route_generator.dart';


ColorScheme kColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.teal);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserInfoProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => GoalsProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: kColorScheme,
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        onGenerateRoute: RouteGenerator().onGenerateRoute,
        // initialRoute: AuthScreen.routeName,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: firebaseAuth.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            if (snapshot.hasData) {
              return HomeScreen(
                user: snapshot.data as User,
              );
            } else {
              return const AuthScreen();
            }
          },
        ),
      ),
    );
  }
}
