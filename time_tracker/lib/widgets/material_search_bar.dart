import 'package:flutter/material.dart';

class MaterialSearchBar extends StatefulWidget {
  const MaterialSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.autofocus = false,
  });

  final bool autofocus;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;

  @override
  State<MaterialSearchBar> createState() => _MaterialSearchBarState();
}

class _MaterialSearchBarState extends State<MaterialSearchBar> {
  final FocusNode textFieldFocus = FocusNode();

  late Widget prefixIcon;
  late bool showClearButton;

  @override
  void initState() {
    super.initState();
    showClearButton = widget.autofocus;
    prefixIcon = widget.autofocus ? getPrefixIcon() : const Icon(Icons.search);
  }

  Widget getPrefixIcon() {
    return IconButton(
      onPressed: () {
        textFieldFocus.unfocus();
        setState(() {
          prefixIcon = const Icon(Icons.search);
          if (widget.controller == null || widget.controller!.text.isEmpty) {
            showClearButton = false;
          }
        });
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      focusNode: textFieldFocus,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(300),
          borderSide: BorderSide.none,
        ),
        filled: true,
        hintText: "Search icons",
        prefixIcon: prefixIcon,
        suffixIcon: showClearButton
            ? IconButton(
                onPressed: () {
                  textFieldFocus.unfocus();
                  setState(() {
                    prefixIcon = const Icon(Icons.search);
                    showClearButton = false;

                    widget.controller?.clear();
                    if (widget.onChanged != null) {
                      widget.onChanged!('');
                    }
                  });
                },
                icon: const Icon(Icons.clear),
              )
            : null,
      ),
      onTap: () {
        setState(() {
          showClearButton = true;
          prefixIcon = getPrefixIcon();
        });
      },
    );
  }
}
