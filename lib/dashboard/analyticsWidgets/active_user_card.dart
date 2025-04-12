import 'package:flutter/material.dart';

class ActiveUsersCard extends StatelessWidget {
  const ActiveUsersCard({super.key, required this.activeUsers});
  final int activeUsers;
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
                Text(
                  "$activeUsers",
                  style: TextStyle(
                    fontSize: constraints.maxWidth < 300 ? 24 : 32,
                    color: Colors.green,
                    fontWeight: FontWeight.w900,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
