import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List posts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("Home"),
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
    posts.add({
      'title': _titleController.text,
      'description': _descriptionController.text
    });
    print(posts);
    _titleController.clear();
    _descriptionController.clear();
  }
}
