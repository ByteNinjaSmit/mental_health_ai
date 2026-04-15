import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/resource_service.dart';

class GamesScreen extends StatelessWidget {
  final String category;

  const GamesScreen({super.key, required this.category});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gamesList = ResourceDataService.games[category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('$category Games & Activities')),
      body: gamesList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_esports_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text("No games available yet.", style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: gamesList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final game = gamesList[index];
                final color = _getGameColor(index);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.15)),
                    boxShadow: [
                      BoxShadow(color: color.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(_getGameIcon(index), color: color, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    game['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    game['description'] ?? '',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _launchUrl(game['url'] ?? ''),
                            icon: const Icon(Icons.play_arrow_rounded, size: 20),
                            label: const Text('Play Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade(delay: (80 * index).ms).slideY(begin: 0.1, curve: Curves.easeOut);
              },
            ),
    );
  }

  Color _getGameColor(int index) {
    const colors = [
      Color(0xFF5C6BC0),
      Color(0xFF26A69A),
      Color(0xFFFFA726),
      Color(0xFFEF5350),
      Color(0xFF7E57C2),
      Color(0xFF42A5F5),
      Color(0xFFEC407A),
    ];
    return colors[index % colors.length];
  }

  IconData _getGameIcon(int index) {
    const icons = [
      Icons.self_improvement_rounded,
      Icons.music_note_rounded,
      Icons.palette_rounded,
      Icons.extension_rounded,
      Icons.brush_rounded,
      Icons.spa_rounded,
      Icons.auto_awesome_rounded,
    ];
    return icons[index % icons.length];
  }
}
