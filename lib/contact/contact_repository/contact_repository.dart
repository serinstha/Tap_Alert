import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<bool> exists(String uid, String phone) async {
    final qs = await _firestore
        .collection('users')
        .doc(uid)
        .collection('Emergenct_number')
        .where('P_number', isEqualTo: phone)
        .get();
    return qs.docs.isNotEmpty;
  }

  Future<void> saveContact({
    required String uid,
    required Contact contact,
  }) async {
    final name = contact.displayName;
    final phone = contact.phones.isNotEmpty ? contact.phones.first.number : '';
    if (name.isEmpty || phone.isEmpty) return;

    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    if (!await exists(uid, cleaned)) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('Emergenct_number')
          .add({'name': name, 'P_number': cleaned});
    }
  }

  Stream<List<Map<String, dynamic>>> streamContacts(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('Emergenct_number')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  'name': doc['name'],
                  'P_number': doc['P_number'],
                },
              )
              .toList(),
        );
  }

  Future<void> deleteContact(String uid, String docId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('Emergenct_number')
        .doc(docId)
        .delete();
  }

  /// ✅ Fetch all contacts once (for sending SMS)
  Future<List<Map<String, dynamic>>> getContacts(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('Emergenct_number')
        .get();

    return snapshot.docs.map((doc) {
      return {'id': doc.id, 'name': doc['name'], 'P_number': doc['P_number']};
    }).toList();
  }
}
