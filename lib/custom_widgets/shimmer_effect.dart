import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
          mainAxisSpacing: 10),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightPrimary, AppColors.primary.withAlpha(30)]),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.lightPrimary,
                ]),
          ),
        ),
      ),
    );
  }
}
