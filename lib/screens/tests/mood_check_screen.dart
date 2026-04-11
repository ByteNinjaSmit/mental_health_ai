import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/firestore_service.dart';

class MoodCheckScreen extends StatefulWidget {
  const MoodCheckScreen({super.key});

  @override
  State<MoodCheckScreen> createState() => _MoodCheckScreenState();
}

class _MoodCheckScreenState extends State<MoodCheckScreen> {
  final FirestoreService _firestore = FirestoreService();
  String? selectedMood;
  String? feedback;

  final List<Map<String, dynamic>> moods = [
    {"emoji": "😊", "label": "Happy", "color": Colors.amber, "feedback": "That's wonderful! Keep that positive energy going today."},
    {"emoji": "😌", "label": "Calm", "color": Colors.teal, "feedback": "Quiet moments are precious. Enjoy this peaceful state."},
    {"emoji": "😔", "label": "Sad", "color": Colors.blue, "feedback": "It's okay to feel sad. Be gentle with yourself right now."},
    {"emoji": "😠", "label": "Angry", "color": Colors.red, "feedback": "Close your eyes and take three deep breaths. You can handle this."},
    {"emoji": "😰", "label": "Anxious", "color": Colors.purple, "feedback": "Focus on your breathing. You are safe in this moment."},
    {"emoji": "😴", "label": "Tired", "color": Colors.grey, "feedback": "Growth requires rest. Make sure to give your body the sleep it needs."},
  ];

  void _onMoodSelected(Map<String, dynamic> mood) {
    setState(() {
      selectedMood = mood['label'];
      feedback = mood['feedback'];
    });

    _firestore.saveAssessmentResult("mood", {
      "label": mood['label'],
      "emoji": mood['emoji'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "How are you feeling?",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
            ),
            const SizedBox(height: 12),
            Text(
              "Tap on the emoji that best represents your mood right now.",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.1,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected = selectedMood == mood['label'];

                  return GestureDetector(
                    onTap: () => _onMoodSelected(mood),
                    child: AnimatedContainer(
                      duration: 300.ms,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: isSelected ? mood['color'] : Colors.grey.shade100,
                          width: isSelected ? 4 : 2,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(color: mood['color'].withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8))
                          else
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mood['emoji'],
                            style: const TextStyle(fontSize: 56), // Big Sizes as requested
                          ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 300.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 12),
                          Text(
                            mood['label'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? mood['color'] : const Color(0xFF03045E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().scale(delay: (index * 50).ms).fade();
                },
              ),
            ),
            if (feedback != null)
              Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade100, width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 32),
                    const SizedBox(height: 16),
                    Text(
                      feedback!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E), height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Next"),
                      ),
                    ),
                  ],
                ),
              ).animate().fade().slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }
}
