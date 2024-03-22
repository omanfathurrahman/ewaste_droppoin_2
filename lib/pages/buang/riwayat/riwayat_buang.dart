import 'package:ewaste_droppoin_2/main.dart';
import 'package:ewaste_droppoin_2/utils/get_current_droppoin_id.dart';
import 'package:ewaste_droppoin_2/utils/get_formated_date.dart';
import 'package:ewaste_droppoin_2/utils/get_fullname_pembuang_pendonasi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiwayatBuangPage extends StatefulWidget {
  const RiwayatBuangPage({super.key});

  @override
  State<RiwayatBuangPage> createState() => _RiwayatBuangPageState();
}

class _RiwayatBuangPageState extends State<RiwayatBuangPage> {
  Future<List<Map<String, dynamic>>> _getRiwayatBuangList() async {
    final userDroppoinId = await getCurrentDroppoinId();
    final riwayatKonfirmasiBuangList = await supabase
        .from('sampah_dibuang')
        .select()
        .eq(
          'droppoin_id',
          userDroppoinId,
        )
        .eq(
          'status_dibuang',
          'Sudah diserahkan',
        );
    return riwayatKonfirmasiBuangList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Konfirmasi Buang'),
          leading: BackButton(
            onPressed: () {
              context.go('/afterLoginLayout');
            },
          ),
        ),
        body: FutureBuilder(
          future: _getRiwayatBuangList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
            
            final riwayatBuangList =
                snapshot.data as List<Map<String, dynamic>>;
            if(riwayatBuangList.isEmpty) return const Center(child: Text('Tidak ada riwayat buang'));
            return ListView.builder(
              itemCount: riwayatBuangList.length,
              itemBuilder: (context, index) {
                final riwayatBuang = riwayatBuangList[index];
                return Card(
                  child: ListTile(
                    title: Text(riwayatBuang['id'].toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Tanggal: ${formatDateTime(riwayatBuang['created_at'] as String)}"),
                        FutureBuilder(
                            future: getFullnamePembuangPendonasi(
                                riwayatBuang['id_user']),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final fullnamePembuang = snapshot.data as String;
                              return Text("Nama: $fullnamePembuang");
                            })
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          },
        ));
  }
}
