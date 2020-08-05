import 'dart:io';

import 'package:image/image.dart';

class CropImage {
  static Future<Image> getResizedOrignal(File img) async {
    Image image = decodeImage(img.readAsBytesSync());
    Image _image = copyResize(image, width: 120);
    return _image;
  }

  static Future<Image> getResizedThumbnail(File img) async {
    Image image = decodeImage(img.readAsBytesSync());
    Image _thumbnail = copyResize(image, width: 120);
    return _thumbnail;
  }
}
