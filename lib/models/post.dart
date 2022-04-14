 import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
   final String description;
   final String uid;
   final String postId;
   final String username;
   final datePublished;
   final String postUrl;
   final String profImage;
   final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.postUrl,
    required this.username,
    required this.postId,
    required this.profImage,
    required this.likes,
    required this.datePublished,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
    );
  }

  
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postId": postId,
        "postUrl": postUrl,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
      };
 }