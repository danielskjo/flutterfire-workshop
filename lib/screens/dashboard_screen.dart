import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  late Stream posts;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  fetchPosts() async {
    dynamic results = await DatabaseService().getPosts();

    if (results == null) {
      print('Unable to get posts');
    } else {
      setState(() {
        posts = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: posts,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            }

            return ListView(
              children: (snapshot.data! as QuerySnapshot).docs.map((post) {
                return Center(
                  child: ListTile(
                    title: Text(post['title']),
                    subtitle: Text(post['description']),
                  ),
                );
              }).toList(),
            );
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
                child: const Text('Create'),
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
    DatabaseService().createPost(DateTime.now().toString(),
        _titleController.text, _descriptionController.text, DateTime.now());
    fetchPosts();
    _titleController.clear();
    _descriptionController.clear();
  }
}
