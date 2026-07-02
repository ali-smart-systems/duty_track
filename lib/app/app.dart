import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class DutyTrackApp extends StatelessWidget {
  const DutyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DUTY TRACK',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      routerConfig: AppRouter.router,
    );
  }
}
