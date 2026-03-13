class AppConfig {
  static const String groqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue: '',
  );

  static const String appName = 'Abdul AI';
  static const String appVersion = '3.0.0';
  static const String appDescription = 'Personal JARVIS AI Assistant with Real-time Caller ID';

  static const String groqModel = 'mixtral-8x7b-32768';
  static const double groqTemperature = 0.7;
  static const int groqMaxTokens = 150;

  static const int overlayHeight = 200;
  static const int overlayWidth = -1;

  static const String phoneChannelName = 'com.halalbillionaires.abdulai/phone';

  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'ar': 'Arabic',
    'ur': 'Urdu',
  };

  static const List<String> quickPrompts = [
    'Who is calling?',
    'Is this spam?',
    'Tell me about this number',
    'Should I answer?',
  ];

  static bool get isGroqConfigured => groqApiKey.isNotEmpty;

  static String getSystemPrompt() {
    return '''You are Abdul, a helpful AI assistant integrated into a mobile app.
Your role is to provide concise, accurate information about phone calls and general queries.
Keep your responses brief and to the point. If asked about a phone number, provide any
known information about spam, scams, or legitimate business numbers.''';
  }

  static Map<String, String> getGroqHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $groqApiKey',
    };
  }

  static Map<String, dynamic> buildGroqRequest(String prompt) {
    return {
      'model': groqModel,
      'messages': [
        {'role': 'system', 'content': getSystemPrompt()},
        {'role': 'user', 'content': prompt}
      ],
      'temperature': groqTemperature,
      'max_tokens': groqMaxTokens,
    };
  }

  static const String privacyPolicyUrl = 'https://halalbillionaires.com/privacy';
  static const String termsOfServiceUrl = 'https://halalbillionaires.com/terms';
  static const String supportEmail = 'support@halalbillionaires.com';

  static const Duration callCheckInterval = Duration(seconds: 1);
  static const Duration overlayDismissDelay = Duration(seconds: 10);

  static const int maxChatHistory = 50;
  static const int maxOverlayTextLength = 200;

  static String formatPhoneNumber(String number) {
    if (number.length == 10) {
      return '(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}';
    }
    return number;
  }

  static bool isValidPhoneNumber(String number) {
    final cleaned = number.replaceAll(RegExp(r'\D'), '');
    return cleaned.length >= 10 && cleaned.length <= 15;
  }
}
