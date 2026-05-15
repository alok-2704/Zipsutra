import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

class CreateZipScreen extends StatefulWidget {
  const CreateZipScreen({super.key});

  @override
  State<CreateZipScreen> createState() => _CreateZipScreenState();
}

class _CreateZipScreenState extends State<CreateZipScreen> {
  List<PlatformFile> selectedFiles = [];
  bool isCreatingZip = false;

  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        selectedFiles = result.files;
      });
    }
  }

  Future<void> createZip() async {
    if (selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select files first')),
      );
      return;
    }

    setState(() {
      isCreatingZip = true;
    });

    try {
      final archive = Archive();

      for (final file in selectedFiles) {
        if (file.path == null) continue;

        final bytes = await File(file.path!).readAsBytes();

        archive.addFile(ArchiveFile(file.name, bytes.length, bytes));
      }

      final documentsDir = await getApplicationDocumentsDirectory();
      final zipPath =
          '${documentsDir.path}/archive_${DateTime.now().millisecondsSinceEpoch}.zip';

      final encoder = ZipEncoder();
      final zipData = encoder.encode(archive);


      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(zipData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ZIP saved to:\n$zipPath'),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isCreatingZip = false;
        });
      }
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create ZIP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: pickFiles,
              icon: const Icon(Icons.attach_file),
              label: const Text('Select Files'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: selectedFiles.isEmpty
                  ? const Center(child: Text('No files selected'))
                  : ListView.builder(
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.insert_drive_file),
                            title: Text(file.name),
                            subtitle: Text(formatFileSize(file.size)),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isCreatingZip ? null : createZip,
                icon: isCreatingZip
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.folder_zip),
                label: Text(isCreatingZip ? 'Creating ZIP...' : 'Create ZIP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
