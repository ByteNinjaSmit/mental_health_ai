import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../services/booking_service.dart';
import '../models/appointment_model.dart';
import 'booking/doctor_profile_screen.dart';
import 'booking/booking_detail_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Appointments'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 3,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(icon: Icon(Icons.person_search_rounded, size: 20), text: 'Doctors'),
            Tab(icon: Icon(Icons.event_available_rounded, size: 20), text: 'Upcoming'),
            Tab(icon: Icon(Icons.history_rounded, size: 20), text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DoctorsTab(),
          _UpcomingTab(),
          _HistoryTab(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TAB 1: DOCTOR LIST
// ═══════════════════════════════════════════════════════════════════════════
class _DoctorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: BookingService.doctors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final doctor = BookingService.doctors[index];
        return _DoctorCard(doctor: doctor, index: index);
      },
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorInfo doctor;
  final int index;

  const _DoctorCard({required this.doctor, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DoctorProfileScreen(doctor: doctor)),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              // Avatar
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2), width: 2),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: NetworkImage(doctor.avatarUrl),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.specialization,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _MiniChip(
                          icon: Icons.star_rounded,
                          label: '${doctor.rating}',
                          color: const Color(0xFFFFA726),
                        ),
                        const SizedBox(width: 8),
                        _MiniChip(
                          icon: Icons.work_history_rounded,
                          label: '${doctor.experience} yrs',
                          color: const Color(0xFF5C6BC0),
                        ),
                        const SizedBox(width: 8),
                        _MiniChip(
                          icon: Icons.currency_rupee_rounded,
                          label: '${doctor.fee}',
                          color: const Color(0xFF26A69A),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade300),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: (60 * index).ms).slideX(begin: 0.05, curve: Curves.easeOut);
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TAB 2: UPCOMING APPOINTMENTS
// ═══════════════════════════════════════════════════════════════════════════
class _UpcomingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppointmentModel>>(
      stream: BookingService.getUpcomingAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data ?? [];
        if (appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available_rounded, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text('No upcoming appointments', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                const SizedBox(height: 8),
                Text('Book a session to get started', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
              ],
            ),
          ).animate().fade();
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: appointments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _AppointmentCard(
              appointment: appointments[index],
              index: index,
              isUpcoming: true,
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TAB 3: HISTORY
// ═══════════════════════════════════════════════════════════════════════════
class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppointmentModel>>(
      stream: BookingService.getPastAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data ?? [];
        if (appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text('No past bookings', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
              ],
            ),
          ).animate().fade();
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: appointments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _AppointmentCard(
              appointment: appointments[index],
              index: index,
              isUpcoming: false,
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHARED: APPOINTMENT CARD
// ═══════════════════════════════════════════════════════════════════════════
class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final int index;
  final bool isUpcoming;

  const _AppointmentCard({
    required this.appointment,
    required this.index,
    required this.isUpcoming,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(appointment.status);
    final doctor = BookingService.getDoctorById(appointment.doctorId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(color: statusColor.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookingDetailScreen(appointment: appointment)),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Doctor + Status
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: doctor != null ? NetworkImage(doctor.avatarUrl) : null,
                    child: doctor == null ? const Icon(Icons.person, size: 20) : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
                        ),
                        Text(
                          appointment.specialization.isNotEmpty ? appointment.specialization : 'Mental Health Professional',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      appointment.status.toUpperCase(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor, letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Date & Time
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 15, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)),
                  const SizedBox(width: 8),
                  Text(
                    _formatDisplayDate(appointment.date),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time_rounded, size: 15, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)),
                  const SizedBox(width: 6),
                  Text(
                    appointment.timeSlot.isNotEmpty ? appointment.timeSlot.split(' - ')[0] : 'N/A',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              // Cancel button for upcoming
              if (isUpcoming && appointment.isBooked) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showQuickCancel(context),
                      icon: const Icon(Icons.cancel_outlined, size: 15, color: Colors.redAccent),
                      label: const Text('Cancel', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8), visualDensity: VisualDensity.compact),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fade(delay: (50 * index).ms).slideY(begin: 0.08, curve: Curves.easeOut);
  }

  void _showQuickCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Appointment?'),
        content: Text('Cancel your session with ${appointment.doctorName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keep')),
          TextButton(
            onPressed: () async {
              await BookingService.cancelAppointment(appointment.id);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Appointment cancelled'), backgroundColor: Colors.redAccent),
                );
              }
            },
            child: const Text('Cancel It', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDisplayDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('EEE, MMM d').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'booked':
        return const Color(0xFF0077B6);
      case 'completed':
        return const Color(0xFF26A69A);
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}