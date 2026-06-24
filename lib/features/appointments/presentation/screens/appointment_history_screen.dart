import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_chrome.dart';
import 'booking_screen.dart';

const _pastAppointments = [
  {'name': 'Dr. James Miller', 'specialty': 'Dermatology', 'date': 'Sep 28, 2025', 'fee': 95, 'image': 'https://i.pravatar.cc/150?img=12'},
  {'name': 'Dr. Priya Patel', 'specialty': 'Pediatrics', 'date': 'Sep 12, 2025', 'fee': 85, 'image': 'https://i.pravatar.cc/150?img=45'},
];

class AppointmentHistoryScreen extends ConsumerWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: const BrandAppBar(),
      bottomNavigationBar: const AppBottomNav(current: 2),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Text('History',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          const Text('Manage your past and upcoming appointments.',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15)),
          const SizedBox(height: 20),
          Row(
            children: const [
              _FilterChip(label: 'All', selected: true),
              SizedBox(width: 10),
              _FilterChip(label: 'Upcoming', selected: false),
              SizedBox(width: 10),
              _FilterChip(label: 'Past', selected: false),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionLabel('UPCOMING APPOINTMENTS'),
          const SizedBox(height: 12),
          if (upcoming.isEmpty)
            _EmptyUpcoming()
          else
            ...upcoming.map((a) => _UpcomingCard(appt: a)),
          const SizedBox(height: 24),
          const _SectionLabel('PAST APPOINTMENTS'),
          const SizedBox(height: 12),
          ..._pastAppointments.map((a) => _PastItem(appt: a)),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: AppColors.outline, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1));
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, required this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(
              color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 13)),
    );
  }
}

class _EmptyUpcoming extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MedicalCard(
      border: Border.all(color: AppColors.surfaceVariant),
      padding: const EdgeInsets.symmetric(vertical: 36),
      child: const Column(
        children: [
          Icon(Icons.event_busy, size: 48, color: AppColors.outlineVariant),
          SizedBox(height: 12),
          Text('No upcoming appointments', style: TextStyle(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final Map<String, dynamic> appt;
  const _UpcomingCard({required this.appt});

  @override
  Widget build(BuildContext context) {
    final name = appt['name'] ?? 'Doctor #${appt['doctorId']}';
    final specialty = appt['specialty'] ?? 'General';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MedicalCard(
        border: Border.all(color: AppColors.surfaceVariant.withValues(alpha: 0.5)),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                if (appt['image'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(appt['image'],
                        width: 52, height: 52, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarFallback()),
                  )
                else
                  _avatarFallback(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.onSurface)),
                      Text(specialty, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${appt['status']}'.replaceFirst('c', 'C'),
                    style: const TextStyle(
                        color: AppColors.onSecondaryContainer, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _iconRow(Icons.calendar_today, '${appt['date']}'),
                  const SizedBox(height: 10),
                  _iconRow(Icons.schedule, '${appt['slot']}'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Reschedule', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconRow(IconData icon, String text) => Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
        ],
      );

  Widget _avatarFallback() => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primaryFixed,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.medical_services, color: AppColors.primary),
      );
}

class _PastItem extends StatelessWidget {
  final Map<String, dynamic> appt;
  const _PastItem({required this.appt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
                child: Image.network(appt['image'],
                    width: 48, height: 48, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 48, height: 48, color: AppColors.surfaceContainerHigh,
                        child: const Icon(Icons.person, color: AppColors.outline))),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appt['name'],
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.onSurface)),
                  Text('${appt['specialty']} • ${appt['date']}',
                      style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('COMPLETED',
                    style: TextStyle(
                        color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w700)),
                Text('Paid: \$${appt['fee']}.00',
                    style: const TextStyle(color: AppColors.outline, fontSize: 12)),
              ],
            ),
            const Icon(Icons.chevron_right, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}
