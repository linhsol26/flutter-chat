import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/auth/presentation/user_screen.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
    this.roundedColor = Colors.transparent,
    this.onTap,
    this.type = AvatarType.normal,
    this.isNull = false,
    this.size = 58,
    this.isActive = false,
    this.imgUrl,
    this.borderWidth = 1,
  }) : super(key: key);

  final Color roundedColor;
  final void Function()? onTap;
  final AvatarType type;
  final bool isNull;
  final double size;
  final bool isActive;
  final String? imgUrl;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: borderWidth, color: roundedColor),
            ),
            child: type == AvatarType.plus
                ? const Icon(Icons.add_box_rounded)
                : CircleAvatar(
                    radius: size,
                    backgroundColor: isNull ? Colors.transparent : null,
                    backgroundImage: isNull ? null : Image.network(imgUrl ?? defaultAvatar).image,
                    onBackgroundImageError: isNull ? null : (exception, stackTrace) => 'X',
                  ),
          ),
          if (type == AvatarType.plus)
            const Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                CupertinoIcons.plus_circle_fill,
                color: Colors.grey,
                size: 18.0,
              ),
            ),
          if (isActive)
            const Positioned(
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}

enum AvatarType { plus, normal }
