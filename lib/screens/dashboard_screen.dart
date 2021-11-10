import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import '../services/db_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _auth = AuthService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List posts = [];

  String userId = "";
  String name = "";

  @override
  void initState() {
    super.initState();
    fetchUserId();
    fetchPosts();
  }

  fetchUserId() {
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  fetchUserData() async {
    dynamic user = await DatabaseService()
        .getUserData(FirebaseAuth.instance.currentUser!.uid);

    if (user != null) {
      setState(() {
        name = user.get(FieldPath(['name']));
      });
    }
  }

  fetchPosts() async {
    dynamic result = await DatabaseService().getPostsData();

    if (result == null) {
      print('Unable to get posts');
    } else {
      setState(() {
        posts = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
              title: Text(posts[index]['title']),
              subtitle: Text(posts[index]['description']),
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createPost(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void logout() {
    _auth.logout();
    Navigator.pushNamed(context, '/login');
  }

  createPost(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add post'),
            content: SizedBox(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  submitAction(context);
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  submitAction(BuildContext context) {
    DatabaseService().createPostData(DateTime.now().toString(), userId, name,
        _titleController.text, _descriptionController.text, DateTime.now());
    _titleController.clear();
    _descriptionController.clear();
  }
}
