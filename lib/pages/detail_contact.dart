import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_phone/pages/edit_contact.dart';
import 'package:flutter_phone/db/database_helper.dart';
import 'package:flutter_phone/models/contact_model.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactDetailPage extends StatefulWidget {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String? label;
  final File? profileImage;

  const ContactDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.label,
    this.profileImage,
  });

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  Contact? _contact;

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    if (widget.id != null) {
      final contact = await DatabaseHelper().getContactById(widget.id!);
      setState(() {
        _contact = contact;
      });
    }
  }

  Future<void> _makeDirectCall(String phoneNumber) async {
    final status = await Permission.phone.status;

    if (!status.isGranted) {
      await Permission.phone.request();
    }

    if (await Permission.phone.isGranted) {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin panggilan tidak diberikan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_contact == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  onPressed: () => Navigator.pop(context, true),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _contact!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_contact!.label != null)
                        ContactLabel(
                          label: _contact!.label!,
                          color: _contact!.label == "Work"
                              ? const Color(0xFF69F0AE)
                              : const Color(0xFF4FC3F7),
                        ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundImage:
                      widget.profileImage != null ? FileImage(widget.profileImage!) : null,
                  child: widget.profileImage == null
                      ? const Icon(Icons.person, color: Colors.white, size: 30)
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          ContactInfoCard(
            icon: Icons.phone,
            label: "Phone",
            value: _contact!.phone,
            trailing: Icons.message,
          ),
          const SizedBox(height: 20),
          ContactInfoCard(
            icon: Icons.email,
            label: "Email",
            value: _contact!.email ?? '-',
          ),
          const Spacer(),

          // Action Buttons
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF7E57C2)),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContactPage(contact: _contact!),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _contact = result;
                      });
                      _loadContact();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () => _makeDirectCall(_contact!.phone),
                ),
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
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text("Ya"),
                              onPressed: () async {
                                if (_contact!.id != null) {
                                  await DatabaseHelper().deleteContact(_contact!.id!);
                                }
                                Navigator.of(context).pop();
                                Navigator.of(context).pop(true);
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
          ),
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
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
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
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
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
                Text(
                  value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          if (trailing != null) Icon(trailing, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
