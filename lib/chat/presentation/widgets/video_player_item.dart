import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late final CachedVideoPlayerController _controller;
  late bool _isPlay;

  @override
  void initState() {
    super.initState();
    _isPlay = false;
    _controller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        _controller.setVolume(1);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Stack(children: [
        CachedVideoPlayer(_controller),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () {
              if (_isPlay) {
                _controller.pause();
              } else {
                _controller.play();
              }

              setState(() => _isPlay = !_isPlay);
            },
            icon: Icon(_isPlay ? Icons.pause_circle : Icons.play_circle),
          ),
        ),
      ]),
    );
  }
}
