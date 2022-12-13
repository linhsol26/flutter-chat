import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:whatsapp_ui/core/presentation/theme/app_theme.dart';
import 'package:whatsapp_ui/firebase_options.dart';
import 'package:whatsapp_ui/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      restorationScopeId: 'app',
      onGenerateTitle: (BuildContext context) => 'Chat',
      themeMode: ref.watch(themeModeProvider),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: EasyLoading.init(),
    );
  }
}
