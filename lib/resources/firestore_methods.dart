// import 'dart:ffi';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lobrand_flutter/models/post.dart';
import 'package:lobrand_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String podtId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: podtId,
        postUrl: photoUrl,
        profImage: profImage,
        datePublished: DateTime.now(),
        likes: [],
      );

      _firestore.collection('posts').doc(podtId).set(
            post.toJson(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }
  Future<void> postComment(String postId, String text, String uid, String name, String profilePic) async {
    try {
      if(text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic' : profilePic,
          'uid' : uid,
          'name' : name,
          'text' : text,
          'commentId' : commentId,
          'datePublished' : DateTime.now(),
        });
      } else {
        print('empty comment');
      }
    } catch (e) {
      print(e.toString(),);
    }
  }

  Future<void> followUser(
    String uid, 
    String followId
  ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString(),);
    }
  }
}
