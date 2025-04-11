import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/network/http_client.dart';
import 'core/network/ws_client.dart';
import 'dashboard/home_page.dart';
import 'data/repository/analytics_repository.dart';
import 'logic/bloc/polled_analytics_bloc.dart';
import 'logic/bloc/realtime_analytics_bloc.dart';
import 'logic/bloc/unified_analytics_stream_bloc.dart';

void main() {
  initializeDateFormatting();
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
    // Dependency instances
    final wsClient = WsClientService();
    final httpClient = HttpClientService();
    final analyticsRepository = AnalyticsRepository(httpClient, wsClient);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: wsClient),
        RepositoryProvider.value(value: httpClient),
        RepositoryProvider.value(value: analyticsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PolledAnalyticsBloc(analyticsRepository)),
          BlocProvider(create: (context) => UnifiedAnalyticsBloc(analyticsRepository)),
          BlocProvider(create: (context) => RealtimeAnalyticsBloc(analyticsRepository)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Real-Time Analytics Dashboard",
          themeMode: ThemeMode.dark,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: Dashboard(),
        ),
      ),
    );
  }
}
