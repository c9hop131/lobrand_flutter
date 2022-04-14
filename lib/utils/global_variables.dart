import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lobrand_flutter/screens/add_post_screen.dart';
import 'package:lobrand_flutter/screens/feed_screen.dart';
import 'package:lobrand_flutter/screens/profile_screen.dart';
import 'package:lobrand_flutter/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItem = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('noti'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
