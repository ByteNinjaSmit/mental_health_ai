import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PostDetailsPage extends StatefulWidget {
  final String topicId;
  final String categoryName;

  const PostDetailsPage({super.key, required this.topicId, required this.categoryName});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text("Post Details")),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('topics')
              .doc(widget.topicId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
            var postData = snapshot.data?.data() as Map<String, dynamic>?;
            if (postData == null) return const Center(child: Text("Post not found"));
        
            return Column(
              children: [
                // POST HEADER
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(postData['heading'] ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                              const SizedBox(height: 16),
                              Text(postData['description'] ?? '', style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5)),
                              const SizedBox(height: 16),
                              Divider(color: Colors.grey.shade200),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => _likePost(postData),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            ((postData['likedBy'] as List?) ?? []).contains(FirebaseAuth.instance.currentUser?.uid) 
                                               ? Icons.favorite_rounded : Icons.favorite_border_rounded, 
                                            color: Colors.redAccent,
                                            size: 22
                                          ),
                                          const SizedBox(width: 8),
                                          Text("${postData['likes'] ?? 0} Likes", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Colors.grey.shade400),
                                ],
                              )
                            ],
                          ),
                        ).animate().fade().slideY(begin: 0.1),
                      ),
                      
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade600)),
                        ),
                      ),
        
                      // COMMENTS
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('topics')
                            .doc(widget.topicId)
                            .collection('posts')
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
                          
                          var docs = snapshot.data!.docs;
                          if (docs.isEmpty) {
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: Center(child: Text("No comments yet. Be the first!", style: TextStyle(color: Colors.grey.shade500))),
                              ),
                            );
                          }
        
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var data = docs[index].data() as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.grey.shade100, width: 1),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                        child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                                      ),
                                      title: Text(data['text'] ?? '', style: const TextStyle(fontSize: 14)),
                                      trailing: Text("${data['likes'] ?? 0} \u2665", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                    ),
                                  ),
                                ).animate().fade(delay: (50 * index).ms).slideX(begin: 0.1);
                              },
                              childCount: docs.length,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        
                // ADD COMMENT INPUT
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: "Add a comment...",
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          onSubmitted: (_) => _addComment(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.white),
                          onPressed: _addComment,
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _addComment() async {
    if (commentController.text.trim().isEmpty) return;
    if (FirebaseAuth.instance.currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('topics')
        .doc(widget.topicId)
        .collection('posts')
        .add({
      'author': FirebaseAuth.instance.currentUser!.uid,
      'text': commentController.text.trim(),
      'timestamp': Timestamp.now(),
      'likes': 0,
      'likedBy': [],
    });

    commentController.clear();
  }

  void _likePost(Map<String, dynamic> post) async {
    if (FirebaseAuth.instance.currentUser == null) return;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (((post['likedBy'] as List?) ?? []).contains(userId)) {
      await FirebaseFirestore.instance
          .collection('topics')
          .doc(widget.topicId)
          .update({
        'likes': (post['likes'] ?? 1) - 1,
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('topics')
          .doc(widget.topicId)
          .update({
        'likes': (post['likes'] ?? 0) + 1,
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }
}