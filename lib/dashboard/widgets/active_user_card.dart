import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/unified_analytics_stream_bloc.dart';

class ActiveUsersCard extends StatelessWidget {
  const ActiveUsersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Users',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                BlocBuilder<UnifiedAnalyticsBloc, UnifiedAnalyticsState>(
                  builder: (context, uas) {
                    return Text(
                      "${uas is UnifiedAnalyticsSuccess ? uas.activeUsers : '...'}",
                      style: TextStyle(
                        fontSize: constraints.maxWidth < 300 ? 24 : 32,
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
