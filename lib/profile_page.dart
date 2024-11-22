import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'Adin Danahiswara';
  String email = 'adindanahiswara@gmail.com';

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Memuat data saat halaman dibuka
  }

  // Fungsi untuk memuat data profil dari SharedPreferences
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? name;
      email = prefs.getString('email') ?? email;
    });
  }

  // Fungsi untuk menyimpan data profil ke SharedPreferences
  Future<void> _saveProfileData(String updatedName, String updatedEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', updatedName);
    await prefs.setString('email', updatedEmail);
  }

  // Fungsi untuk membuka dialog edit profil
  Future<void> _editProfileDialog() async {
    final nameController = TextEditingController(text: name);
    final emailController = TextEditingController(text: email);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Field untuk Nama
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              // Field untuk Email
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Tutup dialog tanpa menyimpan
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'name': nameController.text.trim(),
                'email': emailController.text.trim(),
              }); // Kembalikan hasil edit
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    // Perbarui data profil jika ada hasil
    if (result != null && result['name'] != null && result['email'] != null) {
      setState(() {
        name = result['name']!;
        email = result['email']!;
      });

      // Simpan data ke SharedPreferences
      await _saveProfileData(name, email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar Profil
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/assets/th.png'),
            ),
            const SizedBox(height: 10),

            // Nama Profil
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            // Email Profil
            Text(
              email,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Tombol Edit Profil
            ElevatedButton(
              onPressed: _editProfileDialog, // Panggil dialog edit
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
