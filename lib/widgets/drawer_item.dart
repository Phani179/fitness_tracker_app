
import 'package:flutter/material.dart';

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget(
      {required this.description, required this.data, super.key});

  final String description;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$description : ',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: data,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
