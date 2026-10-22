import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hava_kombin_app/features/autfit/presentation/screens/kombin_screen.dart';
import 'package:hava_kombin_app/features/auth/presentation/provider/auth_controller.dart';
import 'package:hava_kombin_app/features/auth/presentation/screens/login_screens.dart';
import 'package:hava_kombin_app/features/home/presentation/widgets/home_outfit_card.dart';
import 'package:hava_kombin_app/features/weather/providers/weather_provider.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

final testWeatherConditionProvider = StateProvider<String?>((ref) => null);
final testHourProvider = StateProvider<int?>((ref) => null);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _rainConditions = ['rain', 'rainy', 'yağmur'];
  static const _snowConditions = ['snow', 'snowy', 'kar'];
  static const _clearConditions = ['sun', 'clear', 'sunny', 'güneş', 'gunes'];
  static const _windConditions = ['wind', 'windy', 'rüzgar'];
  static const _cloudConditions = ['cloud', 'bulut'];

  bool _matchesCondition(String condition, List<String> keywords) {
    return keywords.any(condition.contains);
  }

  Color _getBackgroundColor(String condition) {
    if (_matchesCondition(condition, _rainConditions)) {
      return const Color(0xFF2C3E50);
    } else if (_matchesCondition(condition, _snowConditions)) {
      return const Color(0xFF334155);
    } else if (_matchesCondition(condition, _clearConditions)) {
      return const Color(0xFFFFFFFF);
    } else if (_matchesCondition(condition, _cloudConditions)) {
      return const Color(0xFF475569);
    }
    return const Color(0xFF0F172A);
  }

  WeatherType _getWeatherType(String condition, bool isNight) {
    if (_matchesCondition(condition, _rainConditions)) {
      return isNight ? WeatherType.thunder : WeatherType.heavyRainy;
    }
    if (_matchesCondition(condition, _snowConditions)) {
      return WeatherType.heavySnow;
    }
    if (_matchesCondition(condition, _clearConditions)) {
      return isNight ? WeatherType.sunnyNight : WeatherType.sunny;
    }
    if (_matchesCondition(condition, _windConditions)) {
      return isNight ? WeatherType.foggy : WeatherType.cloudyNight;
    }
    return WeatherType.sunny;
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildTestButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: onPressed,
      child: Text(label, textAlign: TextAlign.center),
    );
  }

  Widget _buildTestControls(
    WidgetRef ref, {
    required String? condition,
    required int? hour,
  }) {
    const testConditions = ['clear', 'rain', 'snow', 'wind'];
    final currentIndex = testConditions.indexOf(condition ?? '');
    final nextCondition =
        testConditions[(currentIndex + 1) % testConditions.length];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTestButton(
                  label: 'Hava: ${condition ?? 'API verisi'}',
                  onPressed: () {
                    ref.read(testWeatherConditionProvider.notifier).state =
                        nextCondition;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTestButton(
                  label: 'Hava testini sıfırla',
                  onPressed: () {
                    ref.read(testWeatherConditionProvider.notifier).state =
                        null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTestButton(
                  label: 'Geceyi test et',
                  onPressed: () {
                    ref.read(testHourProvider.notifier).state = 20;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTestButton(
                  label: 'Gündüzü test et',
                  onPressed: () {
                    ref.read(testHourProvider.notifier).state = 12;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildTestButton(
              label: hour == null
                  ? 'Gerçek saati kullan'
                  : 'Test saatini sıfırla ($hour)',
              onPressed: () {
                ref.read(testHourProvider.notifier).state = null;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testHour = ref.watch(testHourProvider);
    final hour = testHour ?? DateTime.now().hour;
    final isNight = hour >= 18 || hour < 6;

    final weatherAsync = ref.watch(weatherProvider);
    final testCondition = ref.watch(testWeatherConditionProvider);

    return weatherAsync.when(
      data: (weather) {
        final condition = (testCondition ?? weather.condition).toLowerCase();
        final bgColor = _getBackgroundColor(condition);

        final weatherType = _getWeatherType(condition, isNight);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            foregroundColor: Colors.white,
            centerTitle: true,
            title: const Text('Ana Sayfa'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          extendBodyBehindAppBar:
              true, // AppBar'ın arkasını da body'ye dahil eder
          body: Stack(
            children: [
              Positioned.fill(
                child: SizedBox.expand(
                  child: WeatherBg(
                    weatherType: weatherType,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
              ),
              // 1. KATMAN: Sayfanın normal içeriği (Taşmaları önlemek için SafeArea ve SingleChildScrollView eklendi)
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Hava Durumu Cam Kartı
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 19),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 10.0,
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.all(24.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      weather.cityName,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${weather.temp}°C',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      weather.condition,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const HomeOutfitCard(),
                        const SizedBox(height: 10),

                        // Alt Kısımdaki Butonlar Alanı (Overflow / Taşma hatasını önlemek için Expanded eklendi)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 19,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DailyOutfitView(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.auto_awesome,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    'GÜNÜN KOMBİNİ',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: _buttonStyle(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await ref
                                        .read(authControllerProvider.notifier)
                                        .logout();
                                    if (!context.mounted) return;
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                      ((route) => false),
                                    );
                                  },
                                  icon: const Icon(Icons.checkroom, size: 18),
                                  label: const Text(
                                    'Çıkış Yap',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: _buttonStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildTestControls(
                          ref,
                          condition: testCondition,
                          hour: testHour,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Hata: $err',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
