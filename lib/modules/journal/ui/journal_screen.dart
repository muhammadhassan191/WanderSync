import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wandersync/modules/journal/bloc/journal_bloc.dart';
import 'package:wandersync/modules/feed/models/journal_entry.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Digital Passport',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<JournalBloc, JournalState>(
        builder: (context, state) {
          if (state is JournalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JournalLoaded) {
            if (state.journals.isEmpty) {
              return const Center(
                child: Text('Your passport is empty. Start your first journey!'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.journals.length,
              itemBuilder: (context, index) {
                final journal = state.journals[index];
                return _buildPassportEntry(context, journal);
              },
            );
          }
          return const Center(child: Text('Your journey begins here.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEntryDialog(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add_location_alt, color: Colors.white),
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    final destinationController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          'New Passport Entry',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: destinationController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Where did you go?',
                hintStyle: TextStyle(color: Colors.white30),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Tell us about it...',
                hintStyle: TextStyle(color: Colors.white30),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (destinationController.text.isNotEmpty) {
                context.read<JournalBloc>().add(
                      AddJournalEntryRequested(
                        destinationController.text,
                        noteController.text,
                      ),
                    );
                Navigator.pop(dialogContext);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            child: const Text('Add Entry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPassportEntry(BuildContext context, JournalEntry journal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      journal.destination,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(journal.timestamp),
                      style: const TextStyle(color: Colors.white30, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.airplane_ticket, color: Theme.of(context).primaryColor),
            ],
          ),
          if (journal.note.isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              journal.note,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}
