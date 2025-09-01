import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppWarningMessage {
  final CollectionReference subscribersCollection = FirebaseFirestore.instance
      .collection('WARNING_MESSAGE');

  Future<void> storeWarningMessage(String message) async {
    try {
      String formattedDate = DateFormat(
        'MMMM dd, yyyy – hh:mm a',
      ).format(DateTime.now());

      await subscribersCollection.doc("message").set({
        "message": "$formattedDate: \n \n$message",
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error storing warning message: $e");
    }
  }
}
