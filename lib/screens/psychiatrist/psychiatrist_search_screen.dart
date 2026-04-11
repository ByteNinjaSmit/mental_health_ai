import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../services/csv_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PsychiatristSearchScreen extends StatefulWidget {
  @override
  State<PsychiatristSearchScreen> createState() =>
      _PsychiatristSearchScreenState();
}

class _PsychiatristSearchScreenState
    extends State<PsychiatristSearchScreen> {
  List<DoctorModel> allDoctors = [];
  List<DoctorModel> filteredDoctors = [];

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  void loadDoctors() async {
    final data = await CsvService().loadDoctors();
    setState(() {
      allDoctors = data;
      filteredDoctors = data;
    });
  }

  void search(String query) {
    final result = allDoctors.where((doc) {
      return doc.city.toLowerCase().contains(query.toLowerCase()) ||
          doc.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredDoctors = result;
    });
  }

  Future<void> callDoctor(String phone) async {
    final Uri url = Uri.parse("tel:$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Psychiatrist"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by city or name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: search,
            ),
          ),

          Expanded(
            child: filteredDoctors.isEmpty
                ? Center(child: Text("No results found"))
                : ListView.builder(
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDoctors[index];

                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(doc.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doc.specialization),
                              Text(doc.city),
                              Text(doc.address),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.call, color: Colors.green),
                            onPressed: () => callDoctor(doc.phone),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}