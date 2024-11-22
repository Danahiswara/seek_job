import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailPage({super.key, required this.job});

  // Fungsi untuk menghapus tag HTML dari teks
  String cleanHtml(String htmlContent) {
    return htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), '') // Hapus semua tag HTML
        .replaceAll(RegExp(r'&nbsp;'), ' ') // Hapus entitas HTML untuk spasi
        .replaceAll(RegExp(r'&amp;'), '&') // Hapus entitas HTML untuk ampersand
        .trim(); // Hilangkan spasi di awal dan akhir
  }

  @override
  Widget build(BuildContext context) {
    // Deskripsi pekerjaan tanpa HTML
    final String cleanDescription = job['jobDescription'] != null
        ? cleanHtml(job['jobDescription'])
        : 'No description available';

    return Scaffold(
      appBar: AppBar(
        title: Text(job['jobTitle'] ?? 'Job Details'), // Display job title as the AppBar title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Job Title
            Text(
              job['jobTitle'] ?? 'No Title Available',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Company Name
            Text(
              'Company: ${job['companyName'] ?? 'No Company Information'}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),

            // Location
            Text(
              'Location: ${job['location'] ?? 'Remote'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Job Type
            Text(
              'Job Type: ${job['jobType'] ?? 'Not specified'}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Job Description Header
            const Text(
              'Job Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Job Description Content (Cleaned)
            Text(
              cleanDescription,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
