import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';

class AuthorController extends GetxController {
  var isLoading = false.obs;

  //textcontroller
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (ex) {
      VxToast.show(context, msg: ex.toString());
    }
    return userCredential;
  }

  //signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      VxToast.show(context, msg: ex.toString());
    }
    return userCredential;
  }

  storeUserData({
    name,
    password,
    email,
    phoneNumber,
    List<Map<String, dynamic>>? vouchers,
    List<Map<String, dynamic>>? history,
    tokenFCM,
  }) async {
    String tokenFCM =
        "dXuHjHYSQtKxb5GA5ZERED:APA91bFY4cL2V1Y7etg9L0rWtdG9nDdBSEa9Stq4hax8CA7HgxljhhDuNMnevTe0G1z9GlocMTsK_ZFp0O_S7kmGVCf540gEfz_pd7-0zdR5CB-oyaOkeaSA4ybr9BMLPeEUNnntxEA1";
    DocumentReference store =
        firestore.collection(usersCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'tokenFCM': tokenFCM,
      'phoneNumber':phoneNumber,
      'vouchers': vouchers ?? [],
      'history': history ?? [],
    });
  }

  // signOut
  signoutMethod(context) async {
    try {
       await auth.signOut();
           emailController.text = '';
    passwordController.text = '';
      isLoading.value = false;
    } catch (ex) {
      VxToast.show(context, msg: ex.toString());
    }
  }
}
