import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../models/admin.dart';
import '../../repositories/admin_repository.dart';

class KelolaGuruScreen extends StatefulWidget {
  const KelolaGuruScreen({super.key});

  @override
  State<KelolaGuruScreen> createState() => _KelolaGuruScreenState();
}

class _KelolaGuruScreenState extends State<KelolaGuruScreen> {
  final _adminRepo = AdminRepository();
  List<Admin> _guruList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGuru();
  }

  Future<void> _loadGuru() async {
    setState(() => _isLoading = true);
    final list = await _adminRepo.getAllGuru();
    setState(() {
      _guruList = list;
      _isLoading = false;
    });
  }

  void _tampilDialogForm([Admin? guru]) {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController(text: guru?.username ?? '');
    final passwordController = TextEditingController(text: guru?.passwordHash ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(guru == null ? 'Tambah Akun Guru' : 'Edit Akun Guru'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final bytes = utf8.encode(passwordController.text.trim());
                  final hash = sha256.convert(bytes).toString();
                  final newGuru = Admin(
                    idAdmin: guru?.idAdmin,
                    username: usernameController.text.trim(),
                    passwordHash: hash,
                    role: 'guru',
                  );

                  if (guru == null) {
                    await _adminRepo.insertAdmin(newGuru);
                  } else {
                    await _adminRepo.updateAdmin(newGuru);
                  }
                  
                  if (mounted) {
                    Navigator.pop(context);
                    _loadGuru();
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _hapusGuru(Admin guru) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: Text('Apakah Anda yakin ingin menghapus akun guru "${guru.username}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && guru.idAdmin != null) {
      await _adminRepo.deleteAdmin(guru.idAdmin!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun guru berhasil dihapus')),
        );
        _loadGuru();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Akun Guru'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _tampilDialogForm(),
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _guruList.isEmpty
              ? const Center(child: Text('Belum ada akun guru. Silakan tambah baru.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _guruList.length,
                  itemBuilder: (context, index) {
                    final guru = _guruList[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(guru.username),
                        subtitle: const Text('Role: Guru'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _tampilDialogForm(guru),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _hapusGuru(guru),
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
