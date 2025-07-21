import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriberService {
  final CollectionReference subscribersCollection =
      FirebaseFirestore.instance.collection('SUBSCRIBERS');

  Future<void> updateSubscriber(String id, Map<String, dynamic> data) async {
    QuerySnapshot snapshot = await subscribersCollection.where('id', isEqualTo: id).get();

    for (var doc in snapshot.docs) {
      await doc.reference.update(data);
    }
  }

  Future<void> deleteSubscriber(String id) async {
    QuerySnapshot snapshot = await subscribersCollection.where('id', isEqualTo: id).get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
