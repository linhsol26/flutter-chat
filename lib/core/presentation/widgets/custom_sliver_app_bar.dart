import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:whatsapp_ui/core/presentation/theme/colors.dart';
import 'package:whatsapp_ui/core/presentation/widgets/avatar_widget.dart';
import 'package:whatsapp_ui/core/shared/extensions.dart';

class CustomSliverAppBar extends HookWidget {
  const CustomSliverAppBar({
    Key? key,
    required this.title,
    required this.leading,
    this.collapedHeight = 120.0,
    this.isCollapsed,
    this.isStartScroll,
    this.action,
    this.bottom,
  }) : super(key: key);

  final String title;
  final Widget leading;
  final Widget? action;
  final Widget? bottom;
  final double collapedHeight;
  final ValueListenable? isCollapsed;
  final ValueListenable? isStartScroll;

  bool get _collapsed => bottom != null && isCollapsed != null && isCollapsed!.value;
  bool get _nonCollapsed => bottom != null && isCollapsed != null && !isCollapsed!.value;

  @override
  Widget build(BuildContext context) {
    useListenable(isCollapsed);
    useListenable(isStartScroll);
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      snap: true,
      elevation: 0,
      collapsedHeight: collapedHeight,
      leadingWidth: 100,
      expandedHeight: _nonCollapsed ? context.preferredSize : null,
      leading: Padding(
        padding: const EdgeInsets.all(3.0),
        child: AnimatedOpacity(
          opacity: _collapsed ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: leading,
        ),
      ),
      title: AnimatedOpacity(
          opacity: _collapsed ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Text(title, style: context.p1.copyWith(color: whiteColor, fontSize: 20))),
      actions: [
        action != null
            ? Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: AnimatedOpacity(
                  opacity: _collapsed ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: action!,
                ),
              )
            : const AvatarWidget(
                roundedColor: Colors.transparent,
                isNull: true,
              ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        expandedTitleScale: 1.1,
        title: bottom,
      ),
    );
  }
}

extension BuildContextEx on BuildContext {
  get preferredSize => MediaQuery.of(this).size.height * 0.25;
}
