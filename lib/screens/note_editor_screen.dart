import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_toast.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? existing;
  const NoteEditorScreen({super.key, this.existing});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  String tag = 'Work';
  bool pinned = false;
  bool locked = false;

  @override
  void initState() {
    super.initState();
    final n = widget.existing;
    if (n != null) {
      titleCtrl.text = n.title;
      contentCtrl.text = n.content;
      tag = n.tag;
      pinned = n.pinned;
      locked = n.locked;
      passCtrl.text = n.password ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.read<NoteProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 60,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Text(
              '‹',
              style: TextStyle(
                color: textColor,
                fontSize: 26,
              ),
            ),
          ),
        ),
        title: Text(
          widget.existing == null ? 'New Note' : 'Edit Note',
          style: TextStyle(color: textColor),
        ),
        actions: [
          if (widget.existing != null)
            TextButton(
              onPressed: () async {
                final confirm = await _confirmDelete();
                if (!confirm) return;

                await p.remove(widget.existing!.id!);
                AppToast.show("Deleted successfully!");
                if (mounted) Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: textColor),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              style: TextStyle(color: textColor, fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                DropdownButton(
                  value: tag,
                  dropdownColor:
                      isDark ? const Color(0xFF1B2435) : Colors.white,
                  style: TextStyle(color: textColor),
                  items: const [
                    'Work',
                    'Contacts',
                    'Shopping',
                    'Books',
                    'Meeting'
                  ].map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => tag = v ?? tag),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    Checkbox(
                      value: pinned,
                      onChanged: (v) => setState(() => pinned = v ?? false),
                    ),
                    Text('Pin', style: TextStyle(color: textColor)),
                  ],
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Checkbox(
                      value: locked,
                      onChanged: (v) => setState(() => locked = v ?? false),
                    ),
                    Text('Lock', style: TextStyle(color: textColor)),
                  ],
                ),
              ],
            ),
            if (locked)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: passCtrl,
                  obscureText: true,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    filled: true,
                    fillColor:
                        isDark ? const Color(0xFF1B2435) : Colors.grey[200],
                  ),
                ),
              ),
            Expanded(
              child: TextField(
                controller: contentCtrl,
                maxLines: null,
                expands: true,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Enter your notes...',
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3566CC),
        child: const Text(
          'Save',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () async {
          final now = DateTime.now();
          final n = Note(
            id: widget.existing?.id,
            title: titleCtrl.text,
            content: contentCtrl.text,
            tag: tag,
            pinned: pinned,
            locked: locked,
            password: locked && passCtrl.text.isNotEmpty ? passCtrl.text : null,
            updatedAt: now,
          );
          if (widget.existing == null) {
            await p.add(n);
            AppToast.show("Note created!");
          } else {
            await p.edit(n);
            AppToast.show("Updated successfully!");
          }
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  Future<bool> _confirmDelete() async {
    return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Delete note?"),
            content: const Text("This action cannot be undone."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Delete")),
            ],
          ),
        ) ??
        false;
  }
}
