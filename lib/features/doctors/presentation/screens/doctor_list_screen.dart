import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final doctorsProvider = Provider<List<Map<String, dynamic>>>((ref) => [
  {'id': '1', 'name': 'Dr. Sarah Chen', 'specialty': 'Cardiology', 'rating': 4.9, 'reviews': 248, 'fee': 120, 'available': true, 'image': 'https://i.pravatar.cc/150?img=47'},
  {'id': '2', 'name': 'Dr. James Miller', 'specialty': 'Dermatology', 'rating': 4.7, 'reviews': 185, 'fee': 95, 'available': true, 'image': 'https://i.pravatar.cc/150?img=12'},
  {'id': '3', 'name': 'Dr. Priya Patel', 'specialty': 'Pediatrics', 'rating': 4.8, 'reviews': 312, 'fee': 85, 'available': false, 'image': 'https://i.pravatar.cc/150?img=45'},
  {'id': '4', 'name': 'Dr. Robert Kim', 'specialty': 'Orthopedics', 'rating': 4.6, 'reviews': 156, 'fee': 140, 'available': true, 'image': 'https://i.pravatar.cc/150?img=33'},
]);

class DoctorListScreen extends ConsumerWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctors = ref.watch(doctorsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Doctor'),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () => context.push('/history')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search doctors...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Available Doctors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...doctors.map((doc) => _DoctorCard(doctor: doc)),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/doctor/${doctor['id']}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(radius: 32, backgroundImage: NetworkImage(doctor['image'])),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(doctor['specialty'], style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(' ${doctor['rating']} (${doctor['reviews']})', style: const TextStyle(fontSize: 12)),
                        const Spacer(),
                        Text('\$${doctor['fee']}/visit', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
