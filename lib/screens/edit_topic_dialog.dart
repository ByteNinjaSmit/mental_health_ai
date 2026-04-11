import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTopicDialog extends StatefulWidget {
  final String docId;
  final String currentHeading;
  final String currentDescription;

  const EditTopicDialog({
    super.key,
    required this.docId,
    required this.currentHeading,
    required this.currentDescription,
  });

  @override
  State<EditTopicDialog> createState() => _EditTopicDialogState();
}

class _EditTopicDialogState extends State<EditTopicDialog> {
  late TextEditingController heading;
  late TextEditingController description;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    heading = TextEditingController(text: widget.currentHeading);
    description = TextEditingController(text: widget.currentDescription);
  }

  void updateTopic() async {
    if (heading.text.trim().isEmpty || description.text.trim().isEmpty) return;
    setState(() => loading = true);

    await FirebaseFirestore.instance.collection('topics').doc(widget.docId).update({
      'heading': heading.text.trim(),
      'description': description.text.trim(),
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
                const Text("Edit Topic", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
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
              decoration: const InputDecoration(labelText: "Title"),
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
                onPressed: loading ? null : updateTopic,
                child: loading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}