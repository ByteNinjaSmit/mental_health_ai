import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/helpline_service.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final helplines = HelplineService.helplines;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Helpline & Support"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Get Help Now",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF03045E), height: 1.2),
                  ).animate().fade().slideX(),
                  const SizedBox(height: 8),
                  Text(
                    "Reach out to trusted mental health organizations for support.",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.4),
                  ).animate().fade(delay: 100.ms).slideX(),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = helplines[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.description,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () => _makeCall(item.phone),
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone_in_talk_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          item.phone,
                                          style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () => _launchURL(item.website),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.language_rounded, size: 16, color: Color(0xFF0077B6)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            item.website,
                                            style: const TextStyle(
                                              fontSize: 13, 
                                              color: Color(0xFF0077B6), 
                                              decoration: TextDecoration.underline,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _makeCall(item.phone),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text("Call Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fade(delay: (200 + index * 100).ms).slideY(begin: 0.1);
                },
                childCount: helplines.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}