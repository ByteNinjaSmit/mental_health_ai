import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'post_details_page.dart';
import 'create_topic_dialog.dart';
import 'edit_topic_dialog.dart';

class TopicsPage extends StatelessWidget {
  final String category;

  const TopicsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('topics')
              .where('category', isEqualTo: category)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(
                        "Could not load topics.\nPlease try again later.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            
            // Sort client-side to avoid needing a Firestore composite index
            final docs = snapshot.data!.docs;
            docs.sort((a, b) {
              final aTs = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
              final bTs = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
              if (aTs == null && bTs == null) return 0;
              if (aTs == null) return 1;
              if (bTs == null) return -1;
              return bTs.compareTo(aTs); // descending order (newest first)
            });

            if (docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text("No topics yet. Start the conversation!", style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
              ).animate().fade();
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                var doc = docs[index];
                var data = doc.data() as Map<String, dynamic>;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        data['heading'] ?? 'Untitled',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF03045E)),
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.favorite_rounded, size: 16, color: Colors.redAccent.shade200),
                        const SizedBox(width: 4),
                        Text("${data['likes'] ?? 0} Likes", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailsPage(topicId: doc.id, categoryName: category),
                        ),
                      );
                    },
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text("Edit")]),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))]),
                        ),
                      ],
                      onSelected: (value) async {
                        if (value == 'delete') {
                          await FirebaseFirestore.instance.collection('topics').doc(doc.id).delete();
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => EditTopicDialog(
                              docId: doc.id,
                              currentHeading: data['heading'] ?? '',
                              currentDescription: data['description'] ?? '',
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ).animate().fade(delay: (50 * index).ms).slideY(begin: 0.1, curve: Curves.easeOut);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("New Topic", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => CreateTopicDialog(category: category),
          );
        },
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
    );
  }
}