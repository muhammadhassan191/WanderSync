import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wandersync/modules/checklist/bloc/checklist_bloc.dart';
import 'package:wandersync/modules/checklist/models/checklist_item.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trip Prep Toolkit',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Add new item...',
                      hintStyle: const TextStyle(color: Colors.white30),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) => _addItem(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 40),
                  color: Theme.of(context).primaryColor,
                  onPressed: _addItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ChecklistBloc, ChecklistState>(
              builder: (context, state) {
                if (state is ChecklistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChecklistLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return _buildChecklistItem(context, item);
                    },
                  );
                }
                return const Center(child: Text('Get ready for your next adventure!'));
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      context.read<ChecklistBloc>().add(AddChecklistItemRequested(_controller.text));
      _controller.clear();
    }
  }

  Widget _buildChecklistItem(BuildContext context, ChecklistItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: item.isCompleted ? Colors.white.withOpacity(0.02) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          item.isCompleted ? Icons.check_circle : Icons.circle_outlined,
          color: item.isCompleted ? Theme.of(context).colorScheme.secondary : Colors.white24,
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: item.isCompleted ? Colors.white30 : Colors.white,
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        onTap: () {
          context.read<ChecklistBloc>().add(ToggleChecklistItemRequested(item));
        },
      ),
    );
  }
}
