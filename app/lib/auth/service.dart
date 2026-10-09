// Guardian Angel — auth layer (backend phase, Firebase approved).
// Pattern mirrors the rest of the app: interface now, real provider behind
// it. LocalAccountStub runs the UI end-to-end with zero backend;
// FirebaseAccountService takes over once google-services config exists
// (local files only — google-services.json IS gitignored, never committed).

enum AccountRole { patient, caregiver }

class Account {
  final String uid;
  final String email;
  final String name;
  final AccountRole role;
  Account({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });
}

abstract class AuthService {
  Future<Account> signUp({
    required String email,
    required String password,
    required String name,
    required AccountRole role,
  });
  Future<Account> signIn({required String email, required String password});
  Future<void> signOut();
  Account? get current;
}

/// Temporary local session. Data stays on-device; replaced by Firebase
/// once the backend phase provisions config. Clearly marked, not silent.
class LocalAccountStub implements AuthService {
  Account? _current;
  final Map<String, Account> _users = {};
  @override
  Account? get current => _current;

  @override
  Future<Account> signUp({
    required String email,
    required String password,
    required String name,
    required AccountRole role,
  }) async {
    if (password.length < 6) throw AuthException('Password too short (min 6).');
    if (_users.containsKey(email)) throw AuthException('Account exists — sign in.');
    final a = Account(
        uid: 'local-${_users.length + 1}',
        email: email,
        name: name,
        role: role);
    _users[email] = a;
    _current = a;
    return a;
  }

  @override
  Future<Account> signIn(
      {required String email, required String password}) async {
    final a = _users[email];
    if (a == null) {
      throw AuthException('No local account — sign up first (backend pending).');
    }
    _current = a;
    return a;
  }

  @override
  Future<void> signOut() async => _current = null;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
