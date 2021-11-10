import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //
  // User Collection
  //
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Create document in user collection for new user
  Future<void> createUserData(
    String uid,
    String name,
    String email,
    String password,
  ) async {
    return await users.doc(uid).set({
      "name": name,
      "email": email,
      "password": password,
    });
  }

  // Get current user's data
  getUserData(String uid) async {
    try {
      return await users.doc(uid).get();
    } catch (err) {
      print(err.toString());
    }
  }

  //
  // Posts collection
  //
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');

  // Create document in post collection
  Future<void> createPostData(
    String pid,
    String uid,
    String name,
    String title,
    String description,
    DateTime date,
  ) async {
    return await posts.doc(pid).set({
      'uid': uid,
      'name': name,
      'title': title,
      'description': description,
      'date': date,
    });
  }

  // Get all posts
  Future getPostsData() async {
    List postsList = [];
    
    try {
      await posts.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          postsList.add(element.data);
        });
      });
      return postsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
