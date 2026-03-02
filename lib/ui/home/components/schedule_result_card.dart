import 'package:flutter/material.dart';

class ScheduleResultCard extends StatelessWidget {
  // utk ngubah semuanya agar bisa string, krn schedule string semua
  final String schedule;

  const ScheduleResultCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) return SizedBox.shrink();
    // kalo misal list of task ada isinya
    final lines = schedule // informasi yg akan digabungkan jadi 1
       .split('\n') // baris baru
       // menyimpan schedule biar ai efisien utk meng nganu itunya
       .map((line) => line.trim()) // menjadi key value. key : nama task, value : durasi, dkk
       .where((line) => line.isEmpty) // mana wadah yg kosong utk diisi sm result (menyeleksi data)
       .toList(); // miss match (1 tipe data ngga matching sm yang lain)

       return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Generated Schedule',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                // uk si container
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // list sdh dibungkus oleh lines (diatas)
                children: lines.map((line) { // map -> biar matching sm json ny
                   final isHeading = line.endsWith(";");
                   final isBullet = line.startsWith('-');

                   if (isBullet) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.circle, size: 6),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: SelectableText(
                              line.substring(2), // hanya ini yang bisa di select
                              style: Theme.of(context).textTheme.bodyMedium,

                            ),
                          )
                        ],
                      ),
                    );
                   }
                   return Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: SelectableText(
                      line,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isHeading ? FontWeight.w700 : FontWeight.w400,
                        height: 1.4
                      ),
                    ),
                   );
                }).toList()
                ),
              )
            ],
          ),
        ),
       );
  }
}
