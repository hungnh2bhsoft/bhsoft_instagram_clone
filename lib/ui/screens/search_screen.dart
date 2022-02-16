import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/resources/firestore_methods.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  bool isEmpty = true;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() {
        handleSearch(_searchController.text);
      });
  }

  void handleSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search for users",
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isEmpty
            ? const Center(
                child: Icon(
                Icons.search_rounded,
                size: 40,
                color: kSecondaryColor,
              ))
            : FutureBuilder<List<User>>(
                future: FirestoreMethods().searchUsers(_searchController.text),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  final users = snapshot.data!;
                  if (users.isEmpty) {
                    return const Center(
                      child: Text("No user found"),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            users[index].imageUrl,
                          ),
                        ),
                        title: Text(users[index].username),
                        subtitle: Text(users[index].username),
                      );
                    },
                    itemCount: users.length,
                  );
                },
              ),
      ),
    );
  }
}
