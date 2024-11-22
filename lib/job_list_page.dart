import 'package:flutter/material.dart';
import 'package:seek_job/api_service.dart';
import 'job_detail_page.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  final ApiService apiService = ApiService();

  // Dropdown values for geo and industry
  String selectedGeo = "usa";
  String selectedIndustry = "engineering";

  // Sample options for geo and industry dropdowns
  final List<String> geoOptions = [
    "apac", "emea", "latam", "argentina", "singapore",
    "germany", "uk", "japan", "usa", "vietnam"
  ];
  final List<String> industryOptions = [
    "engineering", "marketing", "management", "dev", "finance"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find a Job"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Filter Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGeo,
                    onChanged: (value) {
                      setState(() {
                        selectedGeo = value!;
                      });
                    },
                    items: geoOptions.map((geo) {
                      return DropdownMenuItem(
                        value: geo,
                        child: Text(geo.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedIndustry,
                    onChanged: (value) {
                      setState(() {
                        selectedIndustry = value!;
                      });
                    },
                    items: industryOptions.map((industry) {
                      return DropdownMenuItem(
                        value: industry,
                        child: Text(
                          industry[0].toUpperCase() + industry.substring(1),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Refresh the job list with new filters
                  },
                  child: const Text("Filter"),
                ),
              ],
            ),
          ),

          // Job List
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: apiService.fetchJobs(
                count: 50,
                geo: selectedGeo,
                tag: "all",
                industry: selectedIndustry,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No jobs found'));
                } else {
                  final jobs = snapshot.data!;
                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      var job = jobs[index];
                      var companyLogoUrl = job['companyLogo'];

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
                                builder: (context) => JobDetailPage(job: job),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Company Logo
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: companyLogoUrl != null &&
                                          companyLogoUrl.isNotEmpty
                                      ? Image.network(
                                          companyLogoUrl,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.business,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                ),
                                const SizedBox(width: 16),

                                // Job Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Job Title
                                      Text(
                                        job['jobTitle'] ?? 'No title',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Company Name
                                      Text(
                                        job['companyName'] ?? 'No company',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      // Location (Optional)
                                      if (job['location'] != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            'Location: ${job['location']}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
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
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
