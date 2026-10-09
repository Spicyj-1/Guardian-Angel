// Guardian Angel — Phase 2 shell: Patient Home + History tab + 12s countdown.
// Offline, local-only. Detection engine plugs into ModelConfig in Phase 3.
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'model/config.dart';
import 'alert/engine.dart';
import 'alert/first_aid.dart';
import 'data/repository.dart';
import 'dashboard/trends.dart';
import 'caregiver/circle.dart';
import 'caregiver/voice.dart';
import 'auth/service.dart';
import 'auth/login_screen.dart';

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
  late final AlertEngine _alerts = AlertEngine(
    caregivers: [Caregiver(name: 'Mary (demo)', contact: '+2348000000000')],
    sender: LocalLogSender(),
  );
  final SeizureLog _seizureLog = InMemorySeizureLog();
  final MedsStore _meds = InMemoryMedsStore();
  final CaregiverCircle _circle = CaregiverCircle();
  final AuthService _auth = LocalAccountStub();
  final List<CheckinRecord> _checkins = [];
  final TextEditingController _inviteCtrl = TextEditingController();
  String? _inviteError;
  String? _fallback;

  void _log(String s) =>
      _events.add('${DateTime.now().toIso8601String()} — $s');

  void _simulate() {
    if (!monitoring) return;
    _alerts.start(probability: 0.9, locationNote: 'demo GPS');
    _seizureLog.add(SeizureEvent(
        at: DateTime.now(), durationSeconds: 42, severity: 'moderate'));
    setState(() {
      _log('simulated detection');
      _fallback = null;
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
        final outcome = await _alerts.escalateDue(locationNote: 'demo GPS');
        if (!mounted) return;
        setState(() {
          _log(outcome == AlertOutcome.fallbackShown
              ? 'caregivers exhausted → fallback'
              : 'escalated to caregiver (simulated)');
          if (outcome == AlertOutcome.fallbackShown) {
            _fallback = _alerts.fallbackText(country: 'Nigeria');
          }
        });
      }
    }
  }

  void _cancel() {
    _alerts.cancel();
    setState(() {
      _countdown = 0;
      _log('patient cancelled (okay)');
    });
  }

  void _ack() {
    _alerts.acknowledge('Mary (demo)');
    setState(() => _log('caregiver acknowledged'));
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(AppTheme.navy);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Angel'),
        backgroundColor: const Color(AppTheme.bg),
        foregroundColor: navy,
      ),
      body: _tab == 0
          ? _home(navy)
          : _tab == 1
              ? _history(navy)
              : _tab == 2
                  ? _care(navy)
                  : AccountScreen(auth: _auth),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: 'Care'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Account'),
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
        Row(children: [
          ElevatedButton(onPressed: _ack, child: const Text('Acknowledge')),
        ]),
        if (_fallback != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(_fallback!),
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('First aid (with every alert)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                for (final s in firstAidSteps) Text('• $s'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _trendsCard(navy),
        _medsCard(),
        const SizedBox(height: 8),
        const Text('Local notifications for meds arrive with the mobile build (Phase 5).'),
      ],
    );
  }

  Widget _trendsCard(Color navy) {
    final counts = weeklyCounts(_seizureLog.recent(limit: 200));
    final streak = adherenceStreak(_meds);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seizure frequency — 12 weeks',
                style: TextStyle(color: navy, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 140,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    for (int i = 0; i < counts.length; i++)
                      BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: counts[i].toDouble(),
                          color: i == 5
                              ? const Color(AppTheme.blue)
                              : const Color(AppTheme.teal),
                          width: 10,
                          borderRadius: BorderRadius.zero,
                        ),
                      ]),
                  ],
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            Text(trendInsight(counts),
                style: const TextStyle(color: Colors.black54)),
            Text('Adherence streak: $streak day(s) 🔥',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _medsCard() {
    final doses = _meds.today();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Medication — today',
                style: TextStyle(fontWeight: FontWeight.bold)),
            for (final d in doses)
              Row(children: [
                Expanded(
                    child: Text(
                        '${d.name} ${d.dose} — ${d.dueAt.hour}:00 ${d.taken ? '✓' : ''}')),
                TextButton(
                  onPressed: d.taken
                      ? null
                      : () => setState(() => _meds.markTaken(d.name, d.dueAt)),
                  child: const Text('Mark taken'),
                ),
              ]),
          ],
        ),
      ),
    );
  }

  void _acceptInvite() {
    final p = _circle.acceptInvite(_inviteCtrl.text, 'Demo Patient');
    setState(() {
      _inviteError =
          p == null ? 'Code format is XXXX-XXXX (e.g. AB12-CD34).' : null;
      if (p != null) _inviteCtrl.clear();
    });
  }

  void _checkin(CheckinResponse r, String caller) {
    final rec = CheckinRecord(at: DateTime.now(), response: r, callerType: caller);
    setState(() => _checkins.insert(0, rec));
    if (rec.alertsCaregivers) {
      setState(() => _log('voice check-in HELP by $caller → caregivers alerted'));
    }
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

  Widget _care(Color navy) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Caregivers', style: TextStyle(fontSize: 20, color: navy)),
        if (_circle.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                  'No patients yet. You see nothing until a patient adds you — enter the invite code they shared.'),
            ),
          )
        else
          for (final p in _circle.patients)
            Card(
              child: ListTile(
                title: Text(p.name),
                subtitle: Text(
                    'Invite ${p.inviteCode} • avg ack ${p.avgAckSeconds.toStringAsFixed(0)}s'),
              ),
            ),
        TextField(
          controller: _inviteCtrl,
          decoration: InputDecoration(
            labelText: 'Invite code (XXXX-XXXX)',
            errorText: _inviteError,
          ),
        ),
        ElevatedButton(
            onPressed: _acceptInvite, child: const Text('Accept invite')),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Voice check-in (no smartphone needed)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Call ${IvrScript.checkinNumber}\n'
                    '1 → patient / 2 → caregiver, then 1 = fine, 2 = help.'),
              ],
            ),
          ),
        ),
        Wrap(spacing: 8, children: [
          ElevatedButton(
              onPressed: () => _checkin(CheckinResponse.fine, 'patient'),
              child: const Text('Patient: fine')),
          ElevatedButton(
              onPressed: () => _checkin(CheckinResponse.help, 'patient'),
              child: const Text('Patient: help')),
          ElevatedButton(
              onPressed: () => _checkin(CheckinResponse.fine, 'caregiver'),
              child: const Text('Caregiver: fine')),
        ]),
        for (final c in _checkins)
          Card(
            child: ListTile(
              title: Text(
                  '${c.callerType}: ${c.response.name} → risk ${c.impliedRisk}'),
              subtitle: Text(c.at.toIso8601String()),
            ),
          ),
      ],
    );
  }
}
