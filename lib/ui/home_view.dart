import 'package:chat_app_with_bloc/services/auth/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final _authService = AuthServices();

    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text('Home Page'),
            actions: [
              IconButton(
                onPressed: signOut,
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: _buildUserList()),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        child: ListTile(
          title: Text(data['email']),
          subtitle: Text(data['uid']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ChatView(
                    userEmail: data['email'],
                    receiverId: data['uid'],
                  );
                },
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
