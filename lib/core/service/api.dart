import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart';
import 'package:project_order_food/core/extension/log.dart';
import 'package:project_order_food/core/model/field_name.dart';

class Api {
  Api(this.pathCollection) {
    ref = FirebaseFirestore.instance.collection(pathCollection);
  }
  final String pathCollection;
  late CollectionReference ref;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Stream<QuerySnapshot> streamDataCollectionWithQuery(Query query) {
    return query.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<String?> removeDocument(String id) async {
    try {
      await ref.doc(id).delete();
      logSuccess('Data deleted successfully: $pathCollection');
      return null;
    } catch (e) {
      logSuccess('Failed to delete data: $pathCollection');
      return 'Failed to delete data';
    }
  }

  Future<String?> addDocument(Map data, {File? file, String? customID}) async {
    if (file != null) {
      String pathFile =
          '$pathCollection/${DateTime.now()}_${basename(file.path)}';

      try {
        String url = await _uploadFile(file, pathFile: pathFile);
        data['img'] = url;
        logSuccess('File uploaded successfully: $url');
      } catch (e) {
        logError('File upload unsuccessful: $e');
      }
    }

    try {
      Map<String, Object> newData = Map.from({
        ...data,
        ...{FieldName.createDate: DateTime.now()}
      });
      if (customID == null) {
        ref.add(newData);
      } else {
        ref.doc(customID).set(newData);
      }

      logSuccess('Successfully added data to the table $pathCollection');
      return null;
    } catch (e) {
      logError('Failed to add data: $e');
      return 'An error occurred';
    }
  }

  Future<String?> updateDocument(Map data, String id, {File? file}) async {
    //Conditon file is not null => replace new image
    try {
      if (file != null) {
        try {
          //Remove file
          String currentDirectory =
              '$pathCollection/${FirebaseStorage.instance.refFromURL(data['img'] as String).name}';
          await storage.ref().child(currentDirectory).delete();
          //upload new file

          String pathFile =
              '$pathCollection/${DateTime.now()}_${basename(file.path)}';
          String url = await _uploadFile(file, pathFile: pathFile);
          data['img'] = url;
          data[FieldName.updateDate] = DateTime.now();
          logSuccess('Successfully updated new image');
        } catch (e) {
          logError(
              'Failed to update new image: This may be because the image path (img) is not present in the data $e');
        }
      }
      await ref.doc(id).update(Map.from(data));
      return null;
    } catch (e) {
      logError('There was an error while updating the information: $e');
      return 'There was an error while updating the information';
    }
  }

  Future<String> _uploadFile(File file, {required String pathFile}) async {
    UploadTask uploadTask = storage.ref(pathFile).putFile(file);
    String url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }
}
