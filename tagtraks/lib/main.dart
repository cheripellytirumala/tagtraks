import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart' as di;
import 'presentation/pages/login_page.dart';
import 'presentation/providers/add_asset_provider.dart';
import 'presentation/providers/app_version_provider.dart';
import 'presentation/providers/asset_list_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/bulk_upload_provider.dart';
import 'presentation/providers/dashboard_provider.dart';
import 'presentation/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AppVersionProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<DashboardProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AssetListProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AddAssetProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<BulkUploadProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProfileProvider>()),
      ],
      child: MaterialApp(
        title: 'TagTraks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily:
              'Roboto', // Defaulting to Roboto as no specific font was found in pubspec
        ),
        home: const LoginPage(),
      ),
    );
  }
}
