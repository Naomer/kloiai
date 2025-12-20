import 'package:flutter/material.dart';

import '../../jobs/job_details_screen.dart';

/// Job Matches list (for now uses mock data; later will read from Firestore).
class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data to visualize the UX before wiring Firestore.
    final mockJobs = [
      _MockJob(
        title: 'Flutter App Bug Fixing',
        board: 'Upwork',
        budget: '\$600',
        score: 87,
        status: 'New',
      ),
      _MockJob(
        title: 'SaaS Dashboard Refactor',
        board: 'LinkedIn',
        budget: '\$2,000',
        score: 91,
        status: 'Applied',
      ),
      _MockJob(
        title: 'Mobile App Performance Tuning',
        board: 'Fiverr',
        budget: '\$450',
        score: 80,
        status: 'Client Interested',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Job Matches',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: mockJobs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final job = mockJobs[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(job.title),
                  subtitle: Text(
                    '${job.board} • ${job.budget}\n${job.status}',
                  ),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${job.score}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'match',
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      JobDetailsScreen.routeName,
                      arguments: {
                        'title': job.title,
                        'platform': job.board,
                        'budget': job.budget,
                        'match': job.score,
                        'status': job.status,
                        'description':
                            'Detailed description for ${job.title}. Later this will come from the backend.',
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MockJob {
  final String title;
  final String board;
  final String budget;
  final int score;
  final String status;

  const _MockJob({
    required this.title,
    required this.board,
    required this.budget,
    required this.score,
    required this.status,
  });
}


