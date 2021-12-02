import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsInputItem extends HookWidget {
  final String label;
  final String? initialInput;
  final bool isEditable;
  final bool isFormFocused;
  final Function(String inputText) onChanged;
  final Function() onClear;
  final Function() onTap;
  final FormFieldValidator<String> validator;
  final TextCapitalization? textCapitalization;

  const SettingsInputItem({
    required this.label,
    required this.onChanged,
    required this.isEditable,
    required this.isFormFocused,
    required this.validator,
    required this.onClear,
    required this.onTap,
    this.initialInput,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialInput);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.subH1Bold.copyWith(color: AppColors.settingsHeader),
        ),
        TextFormField(
          onTap: () => onTap(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          controller: controller,
          enabled: isEditable,
          style: AppTypography.input1Medium,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          onChanged: (value) => onChanged(value),
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
