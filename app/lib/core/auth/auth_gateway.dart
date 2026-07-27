import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthSession {
  const AuthSession({
    required this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;
}

abstract interface class AuthGateway {
  bool get configured;
  Stream<AuthSession?> authStateChanges();
  Future<AuthSession> signInWithGoogle();
  Future<AuthSession> signInWithApple();
  Future<void> signOut();
}

class FirebaseAuthGateway implements AuthGateway {
  FirebaseAuthGateway({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  Future<void>? _googleInitialization;

  @override
  bool get configured => true;

  @override
  Stream<AuthSession?> authStateChanges() =>
      _auth.authStateChanges().map(_session);

  @override
  Future<AuthSession> signInWithGoogle() async {
    const serverClientId = String.fromEnvironment(
      'ETER_GOOGLE_SERVER_CLIENT_ID',
      defaultValue: '',
    );
    _googleInitialization ??= _googleSignIn.initialize(
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
    await _googleInitialization;
    final googleUser = await _googleSignIn.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    return _requiredSession(result.user);
  }

  @override
  Future<AuthSession> signInWithApple() async {
    final result = await _auth.signInWithProvider(AppleAuthProvider());
    return _requiredSession(result.user);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  static AuthSession? _session(User? user) => user == null
      ? null
      : AuthSession(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
        );

  static AuthSession _requiredSession(User? user) {
    final session = _session(user);
    if (session == null) throw StateError('Provider returned no Firebase user');
    return session;
  }
}

class UnconfiguredAuthGateway implements AuthGateway {
  const UnconfiguredAuthGateway();

  @override
  bool get configured => false;

  @override
  Stream<AuthSession?> authStateChanges() => const Stream.empty();

  @override
  Future<AuthSession> signInWithApple() =>
      throw StateError('Firebase is not configured');

  @override
  Future<AuthSession> signInWithGoogle() =>
      throw StateError('Firebase is not configured');

  @override
  Future<void> signOut() async {}
}
