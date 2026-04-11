import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Initialize Supabase when backend is integrated
  runApp(
    const ProviderScope(
      child: TradeTrackrApp(),
    ),
  );
}
