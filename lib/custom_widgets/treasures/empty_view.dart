import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';

import '../../providers/dashboard_provider.dart';
import '../custom_btn.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, this.title, this.onTap});
  final String? title;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppImages.empty, height: 200),
        CustomBtn(
          text: title ?? 'Explore Treasures',
          onBtnTap: () {
            if (onTap != null) {
              context.pop();
              onTap!();
            } else {
              context.pop();
              context.read<DashboardProvider>().updateIndex(1);
            }
          },
        )
      ],
    );
  }
}
