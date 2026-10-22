import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/outfit_provider.dart';

class DailyOutfitView extends ConsumerWidget {
  const DailyOutfitView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfitAsync = ref.watch(outfitProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Günün Kombini')),
      body: outfitAsync.when(
        data: (outfit) {
          final kombin = outfit.gununKombini;

          if (kombin == null || kombin.isEmpty) {
            return const Center(
              child: Text('Gardrobunuzda bu havaya uygun kıyafet bulunamadı.'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Hava Durumu Özet Kartı
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        outfit.weather.cityName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${outfit.weather.temp}°C - ${outfit.weather.description}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bugün İçin Seçilen Kombin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Üst Giyim Kartı
              _buildOutfitCard(
                'Üst Giyim',
                kombin['ust'],
                Icons.roller_shades,
              ), // veya uygun ikon
              // Alt Giyim Kartı
              _buildOutfitCard(
                'Alt Giyim',
                kombin['alt'],
                Icons.accessibility_new,
              ),

              // Ayakkabı Kartı
              _buildOutfitCard(
                'Ayakkabı',
                kombin['ayakkabi'],
                Icons.snowboarding,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hata Oluştu: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutfitCard(String title, dynamic item, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, size: 36, color: Colors.deepPurple),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          item != null
              ? (item['name'] ?? 'Parça seçildi')
              : 'Bu kategoriye ait parça bulunamadı',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
