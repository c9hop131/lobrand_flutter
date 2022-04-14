import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lobrand_flutter/providers/user_provider.dart';
import 'package:lobrand_flutter/resources/firestore_methods.dart';
import 'package:lobrand_flutter/utils/color.dart';
import 'package:lobrand_flutter/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import 'package:lobrand_flutter/models/user.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            ),
            );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8.0),
                  child: TextField(
                    controller: _commentingController,
                    decoration: InputDecoration(
                      hintText: "Thêm bình luận dưới tên ${user.username}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                    widget.snap['postId'],
                    _commentingController.text,
                    user.uid,
                    user.username,
                    user.photoUrl,
                  );
                  setState(() {
                    _commentingController.text = "";
                  });
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: const Text(
                      'Đăng',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
