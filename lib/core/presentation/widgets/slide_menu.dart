import 'package:flutter/material.dart';

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;
  final AnimationController controller;

  const SlideMenu(
      {Key? key, required this.child, required this.menuItems, required this.controller})
      : super(key: key);

  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
  // late AnimationController _controller;

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    // widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Here the end field will determine the size of buttons which will appear after sliding
    //If you need to appear them at the beginning, you need to change to "+" Offset coordinates (0.2, 0.0)
    final animation = Tween(begin: const Offset(0.0, 0.0), end: const Offset(-0.3, 0.0))
        .animate(CurveTween(curve: Curves.decelerate).animate(widget.controller));

    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          //Here we set value of Animation controller depending on our finger move in horizontal axis
          //If you want to slide to the right, change "-" to "+"
          widget.controller.value -= (data.primaryDelta! / (context.size!.width * 0.2));
        });
      },
      onHorizontalDragEnd: (data) {
        //To change slide direction, change to data.primaryVelocity! < -1500
        if (data.primaryVelocity! > 1500) {
          widget.controller.animateTo(.0);
        } else if (widget.controller.value >= .5 || data.primaryVelocity! < -1500) {
          widget.controller.animateTo(1.5);
        } else {
          widget.controller.animateTo(.0);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: [
              SlideTransition(
                position: animation,
                child: widget.child,
              ),
              AnimatedBuilder(
                animation: widget.controller,
                builder: (context, child) {
                  //To change slide direction to right, replace the right parameter with left:
                  return Positioned(
                    right: .0,
                    top: .0,
                    bottom: .0,
                    width: constraint.maxWidth * animation.value.dx * -.9,
                    child: Row(
                      children: widget.menuItems.map((child) => Expanded(child: child)).toList(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
