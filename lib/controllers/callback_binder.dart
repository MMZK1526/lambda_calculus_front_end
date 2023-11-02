import 'package:flutter/material.dart';
import 'package:lambda_calculus_front_end/utilities/prelude.dart';

/// Dynamically binds a [VoidCallback] to a key, and allows for the
/// [VoidCallback] to be retrieved by the key.
///
/// Each key is associated with one or more groups. A group is a
/// [String] that can be used to group keys together. It is useful so that
/// [VoidCallback]s can be added and removed by group.
///
/// If a key is associated with multiple groups, then the all corresponding
/// [VoidCallback]s will be called when the key is invoked.
///
/// This class is useful for binding callbacks to a key, and then
/// retrieving the callback by the key.
///
/// Note that this class is not thread-safe.
class CallbackBinder<T> {
  /// The map of keys to callbacks.
  final Map<Pair<String?, T>, VoidCallback> _listeners = {};

  /// The map of key groupings.
  final Map<String?, List<T>> _groups = {};

  /// The map of keys to their (potentially multiple) groups.
  final Map<T, List<String?>> _keyGroups = {};

  /// The current group name.
  String? currentGroup;

  /// Call all [VoidCallback]s associated with the given [key].
  void invokeAt(T key) {
    final groups = _keyGroups[key] ?? [];
    for (final group in groups) {
      final callback = _listeners[Pair(group, key)];
      callback?.call();
    }
  }

  /// Get the [Map] from groups to [VoidCallback]s associated with the given
  /// [key].
  Map<String?, VoidCallback> operator [](T key) {
    final groups = _keyGroups[key] ?? [];
    final callbacks = <String?, VoidCallback>{};
    for (final group in groups) {
      callbacks[group] = _listeners[Pair(group, key)]!;
    }
    return callbacks;
  }

  /// Bind a [VoidCallback] to the given [key] in the [currentGroup].
  void operator []=(T key, VoidCallback callback) {
    _groups[currentGroup] = _groups[currentGroup] ?? [];
    _groups[currentGroup]?.add(key);
    _keyGroups[key] = _keyGroups[key] ?? [];
    _keyGroups[key]?.add(currentGroup);

    _listeners[Pair(currentGroup, key)] = callback;
  }

  /// Conduct an action with the given [currentGroup].
  S withCurrentGroup<S>(String group, S Function() action) {
    final previousGroup = currentGroup;
    currentGroup = group;
    final result = action();
    currentGroup = previousGroup;
    return result;
  }

  /// Remove all [VoidCallback]s in the given group. If the group is not
  /// provided, clear all groups.
  void dispose([String? group]) {
    if (group == null) {
      _listeners.clear();
      _groups.clear();
      _keyGroups.clear();
      currentGroup = null;
    } else {
      _groups[group]?.forEach((key) {
        _listeners.remove(Pair(group, key));
        _keyGroups[key]?.remove(group);
      });
      _groups.remove(group);
    }
  }
}
