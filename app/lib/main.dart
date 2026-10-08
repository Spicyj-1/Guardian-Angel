// Guardian Angel — Phase 2 shell: Patient Home + History tab + 12s countdown.
// Offline, local-only. Detection engine plugs into ModelConfig in Phase 3.
import 'package:flutter/material.dart';
import 'model/config.dart';

void main() => runApp(const GuardianAngelApp());

class GuardianAngelApp extends StatelessWidget {
  const GuardianAngelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian Angel',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(AppTheme.bg),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(AppTheme.teal)),
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  bool monitoring = true;
  final List<String> _events = []; // Drift-backed in full Phase 2; in-memory for shell.
  int _countdown = 0;

  void _simulate() {
    if (!monitoring) return;
    setState(() {
      _events.add('${DateTime.now().toIso8601String()} — simulated detection');
      _countdown = ModelConfig.cancelCountdownSeconds;
    });
    _tick();
  }

  void _tick() async {
    while (_countdown > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _countdown--);
      if (_countdown == 0) {
        setState(() => _events.add(
            '${DateTime.now().toIso8601String()} — escalated to caregiver (simulated)'));
      }
    }
  }

  void _cancel() => setState(() {
        _countdown = 0;
        _events.add('${DateTime.now().toIso8601String()} — patient cancelled (okay)');
      });

  @override
  Widget build(BuildContext context) {
    const navy = Color(AppTheme.navy);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Angel'),
        backgroundColor: const Color(AppTheme.bg),
        foregroundColor: navy,
      ),
      body: _tab == 0 ? _home(navy) : _history(navy),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }

  Widget _home(Color navy) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [
          Icon(monitoring ? Icons.shield : Icons.shield_outlined,
              color: const Color(AppTheme.teal)),
          const SizedBox(width: 8),
          Text(monitoring ? 'Monitoring ON — on-device' : 'Monitoring OFF',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 8),
        Text(
          _events.isEmpty
              ? 'No events yet.'
              : 'Last: ${_events.last} (${_events.length} total)',
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 12),
        if (_countdown > 0)
          Card(
            color: const Color(0xFFFBEAE5),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                const Text('Possible seizure — are you okay?',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('$_countdown',
                    style: TextStyle(fontSize: 44, color: navy)),
                ElevatedButton(
                    onPressed: _cancel,
                    child: const Text("I'm Okay — Cancel")),
              ]),
            ),
          ),
        Row(children: [
          ElevatedButton(
              onPressed: () => setState(() => monitoring = !monitoring),
              child: const Text('Toggle monitoring')),
          const SizedBox(width: 8),
          ElevatedButton(
              onPressed: _simulate,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(AppTheme.critical)),
              child: const Text('Simulate seizure',
                  style: TextStyle(color: Colors.white))),
        ]),
        const SizedBox(height: 8),
        const Text('Trends + adherence arrive with fl_chart (Phase 5).'),
      ],
    );
  }

  Widget _history(Color navy) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('History', style: TextStyle(fontSize: 20, color: navy)),
        if (_events.isEmpty) const Text('Nothing logged yet.'),
        for (final e in _events.reversed)
          Card(child: ListTile(title: Text(e))),
      ],
    );
  }
}
