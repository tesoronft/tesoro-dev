import 'package:flutter/material.dart';
import 'package:tesoro_nft_app/consts/app_colors.dart';

class ImagePreview extends StatelessWidget {
  ImagePreview({super.key, required this.images});
  final List<dynamic> images;
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentIndex,
        builder: (context, current, child) {
          return Column(
            spacing: 10,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.sizeOf(context).height / 3,
                    width: MediaQuery.sizeOf(context).width / 1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.currency),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      images[currentIndex.value],
                      height: MediaQuery.sizeOf(context).height / 3,
                      width: MediaQuery.sizeOf(context).width / 1,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            currentIndex.value == 0 ? () : currentIndex.value--;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffE4E4E4),
                                borderRadius: BorderRadius.circular(100)),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 26,
                              color: AppColors.dark.withAlpha(90),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            currentIndex.value == images.length - 1
                                ? ()
                                : currentIndex.value++;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffE4E4E4),
                                borderRadius: BorderRadius.circular(100)),
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 26,
                              color: AppColors.dark.withAlpha(90),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: images.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: () => currentIndex.value = index,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: currentIndex.value == index
                                    ? AppColors.error
                                    : Colors.transparent)),
                        alignment: Alignment.center,
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
