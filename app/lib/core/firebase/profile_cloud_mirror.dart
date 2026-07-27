import 'package:cloud_firestore/cloud_firestore.dart';

import '../profile.dart';

class ProfileCloudMirror {
  ProfileCloudMirror({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> save({
    required String uid,
    required Profile profile,
  }) =>
      _firestore.collection('users').doc(uid).set(
        {
          'profileSchemaVersion': 1,
          'updatedAt': FieldValue.serverTimestamp(),
          'firstName': profile.firstName,
          'dob': profile.dob.toUtc().toIso8601String(),
          'sex': profile.sex.name,
          'weightKg': profile.weightKg,
          'heightCm': profile.heightCm,
          'units': profile.units.name,
          'guidanceMode': profile.guidanceMode.name,
          'birthTimeMinutes': profile.birthTimeMinutes,
          'birthUtcOffsetMinutes': profile.birthUtcOffsetMinutes,
          'birthPlace': profile.birthPlace,
          'birthLatitude': profile.birthLatitude,
          'birthLongitude': profile.birthLongitude,
          // Lifestyle reflections and raw health history are intentionally not
          // mirrored by this profile-level contract.
        },
        SetOptions(merge: true),
      );

  Future<void> deleteUserData(String uid) =>
      _firestore.collection('users').doc(uid).delete();
}
