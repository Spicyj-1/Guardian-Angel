// Guardian Angel — login / sign-up screens (backend phase).
// Works fully against LocalAccountStub today; identical UI drives
// FirebaseAccountService once configured. No design promises beyond
// the clinical v2 theme.
import 'package:flutter/material.dart';
import 'service.dart';

class AccountScreen extends StatefulWidget {
  final AuthService auth;
  const AccountScreen({super.key, required this.auth});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _signup = false;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  AccountRole _role = AccountRole.patient;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    setState(() => _error = null);
    try {
      if (_signup) {
        await widget.auth.signUp(
          email: _email.text.trim(),
          password: _pass.text,
          name: _name.text.trim(),
          role: _role,
        );
      } else {
        await widget.auth
            .signIn(email: _email.text.trim(), password: _pass.text);
      }
      if (mounted) setState(() {});
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Could not reach auth backend ($e).');
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = widget.auth.current;
    if (me != null) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Card(
            child: ListTile(
              title: Text(me.name),
              subtitle: Text('${me.email} • ${me.role.name}'),
            ),
          ),
          const Text(
              'Local session (backend pending). Cloud sign-in activates with Firebase config.',
              style: TextStyle(color: Colors.black54)),
          ElevatedButton(
            onPressed: () async {
              await widget.auth.signOut();
              if (mounted) setState(() {});
            },
            child: const Text('Sign out'),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(_signup ? 'Create account' : 'Welcome back',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        if (_signup)
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full name')),
        TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email')),
        TextField(
            controller: _pass,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password (min 6)')),
        if (_signup)
          DropdownButton<AccountRole>(
            value: _role,
            items: const [
              DropdownMenuItem(
                  value: AccountRole.patient, child: Text('Patient')),
              DropdownMenuItem(
                  value: AccountRole.caregiver, child: Text('Caregiver')),
            ],
            onChanged: (v) => setState(() => _role = v ?? _role),
          ),
        if (_error != null)
          Text(_error!, style: const TextStyle(color: Colors.red)),
        ElevatedButton(
            onPressed: _go, child: Text(_signup ? 'Sign up' : 'Sign in')),
        TextButton(
          onPressed: () => setState(() => _signup = !_signup),
          child: Text(_signup
              ? 'Have an account? Sign in'
              : 'New here? Create account'),
        ),
      ],
    );
  }
}
