import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/providers/user_provider.dart';
import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _descriptionController = TextEditingController();
  Uint8List? _file;

  void _clearPost() {
    setState(() {
      _file = null;
    });
  }

  void _postImage(String uid, String username, String profImage) async {
    try {
      await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Post added successfully'),
          ),
        );
      _clearPost();
    } on UploadPostFailure catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(e.message)),
        );
    }
  }

  void _selectImage() async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Choose Image"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text("Take a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                final file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text("Choose from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                final file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return _file == null
        ? Center(
            child: GestureDetector(
              onTap: _selectImage,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.upload),
                  Text(
                    "Select an image",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: kMobileBackgroundColor,
              title: const Text("Post to"),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearPost,
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "Post",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    _postImage(
                      user!.uid,
                      user.username,
                      user.imageUrl,
                    );
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.imageUrl == ""
                          ? "https://therminic2018.eu/wp-content/uploads/2018/07/dummy-avatar-300x300.jpg"
                          : user.imageUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
