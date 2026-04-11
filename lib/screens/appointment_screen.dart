import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/firestore_service.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final FirestoreService _service = FirestoreService();

  final List<Map<String, String>> doctors = [
    {
      "name": "Dr. Sharma",
      "specialty": "Clinical Psychologist",
      "rating": "4.9",
      "image": "https://api.dicebear.com/7.x/avataaars/png?seed=Sharma&backgroundColor=00B4D8"
    },
    {
      "name": "Dr. Patel",
      "specialty": "Psychiatrist",
      "rating": "4.8",
      "image": "https://api.dicebear.com/7.x/avataaars/png?seed=Patel&backgroundColor=48CAE4"
    },
    {
      "name": "Dr. Singh",
      "specialty": "Therapist",
      "rating": "4.7",
      "image": "https://api.dicebear.com/7.x/avataaars/png?seed=Singh&backgroundColor=90E0EF"
    },
  ];

  Future<void> _bookSlot(BuildContext context, String doctorName) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Theme.of(context).colorScheme.primary),
            dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !context.mounted) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Theme.of(context).colorScheme.primary),
            dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Processing booking request..."), duration: Duration(seconds: 1)),
    );

    String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year} at ${pickedTime.format(context)}";
    await _service.bookAppointment(doctorName, formattedDate);

    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text("Appointment Confirmed!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                "Your session with $doctorName is scheduled for $formattedDate.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Done"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorList() {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: doctors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: NetworkImage(doctor['image']!),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor['name']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
                      const SizedBox(height: 4),
                      Text(doctor['specialty']!, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text(doctor['rating']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _bookSlot(context, doctor['name']!),
                  child: const Text("Book"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: _service.getAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy_rounded, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text("No bookings found", style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
              ],
            ),
          );
        }

        // Get and sort docs app-side to avoid Firestore Index requirement
        final allDocs = snapshot.data!.docs.toList();
        allDocs.sort((a, b) {
          final aTime = (a.data() as Map)['timestamp'] as Timestamp;
          final bTime = (b.data() as Map)['timestamp'] as Timestamp;
          return bTime.compareTo(aTime); // Descending order
        });

        final now = Timestamp.now();
        final upcoming = <QueryDocumentSnapshot>[];
        final past = <QueryDocumentSnapshot>[];

        for (var doc in allDocs) {
          final data = doc.data() as Map<String, dynamic>;
          final timestamp = data['timestamp'] as Timestamp;
          // Simple logic: if booking timestamp is in future = upcoming
          // Or we can check the formatted date string if preferred, but timestamp is more robust
          if (timestamp.seconds >= now.seconds - 3600) { // Keep session upcoming for 1 hour after start
            upcoming.add(doc);
          } else {
            past.add(doc);
          }
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (upcoming.isNotEmpty) ...[
              const _SectionHeader(title: "Upcoming Sessions", icon: Icons.schedule_rounded),
              const SizedBox(height: 16),
              ...upcoming.map((doc) => _buildHistoryCard(doc, isUpcoming: true)),
              const SizedBox(height: 24),
            ],
            if (past.isNotEmpty) ...[
              const _SectionHeader(title: "Past History", icon: Icons.history_rounded),
              const SizedBox(height: 16),
              ...past.map((doc) => _buildHistoryCard(doc, isUpcoming: false)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildHistoryCard(QueryDocumentSnapshot doc, {required bool isUpcoming}) {
    final data = doc.data() as Map<String, dynamic>;
    final docId = doc.id;
    final isPending = data['status'] == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['doctor'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF03045E))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPending ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data['status'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPending ? Colors.orange : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_month_rounded, size: 16, color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
              const SizedBox(width: 8),
              Text(data['date'], style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          if (isPending && isUpcoming) ...[
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => _service.cancelAppointment(docId),
                  icon: const Icon(Icons.cancel_outlined, size: 16, color: Colors.redAccent),
                  label: const Text("Cancel Booking", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade300),
              ],
            ),
          ]
        ],
      ),
    ).animate().fade().slideY(begin: 0.1);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text("Appointments"),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "New Booking"),
              Tab(text: "My History"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDoctorList(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF03045E)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
        ),
      ],
    );
  }
}