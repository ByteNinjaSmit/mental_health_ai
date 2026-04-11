import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCommentDialog extends StatelessWidget {
  final DocumentReference docRef;
  final String currentText;

  EditCommentDialog({
    required this.docRef,
    required this.currentText,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: currentText);

    return AlertDialog(
      title: Text("Edit Comment"),
      content: TextField(controller: controller),
      actions: [
        ElevatedButton(
          onPressed: () async {
            await docRef.update({'text': controller.text});
            Navigator.pop(context);
          },
          child: Text("Update"),
        )
      ],
    );
  }
}