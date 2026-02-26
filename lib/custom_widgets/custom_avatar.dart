import 'dart:io';

import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar(
      {super.key, required this.profileImage, this.radius = 120});
  final String profileImage;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        image: profileImage.contains('https')
            ? DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(profileImage))
            : DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(profileImage)),
              ),
      ),
    );
  }
}
