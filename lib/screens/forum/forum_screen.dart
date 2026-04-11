import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';

class ForumScreen extends StatefulWidget {
  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final FirestoreService _service = FirestoreService();
  final TextEditingController controller = TextEditingController();

  void post() {
    _service.addPost(controller.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Community Forum")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _service.getPosts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      title: Text(doc['text']),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(controller: controller),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: post)
            ],
          )
        ],
      ),
    );
  }
}