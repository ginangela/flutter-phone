import 'package:flutter/material.dart';
import '../models/contact_model.dart'; // Pastikan Anda mengimpor model Contact
import '../db/database_helper.dart';

class EditContactPage extends StatelessWidget {
  final Contact contact; // Ubah tipe dari Map<String, String> ke Contact
  const EditContactPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(
      text: contact.name,
    ); // Akses properti dari Contact
    final phoneController = TextEditingController(
      text: contact.phone,
    ); // Akses properti dari Contact
    final emailController = TextEditingController(
      text: contact.email,
    ); // Akses properti dari Contact

    String dropdownValue =
        contact.label ?? 'Personal'; // Akses label dari Contact

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        title: const Text('Edit Contact'),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                hintText: 'Phone',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: dropdownValue,
              icon: const Icon(Icons.expand_more),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.label),
                labelText: 'Labels',
              ),
              items:
                  <String>['Personal', 'Work'].map((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
              onChanged: (String? newValue) {
                dropdownValue = newValue!;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final updatedContact = Contact(
                      id: contact.id,
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text,
                      label: dropdownValue,
                    );

                    // Simpan ke database
                    await DatabaseHelper().updateContact(updatedContact);

                    // Kembali ke halaman sebelumnya
                    Navigator.pop(
                      context,
                      true,
                    ); // bisa kirim tanda bahwa data telah diedit
                  },
                  child: const Text('Save'),
                ),

                OutlinedButton(
                  onPressed:
                      () => Navigator.pop(context), // Menutup halaman edit
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
