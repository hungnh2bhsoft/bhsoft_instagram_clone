import 'dart:developer';

import 'package:bhsoft_instagram_clone/ui/widgets/post_card.dart';
import 'package:bhsoft_instagram_clone/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kMobileBackgroundColor,
          title: SvgPicture.asset(
            "assets/ic_instagram.svg",
            color: kprimaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.messenger_outline_rounded,
                color: kprimaryColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error"),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index].data();
                log(data.toString());
                return PostCard(
                  data: data,
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
          },
        ));
  }
}
