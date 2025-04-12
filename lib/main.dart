import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard/home_page.dart';
import 'blocs/polled_analytics_bloc.dart';
import 'blocs/realtime_analytics_bloc.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MainApp());
    },
    (Object error, StackTrace stack) {
      log("Error Type >>  ${error.runtimeType}", error: error, stackTrace: stack, name: '[zoned error with stack trace]');
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PolledAnalyticsBloc()),
        BlocProvider(create: (context) => RealtimeAnalyticsBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData.light(),
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: "Analytics Dashboard",
        home: AnalyticsDashboard(),
      ),
    );
  }
}
