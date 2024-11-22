import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class ApiService {
  final String baseUrl = "https://jobicy.com/api/v2/remote-jobs";
  final String feedUrl = "https://jobicy.com/?feed=job_feed";

  // Fetch list of jobs with optional parameters
  Future<List<dynamic>> fetchJobs({
    int count = 50,
    String geo = "all",
    String industry = "all",
    String tag = "all",
  }) async {
    // Valid geo and industry values as per API documentation
    const validGeoValues = [
      'all', 'apac', 'emea', 'latam', 'argentina', 'singapore',
      'germany', 'uk', 'japan', 'usa', 'vietnam',
    ];
    const validIndustryValues = [
      'all', 'engineering', 'marketing', 'management', 'dev', 'finance',
    ];

    // Validate geo and industry parameters
    if (!validGeoValues.contains(geo)) {
      print("Invalid geo value '$geo', defaulting to 'all'");
      geo = 'all';
    }
    if (!validIndustryValues.contains(industry)) {
      print("Invalid industry value '$industry', defaulting to 'all'");
      industry = 'all';
    }

    try {
      // Construct the API URL
      final url = Uri.parse('$baseUrl?count=$count&geo=$geo&industry=$industry');
      print("Fetching jobs from: $url");

      // Make the API request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Number of jobs fetched: ${data['jobs']?.length ?? 0}");
        return data['jobs'] ?? [];
      } else {
        print("Failed to load jobs, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching jobs: $e");
      return [];
    }
  }

  // Fetch job details by job ID
  Future<Map<String, dynamic>> fetchJobDetails(String jobId) async {
    try {
      // Construct the API URL
      final url = Uri.parse('$baseUrl/$jobId');
      print("Fetching job details from: $url");

      // Make the API request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Job details fetched successfully.");
        return json.decode(response.body);
      } else {
        print("Failed to load job details, status code: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      print("Error fetching job details: $e");
      return {};
    }
  }

  // Fetch job feeds from the RSS feed with optional query parameters
  Future<List<RssItem>> fetchJobFeeds({
    String jobCategories = "all",
    String jobTypes = "all",
    String searchKeywords = "",
    String searchRegion = "all",
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // Construct the RSS feed URL with query parameters
      final url = Uri.parse(
        '$feedUrl&job_types=full-time',
      );
      print("Fetching feeds from: $url");

      // Make the RSS feed request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the RSS feed
        final rssFeed = RssFeed.parse(utf8.decode(response.bodyBytes));
        print("Number of feeds fetched: ${rssFeed.items?.length ?? 0}");
        return rssFeed.items ?? [];
      } else {
        print("Failed to load job feeds, status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching job feeds: $e");
      return [];
    }
  }
}
