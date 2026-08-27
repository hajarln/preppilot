import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:preppilot_mobile/core/constants/api_endpoints.dart';
import 'package:preppilot_mobile/core/network/api_client.dart';
import 'package:preppilot_mobile/features/auth/domain/entities/user.dart';
import 'package:preppilot_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  static const _storageOptions = WebOptions(dbName: 'PrepPilotStorage');

  AuthRepositoryImpl(this._apiClient, this._storage);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final token = response.data['access_token'] as String;
      await _storage.write(
        key: 'jwt_token',
        value: token,
        webOptions: _storageOptions,
      );

      final userData = response.data['user'] as Map<String, dynamic>;
      return User.fromJson(userData);
    } on DioException catch (e) {
      final errorMessage = e.response?.data is Map && e.response?.data['detail'] != null
          ? e.response?.data['detail'].toString()
          : 'Échec de connexion';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<User> register(String fullName, String email, String password, String role) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.register,
        data: {
          'full_name': fullName,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      // Si le backend renvoie un token à l'inscription, on le stocke
      if (response.data['access_token'] != null) {
        await _storage.write(
          key: 'jwt_token',
          value: response.data['access_token'] as String,
          webOptions: _storageOptions,
        );
      }

      final userData = response.data['user'] as Map<String, dynamic>;
      return User.fromJson(userData);
    } on DioException catch (e) {
      final errorMessage = e.response?.data is Map && e.response?.data['detail'] != null
          ? e.response?.data['detail'].toString()
          : "Échec de l'inscription";
      throw Exception(errorMessage);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _storage.read(
      key: 'jwt_token',
      webOptions: _storageOptions,
    );
    if (token == null) return null;

    try {
      final response = await _apiClient.client.get(ApiEndpoints.me);
      // /auth/me renvoie directement le JSON de l'utilisateur
      final data = response.data as Map<String, dynamic>;
      final userData = data.containsKey('user') ? data['user'] as Map<String, dynamic> : data;
      return User.fromJson(userData);
    } on DioException {
      await logout();
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(
      key: 'jwt_token',
      webOptions: _storageOptions,
    );
  }
}