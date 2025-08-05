import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:kanban_app/api/api_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../mock/mock_http_client.mocks.dart';

//create dummy secure storage (so test doesn't write to real storage)
class FakeStorage extends FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  }) async {
    _storage.remove(key);
  }
}

void main() {
  group('AuthService Login', () {
    late MockClient mockClient;
    late FakeStorage fakeStorage;
    late AuthService authService;

    setUp(() {
      mockClient = MockClient();
      fakeStorage = FakeStorage();
      //passing in the mock client to the AuthService class
      authService = AuthService(client: mockClient, storage: fakeStorage);
    });

    //testing if AuthService returns the correct responses depending on what it receives from the backend
    //with backend mocked
    test('fails with empty creddentials', () async {
      //arrange
      when(mockClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Unauthorized', 401));

      final result = await authService.login('', '');
      expect(result, false);
    });

    test('succeeds with correct credentials', () async {
      const fakeToken = 'fake.jwt.token';

      when(mockClient.post(any,
              headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer(
              (_) async => http.Response('{"token": "$fakeToken"}', 200));

      final result =
          await authService.login('emaileg@gmail.com', 'MySecret123!');

      expect(result, true);

      //check if the token is written to the fake storage
      final savedToken = await fakeStorage.read(key: 'auth_token');
      expect(savedToken, fakeToken);
    });
  });
}
