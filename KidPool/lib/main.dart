import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/providers/app_version_provider.dart';

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
      ],
      child: MaterialApp(
        title: 'Clean Architecture Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const AppVersionScreen(),
      ),
    );
  }
}

class AppVersionScreen extends StatelessWidget {
  const AppVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Version Info')),
      body: Center(
        child: Consumer<AppVersionProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const CircularProgressIndicator();
            }

            if (provider.errorMessage != null) {
              return Text('Error: ${provider.errorMessage}');
            }

            if (provider.appVersion != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Version: ${provider.appVersion!.version}'),
                  Text('Base URL: ${provider.appVersion!.apiBaseUrl}'),
                  Text('Status: ${provider.appVersion!.status}'),
                ],
              );
            }

            return ElevatedButton(
              onPressed: () {
                provider.fetchAppVersion(
                  roleId: 1,
                  device: 'ios',
                  versionNumber: '2.0',
                );
              },
              child: const Text('Fetch App Version'),
            );
          },
        ),
      ),
    );
  }
}
