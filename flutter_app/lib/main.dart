import 'package:flutter/material.dart';
import 'screens/zip_screen.dart';

void main() {
  runApp(const ZipSutraApp());
}

class ZipSutraApp extends StatelessWidget {
  const ZipSutraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZipSutra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<_FeatureItem> features = const [
    _FeatureItem(
      title: 'Compress Media',
      icon: Icons.photo_size_select_large,
    ),
    _FeatureItem(
      title: 'Create ZIP',
      icon: Icons.folder_zip,
    ),
    _FeatureItem(
      title: 'Extract ZIP',
      icon: Icons.unarchive,
    ),
    _FeatureItem(
      title: 'History',
      icon: Icons.history,
    ),
    _FeatureItem(
      title: 'Settings',
      icon: Icons.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZipSutra'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final feature = features[index];

            return Card(
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
               onTap: () {
  if (feature.title == 'Create ZIP') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateZipScreen(),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${feature.title} coming soon'),
      ),
    );
  }
},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        feature.icon,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        feature.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureItem {
  final String title;
  final IconData icon;

  const _FeatureItem({
    required this.title,
    required this.icon,
  });
}