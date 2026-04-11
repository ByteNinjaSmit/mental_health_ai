import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/helpline_model.dart';

class HelplineDetailScreen extends StatelessWidget {
  final HelplineModel helpline;

  HelplineDetailScreen({required this.helpline});

  Future<void> makeCall(String phone) async {
    final Uri url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openWebsite(String link) async {
    final Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(helpline.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.support, size: 80, color: Colors.blue),
            SizedBox(height: 20),

            Text(
              helpline.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),
            Text(helpline.description),

            SizedBox(height: 20),

            // CALL BUTTON
            ElevatedButton.icon(
              icon: Icon(Icons.call),
              label: Text("Call Now"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () => makeCall(helpline.phone),
            ),

            SizedBox(height: 10),

            // WEBSITE BUTTON
            ElevatedButton.icon(
              icon: Icon(Icons.language),
              label: Text("Visit Website"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () => openWebsite(helpline.website),
            ),
          ],
        ),
      ),
    );
  }
}