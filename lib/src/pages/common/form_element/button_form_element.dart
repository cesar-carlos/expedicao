import 'package:flutter/material.dart';
import 'package:app_expedicao/src/app/app_color.dart';

// ignore: must_be_immutable
class ButtonFormElement extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  FocusNode? focusNode;

  ButtonFormElement({
    super.key,
    required this.name,
    this.onPressed,
    this.padding,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: OutlinedButton(
        onPressed: onPressed,
        focusNode: focusNode,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.focused))
                return AppColor.hoverColor;
              if (states.contains(WidgetState.hovered))
                return AppColor.hoverColor;
              if (states.contains(WidgetState.pressed))
                return AppColor.clickColor;
              return AppColor.backGroundButton;
            },
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            AppColor.backGroundButton,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: Color.fromARGB(255, 242, 244, 245),
          ),
        ),
      ),
    );
  }
}
