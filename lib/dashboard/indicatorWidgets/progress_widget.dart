import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 80),
          Text(
            "Loading...\nSince the backend is deployed on a free version of render.com, it may take a while to load if the app is idle for a long time.\nJust for the first run by you, please bear until data loads",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
