import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hava_kombin_app/core/services/api_service.dart';

import 'package:hava_kombin_app/features/wardrobe/model/wardrobe_model.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final wardrobeProvider = FutureProvider.autoDispose<List<WardrobeItem>>((
  ref,
) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getWardrobeItems();
});
