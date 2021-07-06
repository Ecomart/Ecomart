import 'package:flutter/cupertino.dart';

class BaseFirebaseServices {
  /// check if the Firebase is enable or not
  bool get isEnabled => false;
  Future<void> init() async {}
  dynamic getCloudMessaging() {}
  void getAnalytic() {}

  dynamic getCurrentUser() => null;

  /// Login Firebase with social account
  void loginFirebaseSMS({authorizationCode, identityToken}) {}
  void loginFirebaseFacebook({token}) {}
  void loginFirebaseGoogle({token}) {}
  void loginFirebaseEmail({email, password}) {}

  dynamic loginFirebaseCredential({credential}) {}
  dynamic getFirebaseCredential({verificationId, smsCode}) {}

  /// save user to firebase
  void saveUserToFirestore({user}) {}

  /// verify SMS login
  dynamic getFirebaseStream() {}
  void verifyPhoneNumber(
      {phoneNumber,
      codeAutoRetrievalTimeout,
      codeSent,
      verificationCompleted,
      verificationFailed}) {}

  /// render Chat Screen
  Widget renderListChatScreen() => Container();
  Widget renderVendorListChatScreen() => Container();
  Widget renderChatScreen({senderUser, receiverEmail, receiverName}) =>
      Container();

  /// load firebase remote config
  void loadRemoteConfig({onUpdate}) {}

  /// init Firebase Dynamic link
  // void initDynamicLinkService(context) {}
  void shareDynamicLinkProduct({context, productUrl, productId}) {}

  /// register new user with email and password
  void createUserWithEmailAndPassword({email, password}) {}

  void signOut() {}

  Future<String?> getMessagingToken() async => '';
}
