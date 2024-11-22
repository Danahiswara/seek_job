import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';

class FeedDetailPage extends StatelessWidget {
  final RssItem feed;

  const FeedDetailPage({super.key, required this.feed});

  // Fungsi untuk membersihkan HTML
  String cleanHtml(String htmlContent) {
    return htmlContent
        .replaceAll(RegExp(r'<div[^>]*>'), '') // Hapus <div> pembuka
        .replaceAll(RegExp(r'</div>'), '')    // Hapus </div> penutup
        .replaceAll(RegExp(r'<br\s?/?>'), '\n') // Ganti <br> dengan newline
        .replaceAll(RegExp(r'<[^>]+>'), '')   // Hapus semua tag HTML lainnya
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil konten dan gambar
    final String? encodedContent = feed.content?.value;
    final String cleanedContent = encodedContent != null ? cleanHtml(encodedContent) : '';
    final String? imageUrl = feed.media?.contents?.firstWhere(
      (media) => media.medium == "image",
    ).url;

    return Scaffold(
      appBar: AppBar(title: Text(feed.title ?? 'Feed Details')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title - Centered
              Center(
                child: Text(
                  feed.title ?? 'No title',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              // Publication date
              Text(
                'Published on: ${feed.pubDate?.toLocal().toString() ?? 'No date'}',
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),

              // Feed Image - Centered
              if (imageUrl != null)
                Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Image failed to load');
                    },
                  ),
                ),
              const SizedBox(height: 10),

              // Rendered or Cleaned Content
              if (encodedContent != null && encodedContent.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    cleanedContent,
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'No content available.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
