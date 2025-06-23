import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../data/music_data.dart';

class CoolPlayerUI extends StatefulWidget {
  final bool isPlaying;
  final Song? currentSong;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final double? progress;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? textColor;

  const CoolPlayerUI({
    super.key,
    required this.isPlaying,
    this.currentSong,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    this.progress,
    this.primaryColor,
    this.secondaryColor,
    this.textColor,
  });

  @override
  State<CoolPlayerUI> createState() => _CoolPlayerUIState();
}

class _CoolPlayerUIState extends State<CoolPlayerUI>
    with SingleTickerProviderStateMixin {
  late Color _primaryColor;
  late Color _secondaryColor;
  late Color _textColor;
  bool _isLoading = false;

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _primaryColor = widget.primaryColor ?? Colors.red.shade800;
    _secondaryColor = widget.secondaryColor ?? Colors.red.shade500;
    _textColor = widget.textColor ?? Colors.white;

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    if (widget.primaryColor == null && widget.currentSong?.coverImage != null) {
      _updatePaletteGenerator();
    }

    if (!widget.isPlaying) {
      _rotationController.stop();
    }
  }

  @override
  void didUpdateWidget(CoolPlayerUI oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.primaryColor != oldWidget.primaryColor) {
      _primaryColor = widget.primaryColor ?? Colors.red.shade800;
    }

    if (widget.secondaryColor != oldWidget.secondaryColor) {
      _secondaryColor = widget.secondaryColor ?? Colors.red.shade500;
    }

    if (widget.textColor != oldWidget.textColor) {
      _textColor = widget.textColor ?? Colors.white;
    }

    if (widget.primaryColor == null &&
        widget.currentSong?.coverImage != oldWidget.currentSong?.coverImage) {
      if (widget.currentSong?.coverImage != null) {
        _updatePaletteGenerator();
      } else {
        setState(() {
          _primaryColor = Colors.red.shade800;
          _secondaryColor = Colors.red.shade500;
          _textColor = Colors.white;
        });
      }
    }

    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  Future<void> _updatePaletteGenerator() async {
    if (widget.currentSong?.coverImage == null) return;

    setState(() {
      _isLoading = true;
    });

    ImageProvider imageProvider;
    if (widget.currentSong!.coverImage!.startsWith('http')) {
      imageProvider = NetworkImage(widget.currentSong!.coverImage!);
    } else {
      imageProvider = AssetImage(widget.currentSong!.coverImage!);
    }

    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
    );

    if (mounted) {
      setState(() {
        _primaryColor =
            paletteGenerator.dominantColor?.color ??
            paletteGenerator.vibrantColor?.color ??
            Colors.red.shade800;

        _secondaryColor =
            paletteGenerator.mutedColor?.color ??
            _primaryColor.withOpacity(0.7);

        _textColor = _primaryColor.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white;

        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_primaryColor, _secondaryColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: widget.isPlaying
                            ? _rotationController.value * 2 * math.pi
                            : 0,
                        child: child,
                      );
                    },
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _textColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                        image: widget.currentSong?.coverImage != null
                            ? DecorationImage(
                                image:
                                    widget.currentSong!.coverImage!.startsWith(
                                      'http',
                                    )
                                    ? NetworkImage(
                                        widget.currentSong!.coverImage!,
                                      )
                                    : AssetImage(
                                            widget.currentSong!.coverImage!,
                                          )
                                          as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.currentSong?.coverImage == null
                          ? Icon(
                              Icons.music_note,
                              size: 50,
                              color: _textColor.withOpacity(0.7),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.currentSong?.title ?? 'Select a song',
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.currentSong?.singer ?? 'Musically',
                          style: TextStyle(
                            color: _textColor.withOpacity(0.8),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 12),

                        if (widget.progress != null)
                          Stack(
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: _textColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: widget.progress! > 1.0
                                    ? 1.0
                                    : widget.progress,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: _textColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous_rounded),
                              onPressed: widget.onPrevious,
                              color: _textColor,
                              iconSize: 28,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: _textColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  widget.isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 30,
                                  color: _primaryColor,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: widget.onPlayPause,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next_rounded),
                              onPressed: widget.onNext,
                              color: _textColor,
                              iconSize: 28,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
