import 'package:flutter/material.dart';

/// Non-web stub — compiles on mobile/desktop but does nothing.
/// The gradient placeholder in HeroSliver is shown instead.
class HeroVideoController {
  HeroVideoController({required VoidCallback onReady});
  bool get isReady => false;
  void seekTo(double progress) {}
  void dispose() {}
}

class HeroVideoView extends StatelessWidget {
  // ignore: unused_element
  final HeroVideoController controller;
  const HeroVideoView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
