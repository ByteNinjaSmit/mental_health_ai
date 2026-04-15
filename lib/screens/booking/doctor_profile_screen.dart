import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/booking_service.dart';
import 'slot_picker_screen.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorInfo doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── HERO HEADER ──
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                      const Color(0xFF00B4D8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          backgroundImage: NetworkImage(doctor.avatarUrl),
                        ),
                      ).animate().scale(delay: 100.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: 16),
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fade(delay: 150.ms).slideY(begin: 0.2),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          doctor.specialization,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ).animate().fade(delay: 200.ms).slideY(begin: 0.2),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── BODY ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.work_history_rounded,
                          value: '${doctor.experience} yrs',
                          label: 'Experience',
                          color: const Color(0xFF5C6BC0),
                        ),
                        _StatItem(
                          icon: Icons.star_rounded,
                          value: '${doctor.rating}',
                          label: 'Rating',
                          color: const Color(0xFFFFA726),
                        ),
                        _StatItem(
                          icon: Icons.currency_rupee_rounded,
                          value: '${doctor.fee}',
                          label: 'per Session',
                          color: const Color(0xFF26A69A),
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 250.ms).slideY(begin: 0.1),

                  const SizedBox(height: 24),

                  // About Section
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    doctor.bio,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.6),
                  ),

                  const SizedBox(height: 24),

                  // Availability Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0077B6).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF0077B6).withValues(alpha: 0.12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule_rounded, color: Theme.of(context).colorScheme.primary, size: 22),
                            const SizedBox(width: 10),
                            const Text(
                              'Working Hours',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF03045E)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '9:00 AM – 6:00 PM',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, color: Theme.of(context).colorScheme.primary, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              'Available: ${_formatDays(doctor.availableDays)}',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, color: Theme.of(context).colorScheme.primary, size: 18),
                            const SizedBox(width: 10),
                            Text(
                              'Session Duration: 45 minutes',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 350.ms).slideY(begin: 0.1),

                  const SizedBox(height: 32),

                  // Book Now Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SlotPickerScreen(doctor: doctor),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_month_rounded),
                      label: const Text('Book Appointment', style: TextStyle(fontSize: 17)),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ).animate().fade(delay: 400.ms).slideY(begin: 0.2),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDays(List<int> days) {
    const dayNames = {1: 'Mon', 2: 'Tue', 3: 'Wed', 4: 'Thu', 5: 'Fri', 6: 'Sat', 7: 'Sun'};
    return days.map((d) => dayNames[d] ?? '').join(', ');
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
