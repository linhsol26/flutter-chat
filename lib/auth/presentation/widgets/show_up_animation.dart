import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Direction { vertical, horizontal }

/// Wrapper class to implement slide and fade animations at the same time to
/// the [child]. Wrap the widget that you wish to make appearance with slide-fade transition
/// or better known as the "Show Up" animation in this class.
class ShowUpAnimation extends StatefulHookConsumerWidget {
  /// The child on which to apply the given [ShowUpAnimation].
  final Widget child;

  /// The offset by which to slide and [child] into view from [Direction].
  /// Use negative value to reverse animation [direction]. Defaults to 0.2.
  final double offset;

  /// The curve used to animate the [child] into view.
  /// Defaults to [Curves.easeIn]
  final Curve curve;

  /// The direction from which to animate the [child] into view. [Direction.horizontal]
  /// will make the child slide on x-axis by [offset] and [Direction.vertical] on y-axis.
  /// Defaults to [Direction.vertical].
  final Direction direction;

  /// The delay with which to animate the [child]. Takes in a [Duration] and
  /// defaults to 0.0 seconds.
  final Duration delayStart;

  /// The total duration in which the animation completes. Defaults to 800 milliseconds.
  final Duration animationDuration;

  final AnimationController animationController;

  const ShowUpAnimation({
    required this.child,
    this.offset = 0.2,
    this.curve = Curves.easeIn,
    this.direction = Direction.vertical,
    this.delayStart = const Duration(seconds: 0),
    this.animationDuration = const Duration(milliseconds: 800),
    required this.animationController,
    Key? key,
  }) : super(key: key);

  @override
  _ShowUpAnimationState createState() => _ShowUpAnimationState();
}

class _ShowUpAnimationState extends ConsumerState<ShowUpAnimation> {
  late Animation<Offset> _animationSlide;
  late Animation<double> _animationFade;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      if (widget.direction == Direction.vertical) {
        _animationSlide = Tween<Offset>(begin: Offset(0, widget.offset), end: const Offset(0, 0))
            .animate(CurvedAnimation(
          curve: widget.curve,
          parent: widget.animationController,
        ));
      } else {
        _animationSlide = Tween<Offset>(begin: Offset(widget.offset, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
          curve: widget.curve,
          parent: widget.animationController,
        ));
      }

      _animationFade = Tween<double>(begin: -1.0, end: 1.0).animate(
        CurvedAnimation(
          curve: widget.curve,
          parent: widget.animationController,
        ),
      );
      return null;
    });

    return FadeTransition(
      opacity: _animationFade,
      child: SlideTransition(
        position: _animationSlide,
        child: widget.child,
      ),
    );
  }
}
