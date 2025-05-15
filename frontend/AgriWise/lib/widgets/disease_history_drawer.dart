import 'package:flutter/material.dart';

class DiseaseHistoryDrawer extends StatelessWidget {
  final List<dynamic> history;
  final Function(String) onHistoryItemTap;

  const DiseaseHistoryDrawer({
    Key? key,
    required this.history,
    required this.onHistoryItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: const Row(
              children: [
                Icon(Icons.history, size: 24),
                SizedBox(width: 10),
                Text(
                  'History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Recent',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: history.length ?? 0,
              itemBuilder: (context, index) {
                if (history.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'No history available',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  );
                }
                final reversedIndex = (history.length - 1) - index;
                final chat = history[reversedIndex];
                final title = '${chat['title']} ${chat['formattedDate']}';
                return ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  onTap: () {
                    onHistoryItemTap(chat['id']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
