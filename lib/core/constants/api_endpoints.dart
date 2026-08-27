class ApiEndpoints {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';

  // Student Endpoints
  static const String studentSkills = '/students/me/skills';
  static const String studentTargets = '/students/me/targets';

  // Diagnostic Endpoints
  static const String diagnostics = '/diagnostics';
}