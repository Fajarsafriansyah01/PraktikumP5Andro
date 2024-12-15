import 'package:flutter/material.dart';
import 'konversi.dart';

class Konversi {
  static String indeksPrestasiSemester(double nilai) {
    if (nilai >= 0 && nilai <= 2.5) {
      return 'Tidak Memuaskan';
    } else if (nilai >= 2.6 && nilai < 3.0) {
      return 'Memuaskan';
    } else if (nilai >= 3.1 && nilai <= 3.5) {
      return 'Sangat Memuaskan';
    } else {
      return 'Dengan Pujian';
    }
  }

  static double sksMatkul(String grade) {
    return {
          'A': 4.0,
          'B+': 3.5,
          'B': 3.0,
          'C+': 2.0,
          'C': 1.5,
          'D': 1.0,
          'E': 0.0
        }[grade] ??
        0.0;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InputNilaiPage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}

class InputNilaiPage extends StatefulWidget {
  @override
  _InputNilaiPageState createState() => _InputNilaiPageState();
}

class _InputNilaiPageState extends State<InputNilaiPage> {
  final List<String> grades = ['A', 'B+', 'B', 'C+', 'C', 'D', 'E'];
  final List<String> mataKuliah = [
    'STATISTIK DAN PROBABILITAS',
    'INTERAKSI MANUSIA DAN KOMPUTER',
    'TEKNOLOGI MULTIMEDIA',
    'KECERDASAN BUATAN',
    'E-COMMERCE',
    'PEMROGRAMAN VISUAL 3',
    'TEKNIK KOMPILASI',
    'PEMROGRAMAN BERBASIS OBJEK 2',
    'REKAYASA PERANGKAT LUNAK',
    'ANALISIS DAN DESAIN SISTEM INFORMASI',
    'ANDROID',
    'PHP'
  ];

  final Map<String, String> nilaiMatkul = {};

  @override
  void initState() {
    super.initState();
    for (var mataKuliahName in mataKuliah) {
      nilaiMatkul[mataKuliahName] = 'A';
    }
  }

  void _hitungNilai() {
    double totalSks = nilaiMatkul.values
        .map((nilai) => Konversi.sksMatkul(nilai))
        .reduce((a, b) => a + b);
    double ipk = totalSks / nilaiMatkul.length;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HasilPage(totalSks: totalSks, ipk: ipk),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Nilai Matakuliah')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mataKuliah.length,
                itemBuilder: (context, index) {
                  String mataKuliahName = mataKuliah[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(mataKuliahName),
                      trailing: DropdownButton<String>(
                        value: nilaiMatkul[mataKuliahName],
                        items: grades
                            .map((grade) => DropdownMenuItem(
                                  value: grade,
                                  child: Text(grade),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            nilaiMatkul[mataKuliahName] = value ?? 'A';
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _hitungNilai,
                child: const Text('Hitung Nilai'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HasilPage extends StatelessWidget {
  final double totalSks;
  final double ipk;

  const HasilPage({required this.totalSks, required this.ipk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Perhitungan')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total SKS: $totalSks',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('IPK: ${ipk.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Predikat: ${Konversi.indeksPrestasiSemester(ipk)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
