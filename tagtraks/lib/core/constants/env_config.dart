enum Environment { dev, staging, prod }

class AppConfig {
  static Environment environment = Environment.dev;

  static String get baseUrl {
    switch (environment) {
      case Environment.dev:
      case Environment.staging:
      case Environment.prod:
        return 'https://tagtraks.com/';
    }
  }

  static bool get isDevelopment => environment == Environment.dev;
}
