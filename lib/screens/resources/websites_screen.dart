import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/resource_service.dart';

class WebsitesScreen extends StatelessWidget {
  final String category;

  const WebsitesScreen({super.key, required this.category});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final siteList = ResourceDataService.websites[category] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('$category — Trusted Sources')),
      body: siteList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text("No websites available yet.", style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // Header card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF0077B6).withOpacity(0.12),
                        const Color(0xFF0077B6).withOpacity(0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF0077B6).withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0077B6).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.verified_rounded, color: Color(0xFF0077B6), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Verified Resources',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF03045E),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Curated links from trusted mental health organizations',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: -0.1),

                const SizedBox(height: 20),

                // Website cards
                ...siteList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final site = entry.value;
                  final color = _getSiteColor(index);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.12)),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => _launchUrl(site['url'] ?? ''),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [color, color.withOpacity(0.7)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    (site['name'] ?? 'W')[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      site['name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF03045E),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      site['description'] ?? '',
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
                                  color: color.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.open_in_new_rounded, color: color, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fade(delay: (70 * index).ms).slideY(begin: 0.08, curve: Curves.easeOut);
                }),
              ],
            ),
    );
  }

  Color _getSiteColor(int index) {
    const colors = [
      Color(0xFF0077B6),
      Color(0xFF5C6BC0),
      Color(0xFF26A69A),
      Color(0xFFEF5350),
      Color(0xFF7E57C2),
      Color(0xFF42A5F5),
      Color(0xFFFFA726),
      Color(0xFFEC407A),
    ];
    return colors[index % colors.length];
  }
}
