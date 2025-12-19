import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_strings.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';
import 'package:tesoro_nft_app/custom_widgets/custom_scaffold.dart';
import 'package:tesoro_nft_app/custom_widgets/popup_button.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/image_preview.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/item_header.dart';
import 'package:tesoro_nft_app/custom_widgets/treasures/posted_by_card.dart';
import 'package:tesoro_nft_app/models/treasures/treasure_get_model.dart';
import 'package:tesoro_nft_app/utils/covert_time_to_minutes.dart';

class TreasureDetailsView extends StatelessWidget {
  const TreasureDetailsView({
    super.key,
    required this.treasureGetModel,
  });
  final TreasureGetModel treasureGetModel;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: AppColors.light,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height / 3,
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupButton(),
                  Text(
                    AppStrings.myTreasureDetails,
                    style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.light, fontWeight: FontWeight.bold),
                  ),
                  SizedBox.shrink(),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height / 8,
                  left: 10,
                  right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  ImagePreview(
                    images: treasureGetModel.photos ?? [],
                  ),
                  Text(
                    'Posted ${ConvertTimeToMinutes.convertTimeToMinutes(treasureGetModel.createdAt ?? DateTime.now().toString())} mins ago - ${treasureGetModel.location?.address}',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.error),
                  ),
                  ItemHeader(
                      condition: treasureGetModel.condition ?? 'Bad',
                      itemName: treasureGetModel.title ?? 'N/A',
                      price: treasureGetModel.price.toString()),
                  Divider(),
                  Text(
                    'Description:',
                    style:
                        AppTextStyles.bodyLarge.copyWith(color: AppColors.dark),
                  ),
                  Text(
                    treasureGetModel.description ?? 'N/A',
                    textAlign: TextAlign.start,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Color(0xff666666)),
                  ),
                  Divider(),
                  Text(
                    'Address:',
                    style:
                        AppTextStyles.bodyLarge.copyWith(color: AppColors.dark),
                  ),
                  Text(
                    treasureGetModel.location?.address ?? 'N/A',
                    textAlign: TextAlign.start,
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: Color(0xff0D5C63)),
                  ),
                  Divider(),
                  Text(
                    'Posted By:',
                    style:
                        AppTextStyles.bodyLarge.copyWith(color: AppColors.dark),
                  ),
                  PostedByCard(
                    imageUrl: treasureGetModel.postedBy?.profileImage ?? '',
                    name: treasureGetModel.postedBy?.name ?? "N/A",
                    rating: treasureGetModel.postedBy?.rating ?? 1,
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
