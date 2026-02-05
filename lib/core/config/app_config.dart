enum ApiEnvironment {
  emulator,
  localNetwork,
}

class AppConfig {
  const AppConfig._({
    required this.apiBaseUrl,
    required this.environment,
  });

  // INFO: Тут можно изменить на localNetworkBaseURL установив ApiEnvironment.localNetwork
  // INFO: Или на emulatorBaseURL установив ApiEnvironment.emulator
  static const ApiEnvironment currentEnvironment = ApiEnvironment.emulator;

  static const String emulatorBaseUrl = 'http://10.0.2.2:3000';
  static const String localNetworkBaseUrl = 'http://192.168.0.136:3000';

  final String apiBaseUrl;
  final ApiEnvironment environment;

  factory AppConfig.current() {
    switch (currentEnvironment) {
      case ApiEnvironment.emulator:
        return const AppConfig._(
          apiBaseUrl: emulatorBaseUrl,
          environment: ApiEnvironment.emulator,
        );
      case ApiEnvironment.localNetwork:
        return const AppConfig._(
          apiBaseUrl: localNetworkBaseUrl,
          environment: ApiEnvironment.localNetwork,
        );
    }
  }
}
