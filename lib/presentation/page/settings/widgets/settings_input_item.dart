import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsInputItem extends HookWidget {
  final TextEditingController controller;
  final String label;
  final String? initialInput;
  final bool isEditable;
  final bool isFormFocused;
  final Function(String inputText) onChanged;
  final VoidCallback onClear;
  final VoidCallback onTap;
  final VoidCallback? onSubmitted;
  final FormFieldValidator<String> validator;
  final TextCapitalization? textCapitalization;

  const SettingsInputItem({
    required this.controller,
    required this.label,
    required this.onChanged,
    required this.isEditable,
    required this.isFormFocused,
    required this.validator,
    required this.onClear,
    required this.onTap,
    this.onSubmitted,
    this.initialInput,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
        ),
        TextFormField(
          key: ValueKey(initialInput),
          onTap: () => onTap(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          controller: controller,
          enabled: isEditable,
          style: AppTypography.b2Regular.copyWith(
            height: 2.02,
            letterSpacing: 0.15,
          ),
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          onChanged: (value) => onChanged(value),
          onFieldSubmitted: (value) {
            onSubmitted?.call();
          },
          decoration: InputDecoration(
            border: isEditable ? null : InputBorder.none,
            suffixIcon: isEditable && isFormFocused
                ? GestureDetector(
                    onTap: () {
                      controller.clear();
                      onClear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.sl),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.clear,
                          size: AppDimens.m,
                          color: AppColors.settingsIcon,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
