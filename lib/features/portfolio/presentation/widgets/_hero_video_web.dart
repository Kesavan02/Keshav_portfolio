import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class HeroVideoController {
  final VoidCallback onReady;
  late final html.VideoElement videoElement;
  final String viewType;
  bool _isReady = false;
  bool _isSeeking = false;
  double _targetProgress = 0.0;

  HeroVideoController({required this.onReady})
    : viewType = 'hero-video-view-${DateTime.now().microsecondsSinceEpoch}' {
    videoElement = html.VideoElement()
      ..src = 'assets/assets/video/avatar_video.mp4'
      ..autoplay = false
      ..controls = false
      ..muted = true
      ..loop = false
      ..setAttribute('playsinline', 'true')
      ..preload = 'auto'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.pointerEvents = 'none';

    // Register the platform view factory
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => videoElement,
    );

    // Warm up the video decoder by playing and pausing it.
    // Muted videos are allowed to autoplay without user interaction.
    videoElement.play().then((_) {
      videoElement.pause();
    }).catchError((_) {
      // Ignore autoplay policy blocks
    });

    void setReady() {
      if (!_isReady) {
        _isReady = true;
        onReady();
      }
    }

    videoElement.onLoadedMetadata.listen((_) => setReady());
    videoElement.onCanPlay.listen((_) => setReady());

    videoElement.onError.listen((_) {
      if (videoElement.src.contains('assets/assets/')) {
        // Fallback to without double assets prefix if the first one fails
        videoElement.src = 'assets/video/avatar_video.mp4';
        videoElement.load();
        videoElement.play().then((_) => videoElement.pause()).catchError((_) {});
      }
    });

    videoElement.onSeeked.listen((_) {
      _isSeeking = false;
      // Align the next seek with the browser's animation/paint loop
      html.window.requestAnimationFrame((_) {
        _performSeek();
      });
    });

    // In case the metadata is already loaded:
    if (!videoElement.duration.isNaN && videoElement.duration > 0) {
      setReady();
    }
  }

  bool get isReady => _isReady;

  void seekTo(double progress) {
    if (!_isReady) return;
    _targetProgress = progress;
    _performSeek();
  }

  void _performSeek() {
    if (_isSeeking) return;

    final duration = videoElement.duration;
    if (duration.isNaN || duration == 0) return;

    final targetTime = (_targetProgress * duration).clamp(0.0, duration);

    // Skip seeking if delta is extremely small to avoid micro-jitter
    if ((videoElement.currentTime - targetTime).abs() < 0.01) return;

    _isSeeking = true;
    videoElement.currentTime = targetTime;
  }

  void dispose() {
    videoElement.src = '';
    videoElement.load();
  }
}

class HeroVideoView extends StatelessWidget {
  final HeroVideoController controller;
  const HeroVideoView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: controller.viewType);
  }
}
