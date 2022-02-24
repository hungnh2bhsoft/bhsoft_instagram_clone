import 'package:bhsoft_instagram_clone/models/models.dart';
import 'package:bhsoft_instagram_clone/providers/search_provider.dart';
import 'package:bhsoft_instagram_clone/ui/screens/screens.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kMobileBackgroundColor,
          title: Consumer<SearchProvider>(
            builder: (_, searchProvider, __) => TextFormField(
              onChanged: searchProvider.onValueChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Search for users",
              ),
            ),
          ),
        ),
        body: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: searchProvider.isEmpty
                ? const Center(
                    child: Icon(
                    Icons.search_rounded,
                    size: 40,
                    color: kSecondaryColor,
                  ))
                : searchProvider.isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : searchProvider.results.isEmpty
                        ? const Center(
                            child: Text(
                            "No results found",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                        : ListView.builder(
                            itemCount: searchProvider.results.length,
                            itemBuilder: (context, index) => _buildResultTile(
                                context, searchProvider.results[index]),
                          ),
          ),
        ),
      ),
    );
  }

  ListTile _buildResultTile(BuildContext context, User user) {
    return ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return ProfileScreen(uid: user.uid);
      })),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          user.imageUrl,
        ),
      ),
      title: Text(user.username),
      subtitle: Text(user.username),
    );
  }
}
