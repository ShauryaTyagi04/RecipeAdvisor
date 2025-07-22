import 'package:flutter/material.dart';

@immutable
class ImageSizing {
  final double? width;
  final double? height;
  final BoxFit fit;

  // The default fit is now BoxFit.none to show original image size.
  const ImageSizing({
    this.width,
    this.height,
    this.fit = BoxFit.none,
  });

  // We now provide static const instances for common behaviors.
  static const ImageSizing cover = ImageSizing(fit: BoxFit.cover);
  static const ImageSizing stretch = ImageSizing(fit: BoxFit.fill);

  factory ImageSizing.custom({double? width, double? height}) {
    if (width == null && height == null) {
      throw ArgumentError(
          'At least one dimension (width or height) must be provided for custom sizing.');
    }
    // When a custom size is given, it's best to default to a 'cover' fit.
    return ImageSizing(width: width, height: height, fit: BoxFit.cover);
  }
}
