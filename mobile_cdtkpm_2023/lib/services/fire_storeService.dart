import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_cdtkpm_2023/consts/firebase_const.dart';

class FirestoreServices {  
  static getUser(uid)  {
    return firestore
        .collection(usersCollection)
        .where('id', isEqualTo: uid)
        .snapshots();
  }

}
