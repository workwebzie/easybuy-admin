import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static Future<String?> pickAndUploadImage({required String folder}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        Uint8List fileBytes = result.files.single.bytes!;
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';

        try {
          // Attempt Firebase Storage Upload
          Reference storageRef = FirebaseStorage.instance.ref().child('$folder/$fileName');
          UploadTask uploadTask = storageRef.putData(
            fileBytes,
            SettableMetadata(contentType: 'image/jpeg'),
          );
          TaskSnapshot snapshot = await uploadTask;
          String downloadUrl = await snapshot.ref.getDownloadURL();
          return downloadUrl;
        } catch (storageError) {
          debugPrint('Firebase Storage notice: $storageError. Encoding Base64 web preview image.');
          // Fallback to Data URL for web instant preview
          String base64Image = base64Encode(fileBytes);
          return 'data:image/jpeg;base64,$base64Image';
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }
}
