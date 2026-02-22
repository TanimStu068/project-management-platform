import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_forge/core/app_providers.dart';
import 'package:task_forge/myapp.dart';

void main() {
  runApp(
    MultiProvider(providers: AppProviders.providers, child: const Myapp()),
  );
}
