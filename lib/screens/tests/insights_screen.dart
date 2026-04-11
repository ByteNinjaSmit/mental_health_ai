import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/firestore_service.dart';
import '../../services/gemini_service.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final FirestoreService _firestore = FirestoreService();
  final GeminiService _gemini = GeminiService();
  String? aiSummary;
  bool isAnalyzing = false;

  Future<void> _generateAIAnalysis(List<QueryDocumentSnapshot> docs) async {
    if (aiSummary != null || isAnalyzing) return;

    setState(() => isAnalyzing = true);
    
    // Prepare history for AI
    final history = docs.take(10).map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final timestamp = data['timestamp'] as Timestamp?;
      return {
        "type": data['type'],
        "result": data['result'],
        "timestamp": timestamp?.toDate().toString() ?? "Recently",
      };
    }).toList();

    final result = await _gemini.analyzeTrend(history);
    
    if (mounted) {
      setState(() {
        aiSummary = result;
        isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Your AI Insights"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.getAssessmentHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.query_stats_rounded, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 24),
                  const Text("No history data yet", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      "Start by taking a Mood Check or Assessment to unlock AI life patterns.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            );
          }

          final List<QueryDocumentSnapshot> docs = List.from(snapshot.data!.docs);
          
          // Client-side sorting because server-side index is missing
          docs.sort((a, b) {
            final aTime = (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
            final bTime = (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp?;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });

          // Trigger AI analysis if we have data (SAFE WAY)
          if (aiSummary == null && !isAnalyzing) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _generateAIAnalysis(docs);
            });
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // AI Summary Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).colorScheme.primary, const Color(0xFF03045E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 24),
                        SizedBox(width: 12),
                        Text("AI PATTERN ANALYSIS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (isAnalyzing)
                      const Center(child: CircularProgressIndicator(color: Colors.white))
                    else
                      Text(
                        aiSummary ?? "Analyzing your well-being journey...",
                        style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5, fontWeight: FontWeight.w500),
                      ).animate().fade().slideY(begin: 0.1),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              const Text("Recent Check-ins", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
              const SizedBox(height: 16),
              
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final type = data['type'] as String;
                final result = data['result'] as Map<String, dynamic>;
                final timestamp = data['timestamp'] as Timestamp?;
                final dateStr = timestamp != null ? "${timestamp.toDate().day}/${timestamp.toDate().month}" : "Now";

                String mainText = "";
                String? subText;
                Color statusColor = Colors.blueGrey;
                String emoji = "📊";

                if (type == 'mood') {
                  mainText = result['label'] ?? "Feeling";
                  emoji = result['emoji'] ?? "😊";
                  statusColor = Colors.amber;
                } else {
                  final int score = result['score'] ?? 0;
                  final int maxScore = result['maxScore'] ?? 21;
                  mainText = "Score: $score/$maxScore";
                  
                  // Calculate conversational status
                  final double ratio = score / (maxScore / 3); // 0-1, 1-2, 2-3
                  if (ratio < 0.5) {
                    subText = "Gentle Breeze";
                    statusColor = Colors.green;
                    emoji = "🍃";
                  } else if (ratio < 1.5) {
                    subText = "Cloudy Skies";
                    statusColor = Colors.orange;
                    emoji = "☁️";
                  } else {
                    subText = "Stormy Weather";
                    statusColor = Colors.redAccent;
                    emoji = "⛈️";
                  }
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                        child: Text(emoji, style: const TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(type.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5, color: Colors.blueGrey)),
                            Row(
                              children: [
                                Text(mainText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF03045E))),
                                if (subText != null) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                    child: Text(subText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(dateStr, style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ],
                  ),
                ).animate().fade().slideX(begin: 0.05);
              }),
            ],
          );
        },
      ),
    );
  }
}
