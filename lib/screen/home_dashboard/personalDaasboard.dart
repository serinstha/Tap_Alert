import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Personaldaasboard extends StatelessWidget {
  final currentuser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.indigo[300],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: currentuser.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No user data found"));
          }

          var userData = snapshot.data!.docs.first;

          final List<Map<String, dynamic>> fields = [
            {
              'label': 'First Name',
              'value': userData['first_name'],
              'icon': Icons.person
            },
            {
              'label': 'Last Name',
              'value': userData['last_name'],
              'icon': Icons.person_outline
            },
            {
              'label': 'Email',
              'value': userData['email'],
              'icon': Icons.email
            },
            {
              'label': 'Phone',
              'value': userData['phone_number'],
              'icon': Icons.phone
            },
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0), 
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shape : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo[100],
                      child: Icon(fields[index]['icon'], color: Colors.indigo[700]),
                    ),
                    title: Text(
                      fields[index]['label'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      fields[index]['value'],
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
