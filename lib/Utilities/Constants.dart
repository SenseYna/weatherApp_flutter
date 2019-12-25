import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _fireStore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _fireStore.collection('user');
final markerRef = _fireStore.collection('marker');
final postsRef = _fireStore.collection('post');
final followersRef = _fireStore.collection('followers');
final followingRef = _fireStore.collection('following');
final feedsRef = _fireStore.collection('feeds');
final likesRef = _fireStore.collection('likes');