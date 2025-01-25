import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getUserData(String userId) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.exists && doc.data() != null) {
      return doc.data()!;
    } else {
      throw Exception('User data not found for userId: $userId');
    }
  } catch (e) {
    throw Exception('Error fetching user data: $e');
  }
}
