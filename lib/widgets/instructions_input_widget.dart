import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InstructionsInputWidget extends StatefulWidget {
  final Function(List<String> instructions) onInstructionsChanged;

  const InstructionsInputWidget({
    super.key,
    required this.onInstructionsChanged,
  });

  @override
  State<InstructionsInputWidget> createState() =>
      _InstructionsInputWidgetState();
}

class _InstructionsInputWidgetState extends State<InstructionsInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _instructions = [];
  // AnimatedList is complex with reordering, so we'll remove it for simplicity and robustness.
  // final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _addStep() {
    final newStep = _textController.text.trim();
    if (newStep.isEmpty) {
      return;
    }

    setState(() {
      // --- 1. FIX THE ORDERING ---
      // Use .add() to append the new step to the end of the list.
      _instructions.add(newStep);
      _textController.clear();
      widget.onInstructionsChanged(_instructions);
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _removeStep(int index) {
    setState(() {
      _instructions.removeAt(index);
      widget.onInstructionsChanged(_instructions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- Input Field and Add Button ---
        // This section with your UI changes is preserved.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _textController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Add an instruction step...',
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  labelStyle: GoogleFonts.livvic(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.5),
                  ),
                ),
                style: GoogleFonts.livvic(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 18),
                onFieldSubmitted: (_) => _addStep(),
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: ElevatedButton(
                onPressed: _addStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7700),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // --- List of Added Instructions ---
        if (_instructions.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _instructions.length,
              itemBuilder: (context, index) {
                // Your styled item is preserved.
                final step = _instructions[index];
                return Material(
                  key: ValueKey(step + index.toString()),
                  color: Colors.transparent,
                  child: ListTile(
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.more_horiz,
                              color: Colors.white70, size: 16),
                          Icon(Icons.more_horiz,
                              color: Colors.white70, size: 16),
                        ],
                      ),
                    ),
                    title: Text(
                      'Step ${index + 1}: $step',
                      style:
                          GoogleFonts.livvic(color: Colors.white, fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => _removeStep(index),
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final String item = _instructions.removeAt(oldIndex);
                  _instructions.insert(newIndex, item);
                  widget.onInstructionsChanged(_instructions);
                });
              },
              // --- 2. FIX THE DRAG BACKGROUND ---
              // Add the proxyDecorator to style the dragging widget.
              proxyDecorator:
                  (Widget child, int index, Animation<double> animation) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      // Use a slightly darker shade for the dragging item to distinguish it.
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: child,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
