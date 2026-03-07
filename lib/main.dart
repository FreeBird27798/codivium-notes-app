import 'package:flutter/material.dart';
import 'package:codivium_notes_app/app.dart';
import 'package:codivium_notes_app/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const App());
}
