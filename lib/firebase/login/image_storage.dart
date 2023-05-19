
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class image_storage{
  final FirebaseStorage storage=FirebaseStorage.instance;
  final FirebaseAuth auth=FirebaseAuth.instance;

    Future<String> upload_image(String folder,Uint8List image_file,bool post)
    async {
      Reference ref=storage.ref().child(folder).child(auth.currentUser!.uid);
      
      if (post ==true)
        {
          String postId=Uuid().v1();
          ref=ref.child(postId);
        }

      UploadTask uploadTask=ref.putData(image_file);

      TaskSnapshot snap=await uploadTask;
      String download_link=await snap.ref.getDownloadURL();
      return download_link;
    }
}