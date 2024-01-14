
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/services/firebase_instances.dart';
import 'package:fitness_tracker_app/providers/user_info_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  static const String routeName = '/ProfileEdit';

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController userNameEditingController;

  late TextEditingController ageEditingController;

  late TextEditingController heightEditingController;

  late TextEditingController weightEditingController;

  late TextEditingController emailEditingController;

  late TextEditingController objectivesEditingController;

  final formKey = GlobalKey<FormState>();

  String? enteredUserName;

  String? enteredAge;

  double? enteredHeight;

  double? enteredWeight;

  String? enteredPassword;

  String? enteredConfirmPassword;

  String? enteredObjectives;

  Future<void> _onReset() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();
      if (enteredPassword != enteredConfirmPassword) {
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
          User? user = firebaseAuth.currentUser;
          if (user != null) {
            final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
            userInfoProvider.userName = enteredUserName!;
            userInfoProvider.height = enteredHeight!;
            userInfoProvider.weight = enteredWeight!;
            userInfoProvider.age = enteredAge!;
            userInfoProvider.objectives = enteredObjectives!;
            DatabaseReference databaseRef =
                firebaseDatabase.ref('users/${user.uid}');
            databaseRef.update({
              'userName': enteredUserName,
              'height': enteredHeight,
              'weight': enteredWeight,
              'age': enteredAge,
              'objectives': enteredObjectives,
            });
            if (enteredPassword != null && enteredPassword!.trim().isNotEmpty) {
              user.updatePassword(enteredPassword!);
            }
          }
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: const Text(
                'Profile Updated',
              ),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: ScaffoldMessenger.of(context).clearSnackBars,
              ),
            ),
          );
          Navigator.pop(context);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.toString(),
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: const Text(
          'Profile Edit',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Consumer<UserInfoProvider>(
              builder: (context, userInfoProvider, child) {
                userNameEditingController =
                    TextEditingController(text: userInfoProvider.userName);
                ageEditingController =
                    TextEditingController(text: userInfoProvider.age);
                heightEditingController = TextEditingController(
                    text: userInfoProvider.height.toString());
                weightEditingController = TextEditingController(
                    text: userInfoProvider.weight.toString());
                objectivesEditingController =
                    TextEditingController(text: userInfoProvider.objectives);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 10),
                      child: TextFormField(
                        controller: userNameEditingController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5, bottom: 10),
                      child: TextFormField(
                        controller: ageEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5, bottom: 10),
                      child: TextFormField(
                        controller: weightEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5, bottom: 10),
                      child: TextFormField(
                        controller: heightEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Height',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
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
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5, bottom: 10),
                      child: TextFormField(
                        controller: objectivesEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Objectives',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: 'Objectives',
                          border: OutlineInputBorder(),
                        ),
                        validator: (weight) {
                          if (weight!.trim().isEmpty) {
                            return 'Field can\'t be null';
                          }
                          return null;
                        },
                        onSaved: (objectives) {
                          enteredObjectives = objectives;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: 5,
                        bottom: 10,
                      ),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (password) {
                          if (password!.trim().isEmpty) {
                            return null;
                          }
                          if (password.trim().length < 9) {
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
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5, bottom: 15),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (confirmPassword) {
                          if (confirmPassword!.trim().isEmpty) {
                            return null;
                          }
                          if (confirmPassword.trim().length < 9) {
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
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: Navigator.of(context).pop,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 5,
                            ),
                            onPressed: _onReset,
                            child: const Text(
                              'Reset',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
