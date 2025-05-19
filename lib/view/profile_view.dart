import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:task_manager_project/controller/attachment_controller.dart';
import 'package:task_manager_project/model/attachment.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AttachmentController _attachmentController = AttachmentController();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _profileImageUrl = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DatabaseReference userRef = _database.child("users/${user.uid}");
    DatabaseEvent event = await userRef.once();

    if (event.snapshot.value != null) {
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        _nameController.text = userData["name"] ?? "";
        _surnameController.text = userData["surname"] ?? "";
        _emailController.text = userData["email"] ?? "";
        _profileImageUrl = userData["profileImage"] ?? "";
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfileImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    File file = File(pickedFile.path);
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      Attachment uploadedAttachment =
          await _attachmentController.uploadAttachment("profile_images", file);

      await _database.child("users/${user.uid}").update({
        "profileImage": uploadedAttachment.fileUrl,
      });

      setState(() {
        _profileImageUrl = uploadedAttachment.fileUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile image updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _updateUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    await _database.child("users/${user.uid}").update({
      "name": _nameController.text.trim(),
      "surname": _surnameController.text.trim(),
      "email": _emailController.text.trim(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Profile updated!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 86, 174, 201), Color(0xFF23233B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _updateProfileImage,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              backgroundImage: _profileImageUrl.isNotEmpty
                                  ? NetworkImage(_profileImageUrl)
                                  : null,
                              child: _profileImageUrl.isEmpty
                                  ? const Icon(Icons.camera_alt,
                                      size: 40,
                                      color: Color.fromARGB(182, 105, 104, 104))
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Name",
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.03),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _surnameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Surname",
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.03),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Email",
                              labelStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.03),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _updateUserData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(40, 40, 164, 209),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                            ),
                            child: const Text(
                              "Save Changes",
                              selectionColor: Color.fromARGB(0, 255, 255, 255),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(129, 255, 255, 255)),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
