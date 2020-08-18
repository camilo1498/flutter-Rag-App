import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';

/// Widget with markdown buttons
class MarkdownTextInput extends StatefulWidget {
  /// Callback called when text changed
  final Function onTextChanged;

  /// Initial value you want to display
  final String initialValue;

  /// Validator for the TextFormField
  final Function validators;

  /// String displayed at hintText in TextFormField
  final String label;

  /// Change the text direction of the input (RTL / LTR)
  final TextDirection textDirection;

  /// Constructor for [MarkdownTextInput]
  MarkdownTextInput(
      this.onTextChanged,
      this.initialValue, {
        this.label,
        this.validators,
        this.textDirection,
      });

  @override
  _MarkdownTextInputState createState() => _MarkdownTextInputState();
}

class _MarkdownTextInputState extends State<MarkdownTextInput> {
  final _controller = TextEditingController();

  void onTap(MarkdownType type, {int titleSize = 1}) {
    final basePosition = _controller.selection.baseOffset;

    final result = FormatMarkdown.convertToMarkdown(
        type, _controller.text, _controller.selection.baseOffset, _controller.selection.extentOffset,
        titleSize: titleSize);

    _controller.value = _controller.value
        .copyWith(text: result.data, selection: TextSelection.collapsed(offset: basePosition + result.cursorIndex));
  }

  @override
  void initState() {
    _controller.text = widget.initialValue;
    _controller.addListener(() {
      widget.onTextChanged(_controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        //Colors.grey[900],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: <Widget>[
          TextFormField(
            textInputAction: TextInputAction.newline,
            maxLines: null,
            controller: _controller,
            style: TextStyle(
              color: //Colors.white,
              Colors.grey[900],
            ),
            textCapitalization: TextCapitalization.sentences,
            validator: widget.validators != null ? (value) => widget.validators(value) as String : null,
            cursorColor:// Colors.grey[850],
              Colors.white,
            textDirection: widget.textDirection ?? TextDirection.ltr,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:// Colors.white,
              Colors.grey[900],)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color:// Colors.white,
              Colors.grey[900])),
              hintText: widget.label,
              hintStyle: const TextStyle(color: // Colors.grey[850],
              Colors.grey,),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
          Material(
              color:// Colors.white,
              Colors.grey[900],
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      key: const Key('bold_button'),
                      onTap: () => onTap(MarkdownType.bold),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.format_bold,
                          color: Colors.white,
                          //Colors.grey[900],
                        ),
                      ),
                    ),
                    InkWell(
                      key: const Key('italic_button'),
                      onTap: () => onTap(MarkdownType.italic),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.format_italic,
                          color: Colors.white,
                          //Colors.grey[900],
                        ),
                      ),
                    ),
                    for (int i = 1; i <= 6; i++)
                      InkWell(
                        key: Key('H${i}_button'),
                        onTap: () => onTap(MarkdownType.title, titleSize: i),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'H$i',
                            style: TextStyle(
                                fontSize: (18 - i).toDouble(),
                                fontWeight: FontWeight.w700,
                              color: Colors.white,
                              //Colors.grey[900],
                            ),
                          ),
                        ),
                      ),
                    InkWell(
                      key: const Key('link_button'),
                      onTap: () => onTap(MarkdownType.link),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.link,
                          color: Colors.white,
                          //Colors.grey[900],
                        ),
                      ),
                    ),
                    InkWell(
                      key: const Key('list_button'),
                      onTap: () => onTap(MarkdownType.list),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.list,
                          color: Colors.white,
                          //Colors.grey[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
