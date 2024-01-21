import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

// ignore: camel_case_types
class Storage_Service {
  final _storage = FirebaseStorage.instance.ref();
  Future<String> addimg(XFile? file) async{
    String unique = DateTime.now().microsecondsSinceEpoch.toString();
    String fileExtension = file!.path.split('.').last;
    late String imgurl;
    Reference img = _storage.child('Images').child('$unique.$fileExtension');
    await img.putFile(File(file.path));
    imgurl = await img.getDownloadURL();
    return imgurl;
  }
}