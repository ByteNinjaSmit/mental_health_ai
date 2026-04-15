import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/resource_service.dart';

class VideoChannelsScreen extends StatelessWidget {
  final String category;

  const VideoChannelsScreen({super.key, required this.category});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final channels = ResourceDataService.videoChannels[category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('$category Videos')),
      body: channels.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.subscriptions_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text("No channels available yet.", style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: channels.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final channel = channels[index];
                // Generate a color from the channel name for the avatar
                final avatarColor = _getChannelColor(index);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _launchUrl(channel['url'] ?? ''),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Channel avatar
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [avatarColor, avatarColor.withOpacity(0.6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                (channel['name'] ?? 'C')[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Channel info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  channel['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF03045E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  channel['description'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.open_in_new_rounded, color: Colors.red.shade400, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fade(delay: (70 * index).ms).slideY(begin: 0.08, curve: Curves.easeOut);
              },
            ),
    );
  }

  Color _getChannelColor(int index) {
    const colors = [
      Color(0xFFEF5350),
      Color(0xFF5C6BC0),
      Color(0xFF26A69A),
      Color(0xFFFFA726),
      Color(0xFF7E57C2),
      Color(0xFF42A5F5),
      Color(0xFFEC407A),
    ];
    return colors[index % colors.length];
  }
}
