import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  AuthService(this._api);

  final ApiClient _api;

  Future<({String userId, String message})> requestOtp(String phoneE164) async {
    final data = await _api.post('/auth/request-otp', {'phone': phoneE164});
    return (
      userId: data['user_id'] as String,
      message: data['message'] as String? ?? 'OTP envoyé',
    );
  }

  Future<({String token, User user, bool isNewUser})> verifyOtp({
    required String userId,
    required String code,
  }) async {
    final data = await _api.post('/auth/verify-otp', {
      'user_id': userId,
      'code': code,
    });
    final token = data['token'] as String;
    final userMap = data['user'] as Map<String, dynamic>?;
    final user = userMap != null ? User.fromJson(userMap) : User(id: userId);
    final isNew = data['is_new_user'] as bool? ?? false;
    return (token: token, user: user, isNewUser: isNew);
  }

  Future<User> fetchMe() async {
    final data = await _api.get('/auth/me', auth: true);
    final userMap = data['user'] as Map<String, dynamic>? ?? data;
    return User.fromJson(userMap);
  }

  Future<User> updateFullName(String fullName) async {
    final data = await _api.patch('/auth/me', {'full_name': fullName}, auth: true);
    final userMap = data['user'] as Map<String, dynamic>? ?? data;
    return User.fromJson(userMap);
  }
}
