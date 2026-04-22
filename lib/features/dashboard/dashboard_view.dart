import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/data/dashboard/dashboard_data.dart';
import 'package:tesoro_nft_app/providers/dashboard_provider.dart';
import 'package:tesoro_nft_app/routes/routes.dart';
import 'package:tesoro_nft_app/services/analytics_service.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardValue, child) => PopScope(
        canPop: false,
        child: Scaffold(
          // ✅ FIX: Load screen on-demand instead of from pre-created list
          body: DashboardData.getScreen(dashboardValue.currentIndex),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await AnalyticsService.logEvent('post_treasure_view');
              context.push(Routes.postTreasure);
            },
            backgroundColor: AppColors.primary,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.add,
              color: AppColors.light,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            elevation: 2,
            shadowColor: Colors.black,
            clipBehavior: Clip.antiAlias,
            color: AppColors.light,
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () async {
                      await AnalyticsService.logEvent('home_view');
                      dashboardValue.updateIndex(0);
                    },
                    child: SvgPicture.asset(
                      DashboardData.dashboardIcons[0],
                      color: dashboardValue.currentIndex == 0
                          ? AppColors.primary
                          : AppColors.dark,
                    )),
                InkWell(
                    onTap: () async {
                      await AnalyticsService.logEvent('all_treasures_view');
                      dashboardValue.updateIndex(1);
                    },
                    child: SvgPicture.asset(
                      DashboardData.dashboardIcons[1],
                      color: dashboardValue.currentIndex == 1
                          ? AppColors.primary
                          : AppColors.dark,
                    )),
                InkWell(
                    onTap: () async {
                      await AnalyticsService.logEvent('user_account_view');
                      dashboardValue.updateIndex(2);
                    },
                    child: SvgPicture.asset(
                      DashboardData.dashboardIcons[2],
                      color: dashboardValue.currentIndex == 2
                          ? AppColors.primary
                          : AppColors.dark,
                    )),
                InkWell(
                    onTap: () async {
                      await AnalyticsService.logEvent('settings_view');
                      dashboardValue.updateIndex(3);
                    },
                    child: SvgPicture.asset(
                      DashboardData.dashboardIcons[3],
                      color: dashboardValue.currentIndex == 3
                          ? AppColors.primary
                          : AppColors.dark,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
