import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTopicDialog extends StatefulWidget {
  final String category;

  const CreateTopicDialog({super.key, required this.category});

  @override
  State<CreateTopicDialog> createState() => _CreateTopicDialogState();
}

class _CreateTopicDialogState extends State<CreateTopicDialog> {
  final heading = TextEditingController();
  final description = TextEditingController();
  bool loading = false;

  void postTopic() async {
    if (heading.text.trim().isEmpty || description.text.trim().isEmpty) return;
    setState(() => loading = true);

    await FirebaseFirestore.instance.collection('topics').add({
      'heading': heading.text.trim(),
      'description': description.text.trim(),
      'category': widget.category,
      'timestamp': Timestamp.now(),
      'likes': 0,
      'likedBy': [],
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("New Topic", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: heading,
              decoration: const InputDecoration(labelText: "Title", hintText: "What's on your mind?"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: description,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Description", alignLabelWithHint: true),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : postTopic,
                child: loading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Post to Community"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}