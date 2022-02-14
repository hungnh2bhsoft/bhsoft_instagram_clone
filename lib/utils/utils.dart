import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource imageSource) async {
  final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (xFile != null) {
    return xFile.readAsBytes();
  }

  return null;
}
