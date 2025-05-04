import 'package:flutter/material.dart';
import 'dart:io';

class ContactDetailPage extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String? label;
  final File? profileImage;

  const ContactDetailPage({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    this.label,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB2EBF2), Color(0xFF7E57C2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (label != null)
                        ContactLabel(
                          label: label!,
                          color: label == "Work" ? const Color(0xFF69F0AE) : const Color(0xFF4FC3F7),
                        ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundImage:
                  profileImage != null ? FileImage(profileImage!) : null,
                  child: profileImage == null
                      ? const Icon(Icons.person, color: Colors.white, size: 30)
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          ContactInfoCard(icon: Icons.phone, label: "Phone", value: phone, trailing: Icons.message),
          const SizedBox(height: 20),
          ContactInfoCard(icon: Icons.email, label: "Email", value: email),
          const Spacer(),

          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(Icons.edit, color: Color(0xFF7E57C2)),
                const Icon(Icons.star_border, color: Colors.amber),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Konfirmasi"),
                          content: const Text("Apakah Anda yakin ingin menghapus nomor ini?"),
                          actions: [
                            TextButton(
                              child: const Text("Tidak"),
                              onPressed: () {
                                Navigator.of(context).pop(); // tutup dialog
                              },
                            ),
                            TextButton(
                              child: const Text("Ya"),
                              onPressed: () {
                                // TODO: Tambahkan logika penghapusan jika perlu
                                Navigator.of(context).pop(); // tutup dialog
                                Navigator.of(context).pop(); // kembali ke halaman sebelumnya
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContactLabel extends StatelessWidget {
  final String label;
  final Color color;

  const ContactLabel({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.black87)),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final IconData? trailing;

  const ContactInfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (trailing != null) Icon(trailing, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
