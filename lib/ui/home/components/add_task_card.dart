import 'package:flutter/material.dart';
import 'package:schedule_generator_ai/models/task.dart';

class AddTaskCard extends StatefulWidget {
  final Function(Task) onAddTask;
  const AddTaskCard({super.key, required this.onAddTask});

  @override
  State<AddTaskCard> createState() => _AddTaskCardState();
}

class _AddTaskCardState extends State<AddTaskCard> {
  final taskController = TextEditingController();
  final durationController = TextEditingController();
  final deadlineController = TextEditingController();
  String? priority; // dropdown

  @override
  // menghilangkan catche
  void dispose() {
    taskController.dispose();
    durationController.dispose();
    deadlineController.dispose();
    super.dispose(); // menghilangkan TOTAL semua catche
  }

// for action when user submit the task
  void _submit() {
    // memastikan tidak ada yang kosong
    if (taskController.text.isNotEmpty &&
        durationController.text.isNotEmpty &&
        deadlineController.text.isNotEmpty &&
        priority != null) { // hrs terisi
  
      widget.onAddTask(Task(
          name: taskController.text,
          priority: priority!,
          duration: int.tryParse(durationController.text) ?? 5,
          deadline: deadlineController.text,
        ),
      );

      // utk ngebersihin catche yang bagian submit
      taskController.clear();
      durationController.clear();
      deadlineController.clear();
      setState(() => priority = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16), // value rata
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // agar komponennya manjang ngisi lebar maksimum kolom
          children: [ // dia akan berjejer sebagai row
            Row(
              children: [
                Icon(
                  Icons.playlist_add_check_circle_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 8), // krn dia row
                Text(
                  'Add Task',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith( // copy with : kalo mau msukin komponen lain
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            SizedBox(height: 12), //column
            TextField( // utk isiannya
              controller: taskController, // isi task name
              decoration: InputDecoration(
                labelText: 'Task name', 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.task_alt_rounded), // prefix : diawal komponen 
              ),
              textInputAction: TextInputAction.next, // biar bisa pindah" klo dipencet labelnya, nganu lah
            ),
             SizedBox(height: 12), 
            TextField( 
              controller: durationController, 
              decoration: InputDecoration(
                labelText: 'Duration (minute)', 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer_outlined),  
              ),
              keyboardType: TextInputType.number,  // mengubah keyboard jd angka
              textInputAction: TextInputAction.next, 
            ),
             SizedBox(height: 12), 
            TextField( 
              controller: deadlineController, 
              decoration: InputDecoration(
                labelText: 'Deadline', 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event_outlined),  
              ), 
              textInputAction: TextInputAction.done, // ada ceklis di keyboardnya, krn kita gabutuh utk next nya -> priority 
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>( // krn si dropdown isinya string semua 
              initialValue: priority, // teks awal sblm memilih
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              items: ['High', 'Medium', 'Low',]
              // manggilnya berdasarkan key value dr map
                .map((values) => DropdownMenuItem(value: values, child: Text(values))) 
              // dia meminta list dropdown
                .toList(),
              onChanged: (value) =>  setState(() => priority = value), // perubahan mengikuti value yang dipilih
            ),
            SizedBox(height: 16),
            // button add task (submit)
            FilledButton.icon(
              onPressed: _submit,
              icon: Icon(Icons.add_rounded),
              label: Text('Add Task'),
            )
          ],
        ),
      ),
    );
  }
}
