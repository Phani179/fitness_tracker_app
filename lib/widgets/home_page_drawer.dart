
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:fitness_tracker_app/providers/user_info_provider.dart';
import 'package:fitness_tracker_app/screens/profile_edit.dart';
import 'drawer_item.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal.shade400,
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 200,
              child: Center(
                child: SvgPicture.asset('assets/images/logo.svg', height: 130,),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        ProfileEditScreen.routeName,
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 26,
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<UserInfoProvider>(
              builder: (BuildContext context, userInfoProvider, Widget? child) {
                return DrawerItemWidget(
                    description: 'UserName', data: userInfoProvider.userName);
              },
            ),
            Consumer<UserInfoProvider>(
              builder: (BuildContext context, userInfoProvider, Widget? child) {
                return DrawerItemWidget(
                    description: 'Age', data: userInfoProvider.age);
              },
            ),
            Consumer<UserInfoProvider>(
              builder: (BuildContext context, userInfoProvider, Widget? child) {
                return DrawerItemWidget(
                    description: 'Email', data: userInfoProvider.email);
              },
            ),
            Consumer<UserInfoProvider>(
              builder: (BuildContext context, userInfoProvider, Widget? child) {
                return DrawerItemWidget(
                    description: 'Height',
                    data: userInfoProvider.height.toString());
              },
            ),
            Consumer<UserInfoProvider>(
              builder: (BuildContext context, userInfoProvider, Widget? child) {
                return DrawerItemWidget(
                    description: 'Weight',
                    data: userInfoProvider.weight.toString());
              },
            ),
            Consumer<UserInfoProvider>(
              builder: (BuildContext context, userInfoProvider, Widget? child) {
                return DrawerItemWidget(
                    description: 'Objectives',
                    data: userInfoProvider.objectives);
              },
            ),
          ],
        ),
      ),
    );
  }
}
