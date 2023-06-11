import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/profile_model.dart';

class DatabaseManager {

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  Future<ProfileModel?> getUser(String userId) async {
    DocumentSnapshot userSnapshot =
    await _userCollection.doc(userId).get();
    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;
      return ProfileModel(
          email: userData?['email'],
          name: userData?['name'],
          photoUrl: userData?['photoUrl'],
          uid: userId
      );
    }
    return null;
  }

}
