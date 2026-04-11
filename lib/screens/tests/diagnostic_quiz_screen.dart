import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class DiagnosticQuizScreen extends StatefulWidget {
  final String type;
  const DiagnosticQuizScreen({super.key, required this.type});

  @override
  State<DiagnosticQuizScreen> createState() => _DiagnosticQuizScreenState();
}

class _DiagnosticQuizScreenState extends State<DiagnosticQuizScreen> {
  final FirestoreService _firestore = FirestoreService();
  int current = 0;
  int score = 0;

  late final List<String> questions;
  final List<Map<String, dynamic>> options = [
    {'text': 'Not at all', 'score': 0},
    {'text': 'Several days', 'score': 1},
    {'text': 'More than half', 'score': 2},
    {'text': 'Nearly every day', 'score': 3},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.type == "anxiety") {
      questions = [
        "Feeling nervous, anxious, or on edge?",
        "Not being able to stop or control worrying?",
        "Worrying too much about different things?",
        "Trouble relaxing?",
        "Being so restless that it's hard to sit still?",
        "Becoming easily annoyed or irritable?",
        "Feeling afraid as if something awful might happen?",
      ];
    } else if (widget.type == "depression") {
      questions = [
        "Little interest or pleasure in doing things?",
        "Feeling down, depressed, or hopeless?",
        "Trouble falling or staying asleep, or sleeping too much?",
        "Feeling tired or having little energy?",
        "Poor appetite or overeating?",
        "Feeling bad about yourself or that you are a failure?",
        "Trouble concentrating on things?",
      ];
    } else {
      questions = [
        "Have you felt that you were unable to control the important things in your life?",
        "Have you felt confident about your ability to handle your personal problems?",
        "Have you felt that things were going your way?",
        "Have you found that you could not cope with all the things that you had to do?",
        "Have you been able to control irritations in your life?",
        "Have you felt that you were on top of things?",
        "Have you been angered because of things that were outside of your control?",
      ];
    }
  }

  void answer(int value) {
    setState(() {
      score += value;
      if (current < questions.length - 1) {
        current++;
      } else {
        // Save to Firestore
        _firestore.saveAssessmentResult(widget.type, {
          "score": score,
          "maxScore": questions.length * 3,
        });
        showResult();
      }
    });
  }

  void showResult() {
    String result;
    Color resultColor;
    String advice;

    // Conversational scoring logic
    if (score < (questions.length * 0.5)) {
      result = "Gentle Breeze";
      resultColor = Colors.green;
      advice = "You're doing quite well! You seem to have a good handle on your ${widget.type} levels. Keep practicing your self-care routines.";
    } else if (score < (questions.length * 1.5)) {
      result = "Cloudy Skies";
      resultColor = Colors.orange;
      advice = "You're going through a bit of a rough patch. It's completely normal to feel this way sometimes. Try talking to someone you trust or using our AI Chatbot for a quick vent.";
    } else {
      result = "Stormy Weather";
      resultColor = Colors.redAccent;
      advice = "It sounds like you're carrying a heavy burden right now. Please remember you don't have to face this alone. We recommend reaching out to one of the professionals in our Bookings section.";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.analytics_outlined, size: 64, color: Colors.blueGrey),
              const SizedBox(height: 16),
              const Text("Your Emotional Weather", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: resultColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(result, style: TextStyle(color: resultColor, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 16),
              Text(advice, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, height: 1.5)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Exit quiz
                  },
                  child: const Text("Thank You"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (current) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("${widget.type[0].toUpperCase()}${widget.type.substring(1)} Check", style: const TextStyle(fontSize: 18)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 12),
              Text("Task ${current + 1} of ${questions.length}", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
              const SizedBox(height: 48),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      questions[current],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF03045E), height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 64),
                    ...options.map((option) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => answer(option['score'] as int),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(option['text'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              Icon(Icons.add_circle_outline_rounded, size: 20, color: Colors.grey.shade300),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
