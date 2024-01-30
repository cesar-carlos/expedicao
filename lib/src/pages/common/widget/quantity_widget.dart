import 'package:flutter/material.dart';

import 'package:number_text_input_formatter/number_text_input_formatter.dart';

class QuantityWidget extends StatelessWidget {
  final bool viewMode;

  final FocusNode qtdFocusNode;
  final TextEditingController qtdController;
  final Function(String value) onSubmittedQtd;

  const QuantityWidget({
    super.key,
    required this.viewMode,
    required this.qtdController,
    required this.qtdFocusNode,
    required this.onSubmittedQtd,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: viewMode,
      cursorHeight: 22,
      controller: qtdController,
      focusNode: qtdFocusNode,
      onSubmitted: onSubmittedQtd,
      keyboardType: TextInputType.number,
      inputFormatters: [
        NumberTextInputFormatter(
          integerDigits: 10,
          decimalDigits: 3,
          decimalSeparator: ',',
          groupDigits: 3,
          groupSeparator: '.',
          allowNegative: false,
          overrideDecimalPoint: true,
          insertDecimalPoint: false,
          insertDecimalDigits: true,
        ),
      ],
      textAlign: TextAlign.right,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 10, right: 10),
        border: OutlineInputBorder(),
        labelText: 'Quantidade',
        labelStyle: TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
    );
  }
}
