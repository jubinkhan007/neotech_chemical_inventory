import 'package:flutter/widgets.dart';

class RepositoryProvider<T> extends InheritedWidget {
  const RepositoryProvider({
    required this.repository,
    required super.child,
    super.key,
  });

  final T repository;

  static T of<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<RepositoryProvider<T>>();
    assert(provider != null, 'RepositoryProvider<$T> not found in context');
    return provider!.repository;
  }

  @override
  bool updateShouldNotify(RepositoryProvider<T> oldWidget) {
    return repository != oldWidget.repository;
  }
}
