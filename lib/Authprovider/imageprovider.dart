import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_uploader/constants/app_constantants.dart';
import 'package:image_uploader/models/documentmodel.dart';
import 'package:image_uploader/models/fileurl.dart';

class AppImageProvider extends ChangeNotifier {
  Client client = Client();
  late Account account;
  late Databases databases;
  late Storage storage;
  late Realtime realtime;
  late RealtimeSubscription realtimeSubscription;
  PlatformFile? _selectedfile;
  UploadedFiles? _uploadedFiles;
  List<DocModel>? _items;

  PlatformFile? get selectedfile => _selectedfile;
  UploadedFiles? get uploadedFiles => _uploadedFiles;
  List<DocModel>? get docmodel => _items;

  AppImageProvider() {
    _initialize();
  }

  _initialize() {
    _selectedfile = null;
    _uploadedFiles = null;
    client
        .setEndpoint(Appconstants.endpoint)
        .setProject(Appconstants.projectid);
    account = Account(client);
    databases = Databases(client, databaseId: Appconstants.dbID);
    storage = Storage(client);
    realtime = Realtime(client);
    _getaccount();
  }

  filepicker() async {
    var result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    _selectedfile = result.files.first;
    _uploadedFiles = await _uploadfile();
    createdocument();
    notifyListeners();
  }

  _getaccount() async {
    try {
      await account.get();
    } catch (_) {
      await account.createAnonymousSession();
    }
  }

  Future _uploadfile() async {
    try {
      var upload = await storage.createFile(
          bucketId: 'image_upload',
          fileId: 'unique()',
          file: InputFile(
              path: _selectedfile!.path, filename: _selectedfile?.name));
      notifyListeners();
      if (upload.$id.isNotEmpty == true) {
        var data = jsonEncode(upload.toMap());
        var jsondata = jsonDecode(data);
        return UploadedFiles.fromJson(jsondata);
      }
    } catch (e) {
      print(e);
    }
  }

  createdocument() async {
    try {
      var url =
          '${Appconstants.endpoint}/storage/buckets/${uploadedFiles!.bucketId}/files/${uploadedFiles!.id}/preview?project=${Appconstants.projectid}';
      var result = await databases.createDocument(
          collectionId: Appconstants.collectionID,
          documentId: uploadedFiles!.id!,
          data: {
            'url': url,
          });
    } catch (e) {
      print(e);
    }
  }

  Future displayfile() async {
    var result = await databases.listDocuments(
      collectionId: Appconstants.collectionID,
    );
    _items = result.documents
        .map((docmodel) => DocModel.fromJson(docmodel.data))
        .toList();
    notifyListeners();
  }
}
