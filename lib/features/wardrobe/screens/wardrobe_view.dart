import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wardrobe_provider.dart';

class WardrobeView extends ConsumerStatefulWidget {
  const WardrobeView({super.key});

  @override
  ConsumerState<WardrobeView> createState() => _WardrobeViewState();
}

class _WardrobeViewState extends ConsumerState<WardrobeView> {
  // Yeni kıyafet ekleme modalını açan fonksiyon
  void _showAddModal(BuildContext context) {
    final imageController = TextEditingController();
    final nameController = TextEditingController();
    String selectedCategory = 'ust';
    String weather_type = 'gunesli';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gardıroba Yeni Parça Ekle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Kıyafet Adı (örn: Siyah Mont)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: const [
                  DropdownMenuItem(value: 'ust', child: Text('Üst Giyim')),
                  DropdownMenuItem(value: 'alt', child: Text('Alt Giyim')),
                  DropdownMenuItem(value: 'ayakkabi', child: Text('Ayakkabı')),
                ],
                onChanged: (val) => selectedCategory = val!,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: weather_type,
                items: const [
                  DropdownMenuItem(
                    value: 'gunesli',
                    child: Text('Güneşli / Açık'),
                  ),
                  DropdownMenuItem(value: 'bulutlu', child: Text('Bulutlu')),
                  DropdownMenuItem(
                    value: 'parcali_bulutlu',
                    child: Text('Parçalı Bulutlu'),
                  ),
                  DropdownMenuItem(value: 'yagmurlu', child: Text('Yağmurlu')),
                  DropdownMenuItem(value: 'ruzgarli', child: Text('Rüzgarlı')),
                  DropdownMenuItem(value: 'karli', child: Text('Karlı')),
                ],
                onChanged: (val) => weather_type = val!,
                decoration: const InputDecoration(
                  labelText: 'Hava Uygunluğu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'Kıyafetin görsel linki',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    if (nameController.text.isNotEmpty) {
                      final apiService = ref.read(apiServiceProvider);
                      await apiService.addWardrobeItem(
                        name: nameController.text,
                        category: selectedCategory,
                        weatherType: weather_type,
                        imageUrl: imageController.text,
                      );
                      // Listeyi yenile ve modalı kapat
                      ref.invalidate(wardrobeProvider);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Kaydet', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wardrobeAsync = ref.watch(wardrobeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gardırobum'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Üst Kısmı Liste Alanı Olarak Ayarlıyoruz
          Expanded(
            child: wardrobeAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.checkroom_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Gardırobunuzda henüz kıyafet bulunmuyor.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: Key(item.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        // Kullanıcıya silme için onay popup'ı gösteriyoruz
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text('Kyafeti Sil'),
                              content: Text(
                                '${item.name} adlı kıyafeti silmek istediğinize emin misiniz?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(
                                    context,
                                  ).pop(false), // Hayır, silme
                                  child: const Text(
                                    'İptal',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => Navigator.of(
                                    context,
                                  ).pop(true), // Evet, sil
                                  child: const Text('Sil'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async {
                        final apiService = ref.read(apiServiceProvider);
                        await apiService.deleteWardrobeItem(item.id);

                        // Listeyi yenile
                        ref.invalidate(wardrobeProvider);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.name} gardıroptan silindi'),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade50,
                            child: Icon(
                              item.category == 'ust'
                                  ? Icons.checkroom
                                  : item.category == 'alt'
                                  ? Icons.accessibility_new
                                  : Icons.snowboarding,
                              color: Colors.deepPurple,
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Kategori: ${item.category} | Hava: ${item.weatherType}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            onPressed: () async {
                              // İsteğe bağlı olarak silme ikonuna basıldığında da aynı onay penceresi tetiklenebilir
                              bool? confirm = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: const Text('Kyafeti Sil'),
                                    content: Text(
                                      '${item.name} adlı kıyafeti silmek istediğinize emin misiniz?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text(
                                          'İptal',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text('Sil'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                final apiService = ref.read(apiServiceProvider);
                                await apiService.deleteWardrobeItem(item.id);
                                ref.invalidate(wardrobeProvider);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Yüklenirken hata oluştu:\n$err',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          // İstediğin Gibi Sayfanın Alt Kısmında Sabit Ekleme Butonu Alanı
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'Gardıroba Kıyafet Ekle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _showAddModal(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
