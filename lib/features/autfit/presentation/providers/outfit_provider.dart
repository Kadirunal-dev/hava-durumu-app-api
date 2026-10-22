import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hava_kombin_app/core/services/api_service.dart';
import 'package:hava_kombin_app/features/autfit/data/models/outfit_model.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final outfitProvider = FutureProvider.autoDispose<OutfitModel>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getDailyOutfit();
});
