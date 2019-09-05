import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Task {
  String id;
  String name;
  int createdAt;

  Task({this.id, this.name, this.createdAt});

  Task.map(dynamic obj) {
    this.name = obj['name'];
    this.createdAt = obj['createdAt'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['createdAt'] = createdAt;
    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    this.name = map['taskname'];
    this.createdAt = map['tasktime'];
  }

  factory Task.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map data = documentSnapshot.data;

    return Task(
        id: documentSnapshot.documentID,
        name: data['name'],
        createdAt: data['createdAt']);
  }
}
