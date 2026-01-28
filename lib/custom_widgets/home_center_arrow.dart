import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/routes/routes.dart';

class HomeCenterArrow extends StatelessWidget {
  const HomeCenterArrow({super.key, required this.isForHome});
  final bool isForHome;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        isForHome
            ? navigatorKey.currentContext
                ?.push(Routes.allTreasures, extra: true)
            : context.pop();
      },
      child: Container(
        height: 40,
        width: 60,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.dark),
            borderRadius: isForHome
                ? BorderRadius.only(
                    topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))
                : BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
            color: AppColors.light),
        child: isForHome
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox.shrink(),
                  Icon(Icons.arrow_back),
                  Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    color: AppColors.dark,
                    width: 20,
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                    color: AppColors.dark,
                    width: 20,
                  ),
                  Icon(Icons.arrow_forward),
                  SizedBox.shrink(),
                ],
              ),
      ),
    );
  }
}
