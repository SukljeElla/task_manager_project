import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_project/controller/attachment_controller.dart';
import 'package:task_manager_project/model/attachment.dart';
import 'package:task_manager_project/controller/user_controller.dart';

class AttachmentView extends StatefulWidget {
  const AttachmentView({Key? key}) : super(key: key);

  @override
  _AttachmentViewState createState() => _AttachmentViewState();
}

class _AttachmentViewState extends State<AttachmentView> {
  final AttachmentController _attachmentController = AttachmentController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final UserController _userController = UserController();

  List<Attachment> _attachments = [];
  bool _isLoading = true;
  bool _isAdmin = false;

  get _userRole => null;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadAttachments();
  }

  Future<void> _loadUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String role = await _userController.getUserRole();
      setState(() {
        _isAdmin = role == "admin";
      });
    }
  }

  Future<void> _loadAttachments() async {
    List<Attachment> attachments =
        await _attachmentController.getAttachmentsForTask("global");
    setState(() {
      _attachments = attachments;
      _isLoading = false;
    });
  }

  Future<void> _uploadAttachment() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File file = File(pickedFile.path);
    try {
      Attachment uploadedAttachment =
          await _attachmentController.uploadAttachment("global", file);

      setState(() {
        _attachments.add(uploadedAttachment);
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Attachment uploaded successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _deleteAttachment(Attachment attachment) async {
    await _attachmentController.deleteAttachment("global", attachment.fileName);
    setState(() {
      _attachments.remove(attachment);
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attachment deleted successfully!")));
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attachments",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_isAdmin)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Upload Attachment",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _uploadAttachment,
                            icon: const Icon(Icons.upload_file,
                                color: Color.fromARGB(170, 0, 0, 0)),
                            label: const Text("Select & Upload File",
                                style: TextStyle(
                                  color: Color.fromARGB(166, 12, 12, 12),
                                )),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isAdmin = !_isAdmin)
                          const Text(
                            "Attachment list",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(height: 10),
                        _isLoading
                            ? const Expanded(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : _attachments.isEmpty
                                ? const Expanded(
                                    child: Center(
                                      child: Text(
                                        "No attachments available.",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      itemCount: _attachments.length,
                                      itemBuilder: (context, index) {
                                        Attachment attachment =
                                            _attachments[index];
                                        return Card(
                                          color: const Color.fromARGB(
                                                  255, 41, 150, 196)
                                              .withOpacity(0.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(12),
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                attachment.fileUrl,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(Icons.image,
                                                      color: Colors.white70);
                                                },
                                              ),
                                            ),
                                            title: Text(
                                              "${attachment.fileName.replaceAll(attachment.fileName, "Uploaded Attachments")}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                                "Uploaded: ${attachment.uploadedAt.toString().replaceAll(attachment.uploadedAt.toString(), "2025-05" "\n")}"
                                                "${_isAdmin ? "ID: ${attachment.id.hashCode.toInt()}" : ""}",
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            0, 255, 255, 255),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    decorationColor:
                                                        Color.fromARGB(
                                                            0, 0, 0, 0))),
                                            trailing: _isAdmin
                                                ? IconButton(
                                                    icon: const Icon(
                                                        Icons.delete,
                                                        color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255)),
                                                    onPressed: () =>
                                                        _deleteAttachment(
                                                            attachment),
                                                  )
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
