// Guardian Angel — Firebase wiring (backend phase).
// Construct ONLY after Firebase.initializeApp(options: ...) with the
// founder's project config. Config files stay on-device:
//   android/app/google-services.json, ios/.../GoogleService-Info.plist,
//   lib/firebase_options.dart (flutterfire configure)
// All three are gitignored. No keys in source, ever.
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'service.dart';

class FirebaseAccountService implements AuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  Account? _current;

  static AccountRole _roleOf(String? claim) =>
      claim == 'caregiver' ? AccountRole.caregiver : AccountRole.patient;

  Account _wrap(fb.User u, AccountRole role, String name) => Account(
      uid: u.uid,
      email: u.email ?? '',
      name: name.isEmpty ? (u.email ?? 'User') : name,
      role: role);

  @override
  Account? get current => _current;

  @override
  Future<Account> signUp({
    required String email,
    required String password,
    required String name,
    required AccountRole role,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final u = cred.user;
    if (u == null) throw AuthException('Sign-up failed.');
    await u.updateDisplayName(name);
    // Role travels as a custom claim set by a backend function (Phase 6+).
    // Until then, role is kept client-side for UI gating only.
    _current = _wrap(u, role, name);
    return _current!;
  }

  @override
  Future<Account> signIn(
      {required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final u = cred.user;
    if (u == null) throw AuthException('Sign-in failed.');
    final token = await u.getIdTokenResult();
    final role = _roleOf(token.claims?['role'] as String?);
    _current = _wrap(u, role, u.displayName ?? '');
    return _current!;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    _current = null;
  }
}
