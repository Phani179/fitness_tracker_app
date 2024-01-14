
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/providers/auth_provider.dart';
import 'package:fitness_tracker_app/providers/user_info_provider.dart';
import 'package:fitness_tracker_app/services/firebase_instances.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/AuthScreen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  String? enteredUserName;
  String? enteredAge;
  double? enteredHeight;
  double? enteredWeight;
  String? enteredEmail;
  String? enteredPassword;
  String? enteredConfirmPassword;

  Future<void> _onSubmitted() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      if (!Provider.of<AuthStateProvider>(context, listen: false).isLogin &&
          enteredPassword != enteredConfirmPassword) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Password and Confirm Password needs to be same',
            ),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: ScaffoldMessenger.of(context).clearSnackBars,
            ),
          ),
        );
      } else {
        try {
          if (Provider.of<AuthStateProvider>(context, listen: false).isLogin) {
            UserCredential userCredential =
                await firebaseAuth.signInWithEmailAndPassword(
              email: enteredEmail!,
              password: enteredPassword!,
            );
            DataSnapshot dataSnapshot = await firebaseDatabase
                .ref('users/${userCredential.user?.uid}')
                .get();
            if (context.mounted) {
              Provider.of<UserInfoProvider>(context, listen: false)
                  .addUserData(dataSnapshot.value as Map<Object?, Object?>);
            }
          } else {
            UserCredential userCredential =
                await firebaseAuth.createUserWithEmailAndPassword(
              email: enteredEmail!,
              password: enteredPassword!,
            );
            DatabaseReference databaseRef =
                firebaseDatabase.ref('users/${userCredential.user?.uid}');
            databaseRef.set({
              'userName': enteredUserName,
              'height' : enteredHeight,
              'weight' : enteredWeight,
              'age': enteredAge,
              'email': enteredEmail,
              'steps' : { '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}' : 0 },
              'dailyGoal': 1000,
              'weeklyGoal': 10000,
              'objectives' : 'Increase Physical Activity Levels, Improve Nutritional Habits',
            });
            if (context.mounted) {
              Provider.of<UserInfoProvider>(context, listen: false)
                  .addUserData({
                'userName': enteredUserName,
                'age': enteredAge,
                'height' : enteredHeight,
                'weight' : enteredWeight,
                'email': enteredEmail,
                'steps' : {'${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}' : 0},
                'dailyGoal': 1000,
                'weeklyGoal': 10000,
                'objectives' : 'Increase Physical Activity Levels, Improve Nutritional Habits',
              });
            }
          }
        } on FirebaseAuthException catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.code,
                ),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: ScaffoldMessenger.of(context).clearSnackBars,
                ),
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  color: Theme.of(context).colorScheme.onTertiary,
                  child: Form(
                    key: formKey,
                    child: Consumer<AuthStateProvider>(
                        builder: (context, authProvider, child) {
                      return Column(
                        children: [
                          authProvider.isLogin
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 15,
                                      bottom: 5),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Username',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (userName) {
                                      if (userName!.trim().isEmpty ||
                                          userName.trim().length < 6) {
                                        return 'Username must be greater than 5 characters';
                                      }
                                      return null;
                                    },
                                    onSaved: (userName) {
                                      enteredUserName = userName;
                                    },
                                  ),
                                ),
                          authProvider.isLogin
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 5,
                                      bottom: 5),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Age',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (age) {
                                      if (age!.trim().isEmpty) {
                                        return 'Field can\'t be null';
                                      }
                                      return null;
                                    },
                                    onSaved: (age) {
                                      enteredAge = age;
                                    },
                                  ),
                                ),
                          authProvider.isLogin
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 5,
                                      bottom: 5),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Weight',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (weight) {
                                      if (weight!.trim().isEmpty) {
                                        return 'Field can\'t be null';
                                      }
                                      return null;
                                    },
                                    onSaved: (weight) {
                                      enteredWeight = double.parse(weight!);
                                    },
                                  ),
                                ),
                          authProvider.isLogin
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 5,
                                      bottom: 5),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Height',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (height) {
                                      if (height!.trim().isEmpty) {
                                        return 'Field can\'t be null';
                                      }
                                      return null;
                                    },
                                    onSaved: (height) {
                                      enteredHeight = double.parse(height!);
                                    },
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: authProvider.isLogin ? 15 : 5,
                                bottom: 5),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              validator: (email) {
                                if (email!.trim().isEmpty) {
                                  return 'Field can\'t be null';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(email.trim())) {
                                  return 'Please, check the mail id';
                                }
                                return null;
                              },
                              onSaved: (email) {
                                enteredEmail = email;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 5,
                                bottom: authProvider.isLogin ? 15 : 5),
                            child: TextFormField(
                              obscureText : true,
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                              validator: (password) {
                                if (password!.trim().isEmpty ||
                                    password.trim().length < 9) {
                                  return 'Password must be greater than 8 characters';
                                }
                                if (!RegExp(r'[!@#\\$%^&*()]')
                                    .hasMatch(password.trim())) {
                                  return 'Contains least one special character( !, @, #, \\, \$, &, *, ~)';
                                }
                                return null;
                              },
                              onSaved: (password) {
                                enteredPassword = password;
                              },
                            ),
                          ),
                          authProvider.isLogin
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 5,
                                      bottom: 15),
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: 'Confirm Password',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (confirmPassword) {
                                      if (confirmPassword!.trim().isEmpty ||
                                          confirmPassword.trim().length < 9) {
                                        return 'Password must be greater than 8 characters';
                                      }

                                      if (!RegExp(r'[!@#\\$%^&*()]')
                                          .hasMatch(confirmPassword.trim())) {
                                        return 'Contains least one special character( !, @, #, \\, \$, &, *, ~)';
                                      }
                                      return null;
                                    },
                                    onSaved: (confirmPassword) {
                                      enteredConfirmPassword = confirmPassword;
                                    },
                                  ),
                                ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(elevation: 5),
                            onPressed: _onSubmitted,
                            child: Text(
                              authProvider.isLogin ? 'Login' : 'Sign Up',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              authProvider
                                  .changeIsLoginState(!authProvider.isLogin);
                            },
                            child: Text(authProvider.isLogin
                                ? 'Need to create an account ?'
                                : 'Already, I have an account!!'),
                          ),
                        ],
                      );
                    },),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
