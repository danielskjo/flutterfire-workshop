import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

  Future<void> createPost(
    String postId,
    String title,
    String description,
    DateTime date,
  ) async {
    return await posts.doc(postId).set({
      'title': title,
      'description': description,
      'date': date,
    });
  }

  Future getPosts() async {
    try {
      return posts.snapshots();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
