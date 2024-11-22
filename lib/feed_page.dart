import 'package:flutter/material.dart';
import 'package:seek_job/api_service.dart';
import 'feed_detail_page.dart';
import 'package:webfeed/webfeed.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ApiService apiService = ApiService();
  List<RssItem> feeds = [];
  bool isLoading = false; // To indicate if new data is loading
  int currentPage = 1; // Current page for pagination
  final int pageSize = 10; // Number of items per page

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchFeeds();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchFeeds() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final newFeeds = await apiService.fetchJobFeeds(
      page: currentPage,
      limit: pageSize,
    );
    print('Fetched Feeds: ${newFeeds.length}');

    setState(() {
      feeds.addAll(newFeeds);
      isLoading = false;
      if (newFeeds.isNotEmpty) {
        currentPage++;
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      fetchFeeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Feed')),
      body: feeds.isEmpty && isLoading
          ? const Center(child: CircularProgressIndicator())
          : feeds.isEmpty
              ? const Center(
                  child: Text("No job feeds available."),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: feeds.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < feeds.length) {
                      final feed = feeds[index];
                      final imageUrl = feed.media?.contents?.firstWhere(
                            (media) => media.medium == "image",
                          ).url;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedDetailPage(feed: feed),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gambar Feed
                                if (imageUrl != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.broken_image,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 12),

                                // Informasi Feed
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Judul Feed
                                      Text(
                                        feed.title ?? 'No title',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),

                                      // Deskripsi Feed
                                      Text(
                                        feed.description ?? 'No description available.',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),

                                      // Tanggal Publikasi
                                      Text(
                                        feed.pubDate?.toLocal().toString() ??
                                            'No date',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
    );
  }
}
