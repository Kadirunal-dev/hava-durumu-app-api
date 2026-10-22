import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hava_kombin_app/features/autfit/presentation/providers/outfit_provider.dart';
import 'package:hava_kombin_app/features/autfit/presentation/screens/kombin_screen.dart';

class HomeOutfitCard extends ConsumerWidget {
  const HomeOutfitCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfitAsync = ref.watch(outfitProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // Cam efekti şeffaflığı
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.08),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DailyOutfitView(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık ve Yenileme Butonu (Expanded ile taşma riski ortadan kaldırıldı)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Günün Kombin Önerisi',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            onPressed: () {
                              ref.invalidate(outfitProvider);
                            },
                            tooltip: 'Kombini Yenile',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // İçerik Alanı
                      outfitAsync.when(
                        data: (outfit) {
                          final kombin = outfit.gununKombini;

                          if (kombin == null || kombin.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Bu hava koşuluna uygun parça bulunamadı.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }

                          final ustParca =
                              kombin['ust']?['name'] ?? 'Üst parça';
                          final altParca =
                              kombin['alt']?['name'] ?? 'Alt parça';
                          final ayakkabi =
                              kombin['ayakkabi']?['name'] ?? 'Ayakkabı';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildOutfitRow(
                                Icons.checkroom_rounded,
                                'Üst: $ustParca',
                              ),
                              const SizedBox(height: 6),
                              _buildOutfitRow(
                                Icons.layers_rounded,
                                'Alt: $altParca',
                              ),
                              const SizedBox(height: 6),
                              _buildOutfitRow(
                                Icons.snowboarding_rounded,
                                'Ayakkabı: $ayakkabi',
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Text(
                                    'Detayları İncele',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                        ),
                        error: (err, stack) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Kombin yüklenirken bir hata oluştu.',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Satır düzeni için yardımcı fonksiyon (Expanded ile metin taşmaları engellendi)
  Widget _buildOutfitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
