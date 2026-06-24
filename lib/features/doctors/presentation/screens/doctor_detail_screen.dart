import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_chrome.dart';
import 'doctor_list_screen.dart';

const _tagsBySpecialty = {
  'Cardiology': ['Heart Failure', 'Hypertension', 'Cardiac Imaging', 'Preventative Care'],
  'Dermatology': ['Acne', 'Skin Cancer', 'Cosmetic', 'Eczema'],
  'Pediatrics': ['Newborn Care', 'Vaccination', 'Nutrition', 'Development'],
  'Orthopedics': ['Sports Injury', 'Joint Care', 'Spine', 'Fractures'],
};

class DoctorDetailScreen extends ConsumerWidget {
  final String doctorId;
  const DoctorDetailScreen({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctors = ref.watch(doctorsProvider);
    final doctor = doctors.firstWhere((d) => d['id'] == doctorId);
    final tags = _tagsBySpecialty[doctor['specialty']] ?? const ['General Care'];

    return Scaffold(
      appBar: BrandAppBar(
        showAvatar: false,
        showBack: true,
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: AppColors.onSurfaceVariant), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border, color: AppColors.onSurfaceVariant), onPressed: () {}),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: -1),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          // Profile image card with glass overlay.
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppColors.medicalShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 4 / 4.4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      doctor['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceContainerHigh,
                        child: const Icon(Icons.person, size: 80, color: AppColors.outline),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xE6FFFFFF)],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor['specialty'].toString().toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  letterSpacing: 1),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doctor['name'],
                              style: const TextStyle(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 26),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Bento stats grid.
          Row(
            children: [
              Expanded(child: _StatTile(icon: Icons.star, value: '${doctor['rating']}', label: '${doctor['reviews']} Reviews', filled: true)),
              const SizedBox(width: 12),
              Expanded(child: _StatTile(icon: Icons.payments_outlined, value: '\$${doctor['fee']}', label: 'Consultation')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatTile(icon: Icons.verified_outlined, value: '${doctor['exp']}+', label: 'Years Exp.')),
              const SizedBox(width: 12),
              Expanded(child: _StatTile(icon: Icons.groups_outlined, value: '${doctor['patients']}', label: 'Patients Seen')),
            ],
          ),
          const SizedBox(height: 20),
          // About section.
          MedicalCard(
            border: Border.all(color: AppColors.surfaceVariant),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About ${doctor['name'].toString().replaceFirst('Dr. ', 'Dr. ')}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                const SizedBox(height: 12),
                Text(
                  '${doctor['name']} is a board-certified ${doctor['specialty']} specialist with over '
                  '${doctor['exp']} years of clinical experience. Combining precision with an empathetic, '
                  'patient-centered approach to evidence-based care.',
                  style: const TextStyle(color: AppColors.onSurfaceVariant, height: 1.6, fontSize: 15),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(t,
                                style: const TextStyle(
                                    color: AppColors.secondary, fontWeight: FontWeight.w600, fontSize: 13)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Location preview.
          MedicalCard(
            border: Border.all(color: AppColors.surfaceVariant),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Location',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                          SizedBox(height: 2),
                          Text('City Heart & Wellness Center, Suite 402',
                              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                        ],
                      ),
                    ),
                    Row(
                      children: const [
                        Text('Directions',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                        SizedBox(width: 2),
                        Icon(Icons.open_in_new, size: 16, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 140,
                    color: AppColors.surfaceContainerHigh,
                    child: const Center(
                      child: Icon(Icons.location_on, color: AppColors.primary, size: 36),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => context.push('/book/$doctorId'),
              icon: const Icon(Icons.event_available),
              label: const Text('Book Appointment', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('No cancellation fee up to 24h before',
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final bool filled;
  const _StatTile({required this.icon, required this.value, required this.label, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return MedicalCard(
      padding: const EdgeInsets.symmetric(vertical: 18),
      border: Border.all(color: AppColors.surfaceVariant),
      child: Column(
        children: [
          Icon(icon, color: filled ? AppColors.star : AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.onSurface)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
        ],
      ),
    );
  }
}
