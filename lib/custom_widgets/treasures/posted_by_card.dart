import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';
import 'package:tesoro_nft_app/consts/app_images.dart';
import 'package:tesoro_nft_app/consts/app_text_styles.dart';

class PostedByCard extends StatelessWidget {
  const PostedByCard(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.rating});
  final String name, imageUrl;
  final int rating;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffFFFDEC),
          border: Border.all(color: Colors.amberAccent)),
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 20,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  name,
                  style: AppTextStyles.headingMedium.copyWith(fontSize: 22),
                ),
              ),
              SizedBox(
                  width: 200,
                  child: Divider(
                    thickness: 2,
                    color: AppColors.dialogBtn,
                  )),
              AbsorbPointer(
                absorbing: true,
                child: RatingBar.builder(
                  itemCount: 5,
                  unratedColor: Colors.black,
                  initialRating: rating.toDouble(),
                  itemSize: 32,
                  itemBuilder: (context, index) {
                    return SvgPicture.asset(
                      AppImages.dollarChest,
                      color: AppColors.primary,
                    );
                  },
                  onRatingUpdate: (value) {},
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
