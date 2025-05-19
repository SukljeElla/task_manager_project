import 'package:firebase_storage/firebase_storage.dart';
import 'package:task_manager_project/model/attachment.dart';
import 'dart:io';
import 'package:task_manager_project/model/attachment.dart';

class AttachmentController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Attachment> uploadAttachment(String taskId, File file) async {
    try {
      String fileName = file.path;
      Reference ref =
          _storage.ref().child('tasks/$taskId/attachments/$fileName');

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      String fileUrl = await snapshot.ref.getDownloadURL();
      print('File uploaded successfully: $fileUrl');

      return Attachment(
        id: ref.name,
        fileName: fileName,
        fileUrl: fileUrl,
        uploadedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error uploading attachment: $e');
      rethrow;
    }
  }

  Future<void> deleteAttachment(String taskId, String fileName) async {
    try {
      Reference ref =
          _storage.ref().child('tasks/$taskId/attachments/$fileName');
      await ref.delete();

      print('Attachment deleted successfully!');
    } catch (e) {
      print('Error deleting attachment: $e');
      rethrow;
    }
  }

  Future<List<Attachment>> getAttachmentsForTask(String taskId) async {
    try {
      ListResult result =
          await _storage.ref().child('tasks/$taskId/attachments').listAll();

      List<Attachment> attachments = [];
      for (var item in result.items) {
        String fileUrl = await item.getDownloadURL();
        attachments.add(Attachment(
          id: item.name,
          fileName: item.name,
          fileUrl: fileUrl,
          uploadedAt: DateTime.now(),
        ));
      }

      print('Retrieved ${attachments.length} attachments');
      return attachments;
    } catch (e) {
      print('Error retrieving attachments: $e');
      rethrow;
    }
  }
}
