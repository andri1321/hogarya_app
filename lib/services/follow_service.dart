import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple follow service with persistence using SharedPreferences.
class FollowService {
  FollowService._();

  static final FollowService instance = FollowService._();

  // map userId -> set of followerIds
  final Map<String, Set<String>> _followers = {};

  // map userId -> set of followingIds
  final Map<String, Set<String>> _following = {};

  // notifier to trigger UI refresh when follow state changes
  final ValueNotifier<int> notifier = ValueNotifier(0);

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final followersJson = prefs.getString('follow_service_followers');
    final followingJson = prefs.getString('follow_service_following');

    if (followersJson != null) {
      final Map<String, dynamic> raw = json.decode(followersJson);
      raw.forEach((key, value) {
        _followers[key] = Set<String>.from(List<String>.from(value));
      });
    }

    if (followingJson != null) {
      final Map<String, dynamic> raw = json.decode(followingJson);
      raw.forEach((key, value) {
        _following[key] = Set<String>.from(List<String>.from(value));
      });
    }

    _initialized = true;
    notifier.value++;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final followersJson = _mapToJson(_followers);
    final followingJson = _mapToJson(_following);
    await prefs.setString('follow_service_followers', followersJson);
    await prefs.setString('follow_service_following', followingJson);
  }

  String _mapToJson(Map<String, Set<String>> map) {
    final m = <String, List<String>>{};
    map.forEach((k, v) {
      m[k] = v.toList();
    });
    return json.encode(m);
  }

  bool isFollowing(String me, String other) {
    final set = _following[me];
    if (set == null) return false;
    return set.contains(other);
  }

  void follow(String me, String other) {
    if (me == other) return;

    final myFollowing = _following.putIfAbsent(me, () => <String>{});
    final otherFollowers = _followers.putIfAbsent(other, () => <String>{});

    if (myFollowing.contains(other)) return; // avoid duplicates

    myFollowing.add(other);
    otherFollowers.add(me);

    _save();
    notifier.value++;
  }

  void unfollow(String me, String other) {
    final myFollowing = _following[me];
    final otherFollowers = _followers[other];

    if (myFollowing != null) {
      myFollowing.remove(other);
    }

    if (otherFollowers != null) {
      otherFollowers.remove(me);
    }

    _save();
    notifier.value++;
  }

  int followersCount(String userId) {
    return _followers[userId]?.length ?? 0;
  }

  int followingCount(String userId) {
    return _following[userId]?.length ?? 0;
  }
}
