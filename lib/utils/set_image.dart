import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SetImage extends StatelessWidget {
  const SetImage(
      {super.key,
      required this.imagePath,
      this.height = 200,
      this.width = double.infinity});
  final String imagePath;
  final double height, width;
  @override
  Widget build(BuildContext context) {
    return imagePath.contains('https')
        ? InteractiveViewer(
            maxScale: 4.0,
            minScale: 0.5,
            clipBehavior: Clip.none,
            child: CachedNetworkImage(
              key: ValueKey(imagePath),
              cacheKey: imagePath,
              imageUrl: imagePath,
              width: width,
              height: height,
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                height: height,
                width: width,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
          )
        : imagePath.contains('assets')
            ? Image.asset(
                key: ValueKey(imagePath),
                imagePath,
                fit: BoxFit.cover,
                height: height,
                width: width,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  height: height,
                  width: width,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              )
            : Image.file(
                key: ValueKey(imagePath),
                File(imagePath),
                fit: BoxFit.cover,
                height: height,
                width: width,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  height: height,
                  width: width,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              );
  }
}
