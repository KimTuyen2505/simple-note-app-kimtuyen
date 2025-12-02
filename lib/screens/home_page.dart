import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/note_card.dart';
import '../models/note.dart';
import 'note_editor_screen.dart';
import 'package:intl/intl.dart';
import '../utils/app_toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedTag = "All";
  DateTime? fromDate;
  DateTime? toDate;

  final List<String> tags = [
    "All",
    "Work",
    "Contacts",
    "Shopping",
    "Books",
    "Meeting",
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<NoteProvider>();
    final theme = context.watch<ThemeProvider>().isDark;
    final bg = theme ? const Color(0xFF101727) : Colors.white;
    final textColor = theme ? Colors.white : Colors.black;

    List<Note> notes = p.notes;

    if (selectedTag != "All") {
      notes = notes.where((n) => n.tag == selectedTag).toList();
    }

    if (fromDate != null) {
      notes = notes.where((n) => n.updatedAt.isAfter(fromDate!)).toList();
    }
    if (toDate != null) {
      notes = notes.where((n) => n.updatedAt.isBefore(toDate!)).toList();
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          'Simple Note App',
          style: TextStyle(color: textColor),
        ),
        actions: [
          GestureDetector(
            onTap: () => context.read<ThemeProvider>().toggle(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(theme ? "☀" : "🌙",
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                filled: true,
                fillColor: theme ? const Color(0xFF1B2435) : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: p.setSearch,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: selectedTag,
                  dropdownColor: theme ? const Color(0xFF1B2435) : Colors.white,
                  style: TextStyle(color: textColor),
                  items: tags
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => selectedTag = v!),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: fromDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (picked != null) setState(() => fromDate = picked);
                  },
                  child: Text(
                    fromDate == null
                        ? "From"
                        : DateFormat("dd/MM/yyyy").format(fromDate!),
                    style: TextStyle(color: textColor),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "-",
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: toDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (picked != null) setState(() => toDate = picked);
                  },
                  child: Text(
                    toDate == null
                        ? "To"
                        : DateFormat("dd/MM/yyyy").format(toDate!),
                    style: TextStyle(color: textColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: notes.isEmpty
                ? Center(
                    child: Text(
                      "No notes",
                      style: TextStyle(color: textColor.withOpacity(0.7)),
                    ),
                  )
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (_, i) {
                      final n = notes[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: NoteCard(
                          note: n,
                          onTap: () async {
                            if (n.locked && n.password != null) {
                              final ok = await _askPassword(context, n);
                              if (!ok) return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoteEditorScreen(existing: n),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3566CC),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
          );
        },
      ),
    );
  }

  Future<bool> _askPassword(BuildContext ctx, Note n) async {
    final controller = TextEditingController();
    String? errorText;

    return await showDialog<bool>(
          context: ctx,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: const Text("Enter password"),
                  content: TextField(
                    controller: controller,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      errorText: errorText,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        final input = controller.text;

                        if (input == n.password) {
                          AppToast.show("Unlocked successfully!");
                          Navigator.pop(context, true);
                        } else {
                          AppToast.show("Wrong password!");
                          setState(() {
                            errorText = "Password incorrect";
                          });
                        }
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false;
  }
}
