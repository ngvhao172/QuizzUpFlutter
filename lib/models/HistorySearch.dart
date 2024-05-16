import 'package:cloud_firestore/cloud_firestore.dart';

class HistorySearch {
  String? id;
  String userId;
  String searchContent;

  DateTime? createdAt = DateTime.now();

  HistorySearch({
    this.id,
    createdAt,
    required this.userId,
    required this.searchContent,
  }) : this.createdAt = createdAt ?? DateTime.now();

  factory HistorySearch.fromJson(Map<String, dynamic> json) {
    return HistorySearch(
      id: json['id'],
      userId: json['userId'],
      searchContent: json['searchContent'],
      createdAt: (json['createdAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'createdAt': createdAt, 'searchContent': searchContent};
  }
}
