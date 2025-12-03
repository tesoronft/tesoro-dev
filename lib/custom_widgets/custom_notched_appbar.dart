import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

class CustomNotchedAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final double height;
  final Widget child;

  const CustomNotchedAppbar({
    super.key,
    this.height = 100,
    required this.child,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopCircularNotchedClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.primary,
        child: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 10),
            child: Align(alignment: Alignment.topLeft, child: child)),
      ),
    );
  }
}

class TopCircularNotchedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double notchRadius = 50;
    double notchCenterX = 205;
    final Path path = Path();

    // TOP of the bar (straight line)
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);

    // RIGHT side
    path.lineTo(size.width, size.height);

    // Move to notch start
    path.lineTo(notchCenterX + notchRadius, size.height);

    // Bottom circular notch
    path.arcToPoint(
      Offset(notchCenterX - notchRadius, size.height),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    // LEFT side
    path.lineTo(0, size.height);

    return path..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
