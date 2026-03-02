import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';

class TaskListSection extends StatefulWidget {
  final List<Task> tasks;
  final Function(int) onDelete;

  const TaskListSection({super.key, required this.tasks, required this.onDelete});

  @override
  State<TaskListSection> createState() => _TaskListSectionState();
}

class _TaskListSectionState extends State<TaskListSection> {
  
  @override
  Widget build(BuildContext context) {
    return Card(
      // start judul di task list
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_list_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Task list',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700
                    ),
                  )
              ],
            ),
            SizedBox(height: 12),
            if (widget.tasks.isEmpty)
             _buildEmptyState(context)  // kalo kosong
            else 
             _buildList(context) // kalo ada
          ],
        ),
      ),
    );
  }

  // meng handle ketika belum ada task
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column( // icon n teks itu column
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 42,
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: 8),
            Text(
              'Belum ada task',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }

 // ketika sudah ada ayay
  Widget _buildList(BuildContext context) {
    return SizedBox(
      height: 260,
      // nyimpen list dari task nya
      child: ListView.separated( 
        itemCount: widget.tasks.length, // mengambil semua data task
        // seperator : pemisah -> memberi jarak antar kotak list
        // anon function : (_, __) parameter privat yg dimiliki anon, nilai pv dan gak bernama
        separatorBuilder: (_, __) => SizedBox(height: 8),  
        // list tipe data array, jika ingin mengakses list kita pake index
        itemBuilder: (context, index) {
          final task = widget.tasks[index];

          return ListTile( 
            // nganu ui boxnya
            tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: CircleAvatar( // nganunya disebelah kiri -> macam profilenya gitu, angkanya
              radius: 14,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                '${index + 1}', // index = 0 -> jd tambah 1 = ini utk angka yang dikiri
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
            // manggil para deskripsinya itu
            title: Text(
              task.name,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${task.priority} | ${task.duration} min | ${task.deadline}'
            ),
            // icon disebelah kanan
            trailing: IconButton(
              icon: Icon(Icons.delete_outlined),
              onPressed: () => widget.onDelete(index),
            ),
          );
        }, 
      ),
    );
  }
}