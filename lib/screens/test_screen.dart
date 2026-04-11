import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int current = 0;
  int score = 0;
  bool isCompleted = false;

  final questions = [
    "Feeling nervous or anxious?",
    "Trouble sleeping?",
    "Feeling hopeless?",
    "Low energy?",
    "Difficulty concentrating?"
  ];

  final options = [
    {'text': 'Not at all', 'score': 0},
    {'text': 'Several days', 'score': 1},
    {'text': 'More than half', 'score': 2},
    {'text': 'Nearly every day', 'score': 3},
  ];

  void answer(int value) {
    setState(() {
      score += value;
      if (current < questions.length - 1) {
        current++;
      } else {
        isCompleted = true;
        showResult();
      }
    });
  }

  void showResult() {
    String result;
    Color resultColor;
    String advice;

    if (score < 5) {
      result = "Low Risk";
      resultColor = Colors.green;
      advice = "You're showing minimal signs of distress. Keep up your healthy habits!";
    } else if (score < 10) {
      result = "Moderate Risk";
      resultColor = Colors.orange;
      advice = "You might be experiencing some distress. Consider exploring our resources or talking to a friend.";
    } else {
      result = "High Risk";
      resultColor = Colors.redAccent;
      advice = "We strongly recommend booking an appointment with one of our specialists to discuss how you're feeling.";
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
              Icon(Icons.health_and_safety_rounded, size: 64, color: resultColor),
              const SizedBox(height: 16),
              const Text("Assessment Complete", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                    Navigator.pop(context); // Exit test
                  },
                  child: const Text("Return Home"),
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
        title: const Text("Mental Health Assessment", style: TextStyle(fontSize: 18)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
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
              Text("Question ${current + 1} of ${questions.length}", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
              const SizedBox(height: 32),

              // Question Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Text(
                  questions[current],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF03045E), height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),

              // Options
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return InkWell(
                      onTap: () => answer(option['score'] as int),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(option['text'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade300),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}