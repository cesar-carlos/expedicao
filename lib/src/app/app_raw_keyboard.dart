import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Listener de teclado na API nova ([HardwareKeyboard]), com o mesmo
/// comportamento dos atalhos deste app.
///
/// O [KeyboardListener] só recebe teclas na cadeia de foco e perde F-keys
/// quando o foco está num TextField. Aqui o handler é global, mas só o
/// listener do topo da pilha (modal mais recente) recebe o evento. Se o
/// atalho for tratado ([KeyEventResult.handled]), o evento é consumido e
/// não chega na tela de trás.
class AppKeyboardListener extends StatefulWidget {
  const AppKeyboardListener({
    super.key,
    required this.focusNode,
    required this.onKey,
    required this.child,
    this.autofocus = false,
  });

  final FocusNode focusNode;
  final KeyEventResult Function(KeyEvent event) onKey;
  final Widget child;
  final bool autofocus;

  @override
  State<AppKeyboardListener> createState() => _AppKeyboardListenerState();
}

class _AppKeyboardListenerState extends State<AppKeyboardListener> {
  static final List<_AppKeyboardListenerState> _stack = [];
  static LogicalKeyboardKey? _consumedUntilKeyUp;

  @override
  void initState() {
    super.initState();
    _stack.add(this);
    if (_stack.length == 1) {
      HardwareKeyboard.instance.addHandler(_dispatch);
    }
  }

  @override
  void dispose() {
    _stack.remove(this);
    if (_stack.isEmpty) {
      HardwareKeyboard.instance.removeHandler(_dispatch);
      _consumedUntilKeyUp = null;
    }
    super.dispose();
  }

  static bool _dispatch(KeyEvent event) {
    if (_consumedUntilKeyUp != null &&
        event.logicalKey == _consumedUntilKeyUp) {
      if (event is KeyUpEvent) {
        _consumedUntilKeyUp = null;
      }
      return true;
    }

    if (_stack.isEmpty) {
      return false;
    }

    final result = _stack.last.widget.onKey(event);
    if (result == KeyEventResult.ignored) {
      return false;
    }

    // Engole KeyUp/Repeat da tecla já tratada pelo modal do topo, mesmo
    // depois dele fechar (ex.: Enter no "Quantidade excedida").
    if (event is KeyDownEvent) {
      _consumedUntilKeyUp = event.logicalKey;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      includeSemantics: true,
      child: widget.child,
    );
  }
}

typedef AppRawKeyEvent = KeyEvent;

bool isRawKeyDown(KeyEvent event) => event is KeyDownEvent;
