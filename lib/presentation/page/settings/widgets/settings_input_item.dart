import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsInputItem extends HookWidget {
  const SettingsInputItem({
    required this.controller,
    required this.label,
    required this.onChanged,
    required this.isEditable,
    required this.validator,
    required this.onClear,
    this.onTap,
    this.isFormFocused = false,
    this.onSubmitted,
    this.initialInput,
    this.textCapitalization,
  });
  final TextEditingController controller;
  final String label;
  final String? initialInput;
  final bool isEditable;
  final bool isFormFocused;
  final Function(String inputText) onChanged;
  final VoidCallback onClear;
  final VoidCallback? onTap;
  final VoidCallback? onSubmitted;
  final FormFieldValidator<String> validator;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: isEditable,
      autocorrect: false,
      key: ValueKey(label),
      controller: controller,
      onChanged: (value) => onChanged(value),
      style: AppTypography.b2Regular.copyWith(
        color: isEditable ? AppColors.textPrimary : AppColors.neutralGrey,
      ),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightGrey,
        hintText: label,
        hintStyle: AppTypography.b2Regular.copyWith(color: AppColors.textGrey),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: AppColors.textPrimary),
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        ),
        contentPadding: const EdgeInsets.all(AppDimens.m),
        suffixIcon: isEditable && isFormFocused
            ? GestureDetector(
                onTap: () {
                  controller.clear();
                  onClear();
                },
                child: SvgPicture.asset(
                  AppVectorGraphics.clearText,
                  height: AppDimens.xs,
                  fit: BoxFit.scaleDown,
                ),
              )
            : null,
      ),
      maxLines: 1,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.none,
      onSubmitted: (value) {
        onSubmitted?.call();
      },
      onTap: () {
        onTap?.call();
      },
    );
  }
}
