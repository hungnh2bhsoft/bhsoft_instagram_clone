import 'dart:typed_data';

import 'package:bhsoft_instagram_clone/providers/providers.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:bhsoft_instagram_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({
    Key? key,
  }) : super(key: key);

  void _selectImage(
      BuildContext context, void Function(Uint8List?) onSelected) async {
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
                onSelected(file);
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text("Choose from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                final file = await pickImage(ImageSource.camera);
                onSelected(file);
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
    return ChangeNotifierProvider(
      create: (_) => PostProvider(
        user: Provider.of<UserProvider>(context, listen: false).user!,
      ),
      child: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.file == null) {
            return Center(
              child: GestureDetector(
                onTap: () => _selectImage(
                  context,
                  postProvider.onImageSelected,
                ),
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
            );
          }
          return IgnorePointer(
            ignoring: postProvider.isUploading,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: kMobileBackgroundColor,
                title: const Text("Post to"),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: postProvider.clearPost,
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      "Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: postProvider.uploadPost,
                  )
                ],
              ),
              body: ListView(
                children: [
                  if (postProvider.isUploading) const LinearProgressIndicator(),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          user!.imageUrl,
                        ),
                        radius: 28,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          maxLines: 3,
                          onChanged: postProvider.onDescriptionChanged,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write some description",
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 200,
                    child: Image.memory(
                      postProvider.file!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
