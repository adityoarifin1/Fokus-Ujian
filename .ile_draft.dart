import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const FokusUjianApp());
}

class FokusUjianApp extends StatelessWidget {
  const FokusUjianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fokus Ujian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class Question {
  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });

  final int id;
  final String text;
  final List<String> options;
  final String correctAnswer;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'guru');
  final _passwordController = TextEditingController(text: 'admin123');
  String _error = '';

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == 'guru' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      setState(() {
        _error = 'Username atau password salah. Gunakan akun demo guru/admin123';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fokus Ujian',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Login Pengawas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      key: const ValueKey('username'),
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const ValueKey('password'),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    if (_error.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Masuk'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Demo login: guru / admin123',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Question> _questions = [
    Question(
      id: 1,
      text: 'Sistem yang mengunci layar agar siswa tidak membuka aplikasi lain disebut?',
      options: ['Kiosk Mode', 'Dark Mode', 'Night Mode', 'Preview Mode'],
      correctAnswer: 'Kiosk Mode',
    ),
    Question(
      id: 2,
      text: 'Apa fungsi utama deteksi sentuhan tepi pada aplikasi ujian?',
      options: ['Mempercepat loading', 'Menghindari kecurangan', 'Menyimpan data login', 'Menambah audio'],
      correctAnswer: 'Menghindari kecurangan',
    ),
    Question(
      id: 3,
      text: 'Jika siswa menyentuh area terlarang, apa yang terjadi?',
      options: ['Aplikasi menutup', 'Alarm berbunyi dan volume naik', 'Halaman otomatis ganti', 'Data soal terhapus'],
      correctAnswer: 'Alarm berbunyi dan volume naik',
    ),
  ];

  final TextEditingController _questionTextController = TextEditingController();
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();
  final TextEditingController _optionDController = TextEditingController();

  void _addQuestion() {
    final text = _questionTextController.text.trim();
    final a = _optionAController.text.trim();
    final b = _optionBController.text.trim();
    final c = _optionCController.text.trim();
    final d = _optionDController.text.trim();

    if ([text, a, b, c, d].any((value) => value.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field soal harus diisi.')),
      );
      return;
    }

    setState(() {
      _questions.add(
        Question(
          id: _questions.length + 1,
          text: text,
          options: [a, b, c, d],
          correctAnswer: a,
        ),
      );
    });

    _questionTextController.clear();
    _optionAController.clear();
    _optionBController.clear();
    _optionCController.clear();
    _optionDController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Soal baru berhasil ditambahkan.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Guru'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;

          return Row(
            children: [
              if (isWide)
                Expanded(
                  flex: 2,
                  child: _QuestionEditor(
                    questionTextController: _questionTextController,
                    optionAController: _optionAController,
                    optionBController: _optionBController,
                    optionCController: _optionCController,
                    optionDController: _optionDController,
                    onAddQuestion: _addQuestion,
                  ),
                ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bank Soal',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text('Kelola daftar soal ujian dan mulai sesi ujian.'),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            final question = _questions[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(question.text),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: question.options
                                        .map((option) => Text('• $option'))
                                        .toList(),
                                  ),
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ExamScreen(questions: _questions),
                                      ),
                                    );
                                  },
                                  child: const Text('Mulai Ujian'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isWide)
                SizedBox(
                  width: double.infinity,
                  child: _QuestionEditor(
                    questionTextController: _questionTextController,
                    optionAController: _optionAController,
                    optionBController: _optionBController,
                    optionCController: _optionCController,
                    optionDController: _optionDController,
                    onAddQuestion: _addQuestion,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _QuestionEditor extends StatelessWidget {
  const _QuestionEditor({
    required this.questionTextController,
    required this.optionAController,
    required this.optionBController,
    required this.optionCController,
    required this.optionDController,
    required this.onAddQuestion,
  });

  final TextEditingController questionTextController;
  final TextEditingController optionAController;
  final TextEditingController optionBController;
  final TextEditingController optionCController;
  final TextEditingController optionDController;
  final VoidCallback onAddQuestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tambah Soal Baru', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: questionTextController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Pertanyaan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            _buildOptionField('A', optionAController),
            const SizedBox(height: 8),
            _buildOptionField('B', optionBController),
            const SizedBox(height: 8),
            _buildOptionField('C', optionCController),
            const SizedBox(height: 8),
            _buildOptionField('D', optionDController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Simpan Soal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Opsi $label',
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key, required this.questions});

  final List<Question> questions;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int _currentIndex = 0;
  String? _selectedAnswer;
  bool _alarmTriggered = false;

  Question get currentQuestion => widget.questions[_currentIndex];

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _selectedAnswer = null;
      });
    }
  }

  void _triggerAlarm() {
    if (_alarmTriggered) return;
    setState(() {
      _alarmTriggered = true;
    });
    SystemSound.play(SystemSoundType.alert);
  }

  void _resetAlarm() {
    setState(() {
      _alarmTriggered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode Ujian Aman'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final safePadding = 30.0;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              final x = details.localPosition.dx;
              final y = details.localPosition.dy;
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final hitEdge = x <= safePadding || x >= width - safePadding || y <= safePadding || y >= height - safePadding;

              if (hitEdge) {
                _triggerAlarm();
              }
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    left: safePadding,
                    top: safePadding,
                    right: safePadding,
                    bottom: safePadding,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green.shade300, width: 2),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.green.shade50,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Soal ${_currentIndex + 1}/${widget.questions.length}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            currentQuestion.text,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          ...currentQuestion.options.map((option) {
                            final selected = _selectedAnswer == option;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: RadioListTile<String>(
                                title: Text(option),
                                value: option,
                                groupValue: _selectedAnswer,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAnswer = value;
                                  });
                                },
                                tileColor: selected ? Colors.green.shade100 : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _currentIndex > 0 ? _previousQuestion : null,
                                icon: const Icon(Icons.arrow_back),
                                label: const Text('Sebelumnya'),
                              ),
                              ElevatedButton.icon(
                                onPressed: _currentIndex < widget.questions.length - 1 ? _nextQuestion : null,
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Berikutnya'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_alarmTriggered)
                    Positioned.fill(
                      child: Container(
                        color: Colors.red.withOpacity(0.85),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.warning_amber_rounded, size: 70, color: Colors.white),
                                const SizedBox(height: 16),
                                const Text(
                                  'Pelanggaran terdeteksi!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Sentuhan di area tepi layar dimonitor.\nVolume dinaikkan ke 100% dan alarm aktif.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _resetAlarm,
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                  child: const Text(
                                    'Kembali Fokus',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
