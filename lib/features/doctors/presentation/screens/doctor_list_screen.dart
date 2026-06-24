import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_chrome.dart';

final doctorsProvider = Provider<List<Map<String, dynamic>>>((ref) => [
  {'id': '1', 'name': 'Dr. Sarah Chen', 'specialty': 'Cardiology', 'exp': 12, 'rating': 4.9, 'reviews': 248, 'fee': 120, 'patients': '2k+', 'available': true, 'favorite': true, 'image': 'https://i.pravatar.cc/300?img=47'},
  {'id': '2', 'name': 'Dr. James Miller', 'specialty': 'Dermatology', 'exp': 15, 'rating': 4.7, 'reviews': 185, 'fee': 95, 'patients': '1.5k+', 'available': true, 'favorite': false, 'image': 'https://i.pravatar.cc/300?img=12'},
  {'id': '3', 'name': 'Dr. Priya Patel', 'specialty': 'Pediatrics', 'exp': 8, 'rating': 4.8, 'reviews': 312, 'fee': 85, 'patients': '3k+', 'available': false, 'favorite': false, 'image': 'https://i.pravatar.cc/300?img=45'},
  {'id': '4', 'name': 'Dr. Robert Kim', 'specialty': 'Orthopedics', 'exp': 20, 'rating': 4.6, 'reviews': 156, 'fee': 140, 'patients': '1.8k+', 'available': true, 'favorite': false, 'image': 'https://i.pravatar.cc/300?img=33'},
]);

const _categories = ['All', 'Cardiology', 'Dermatology', 'Pediatrics', 'Neurology'];

class DoctorListScreen extends ConsumerWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctors = ref.watch(doctorsProvider);
    return Scaffold(
      appBar: BrandAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.primary),
            onPressed: () => context.push('/history'),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(current: 0),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Text(
            'Find your specialist',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppColors.medicalShadow,
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or specialty',
                      hintStyle: TextStyle(color: AppColors.outlineVariant, fontSize: 15),
                      prefixIcon: Icon(Icons.search, color: AppColors.outline),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.tune, color: AppColors.onPrimary, size: 20),
                        SizedBox(width: 6),
                        Text('Filters',
                            style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => _CategoryChip(label: _categories[i], selected: i == 0),
            ),
          ),
          const SizedBox(height: 24),
          ...doctors.map((doc) => _DoctorCard(doctor: doc)),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.secondaryContainer : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        border: selected ? null : Border.all(color: AppColors.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.onSecondaryContainer : AppColors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MedicalCard(
        padding: const EdgeInsets.all(18),
        onTap: () => context.push('/doctor/${doctor['id']}'),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    doctor['image'],
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(Icons.person, color: AppColors.outline),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doctor['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            doctor['favorite'] ? Icons.favorite : Icons.favorite_border,
                            color: doctor['favorite'] ? AppColors.primary : AppColors.outline,
                            size: 22,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${doctor['specialty']} • ${doctor['exp']} yrs exp.',
                        style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.star),
                          const SizedBox(width: 4),
                          Text('${doctor['rating']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.onSurface)),
                          const SizedBox(width: 4),
                          Text('(${doctor['reviews']} reviews)',
                              style: const TextStyle(color: AppColors.outline, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.outlineVariant),
            const SizedBox(height: 14),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CONSULTATION FEE',
                        style: TextStyle(
                            color: AppColors.outline,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5)),
                    Text('\$${doctor['fee']}',
                        style: const TextStyle(
                            color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w800)),
                  ],
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => context.push('/doctor/${doctor['id']}'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
