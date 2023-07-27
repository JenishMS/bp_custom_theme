import 'package:better_player/better_player.dart';
import 'package:bp_custom_theme/video_scrubber.widget.dart';
import 'package:flutter/material.dart';

class CustomPlayerControl extends StatelessWidget {
  const CustomPlayerControl({required this.controller, super.key});

  final BetterPlayerController controller;

  void _onTap() {
    controller.setControlsVisibility(true);
    if (controller.isPlaying()!) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  void _controlVisibility() {
    controller.setControlsVisibility(true);
    Future.delayed(const Duration(seconds: 3))
        .then((value) => controller.setControlsVisibility(false));
  }

  String _formatDuration(Duration? duration) {
    if (duration != null) {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      return '00:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _controlVisibility,
      child: StreamBuilder(
        initialData: false,
        stream: controller.controlsVisibilityStream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Visibility(
                visible: snapshot.data!,
                child: Positioned(
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: _onTap,
                      backgroundColor: Colors.black.withOpacity(0.7),
                      child: controller.isPlaying()!
                          ? const Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 40,
                            )
                          : const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 8,
                child: ValueListenableBuilder(
                  valueListenable: controller.videoPlayerController!,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 36,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                shape: BoxShape.rectangle,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Text(
                                '${_formatDuration(value.position)}/${_formatDuration(value.duration)}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                controller.toggleFullScreen();
                              },
                              icon: const Icon(
                                Icons.crop_free_rounded,
                                size: 22,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        VideoScrubber(
                          controller: controller,
                          playerValue: value,
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
