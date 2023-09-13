import 'package:chat_app_with_bloc/core/componenets/chat_bubble.dart';
import 'package:chat_app_with_bloc/core/componenets/mytextfield.dart';
import 'package:chat_app_with_bloc/services/chat_services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final String userEmail;
  final String receiverId;
  const ChatView({
    super.key,
    required this.userEmail,
    required this.receiverId,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController message = TextEditingController();
  ChatService _chatService = ChatService();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (message.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverId, message.text);
    }
    message.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.userEmail),
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(
          widget.receiverId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages available.'));
        } else {
          for (var doc in snapshot.data!.docs) {
            // print('Received message: ${doc.data()}');
          }
          // Process and display the messages here
          return ListView(
            children: snapshot.data!.docs
                .map(
                  (documentSnapshot) => _buildMessageItem(documentSnapshot),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft);

    var crossAxisAlignment = data['senderId'] == _firebaseAuth.currentUser!.uid
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;

    var color = data['senderId'] == _firebaseAuth.currentUser!.uid
        ? Colors.blue
        : Colors.deepPurpleAccent;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          // Text(data['message']),
          ChatBubble(
            message: data['message'],
            color: color,
          ),
          // Text('From ${data['senderEmail']}'),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: MyTextField(
              suffixIcon: GestureDetector(
                onTap: sendMessage,
                child: Icon(
                  Icons.send,
                ),
              ),
              controller: message,
              hintText: 'Enter Message',
              obsecureText: false,
            ),
          ),
        ),
      ],
    );
  }
}
