import 'package:berbe/constants/app_colors.dart';
import 'package:berbe/constants/app_size.dart';
import 'package:berbe/constants/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WidgetCommonTextField extends GetView {
  TextEditingController textEditingController;
  TextStyle textStyle;
  TextInputType inputType;
  TextInputAction inputAction;
  bool isObscureText;
  bool isPasswordFiled;
  EdgeInsets? paddingContainer;
  InputDecoration inputDecoration;
  Widget? prefixWidget;
  Widget? postfixWidget;
  bool? isEditable;
  int? textLimit;
  Function? onTextChanged;
  Function? onActionClick;
  Iterable<String>? autoFillHint;

  WidgetCommonTextField(
      {Key? key,
      required this.textEditingController,
      required this.inputDecoration,
      required this.textStyle,
      required this.inputType,
      required this.inputAction,
      this.isObscureText = false,
      this.isPasswordFiled = false,
      this.paddingContainer,
      this.prefixWidget,
      this.postfixWidget,
      this.isEditable = true,
      this.textLimit,
      this.onTextChanged,
      this.onActionClick,
      this.autoFillHint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: size_22, horizontal: size_24),
      decoration: BoxDecoration(
          color: colorFieldBG.withOpacity(0.5),
          borderRadius: BorderRadius.circular(size_10),
          border: Border.all(
              color: colorFieldBorder.withOpacity(0.18), width: size_1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          prefixWidget == null ? Container() : prefixWidget!,
          SizedBox(
            width: prefixWidget != null ? 14.0 : 0.0,
          ),
          Expanded(
              child: TextFormField(
            controller: textEditingController,
            textAlign: TextAlign.start,
            enabled: isEditable,
            maxLines: inputAction == TextInputAction.newline ? 4 : 1,
            minLines: 1,
            maxLength: textLimit ?? TextField.noMaxLength,
            decoration: inputDecoration.copyWith(
              border: InputBorder.none,
              isDense: true,
              counterText: "",
              counter: null,
              contentPadding: const EdgeInsets.all(size_0),
            ),
            style: textStyle,
            keyboardType: inputType,
            obscureText: isObscureText,
            enableInteractiveSelection: !isPasswordFiled,
            textInputAction: inputAction,
            textCapitalization:
                inputType == TextInputType.emailAddress || isPasswordFiled
                    ? TextCapitalization.none
                    : TextCapitalization.sentences,
            inputFormatters: inputType == TextInputType.number
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ]
                : inputType == TextInputType.text && !isPasswordFiled
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ]
                    : <TextInputFormatter>[],
            onChanged: (value) {
              if (onTextChanged != null) {
                onTextChanged!();
              }
            },
            onFieldSubmitted: (value) {
              if (onActionClick != null) {
                onActionClick!();
              }
            },
            autofillHints: autoFillHint,
          )),
          SizedBox(
            width: postfixWidget != null ? 14.0 : 0.0,
          ),
          postfixWidget == null ? Container() : postfixWidget!,
        ],
      ),
    );
  }
}
