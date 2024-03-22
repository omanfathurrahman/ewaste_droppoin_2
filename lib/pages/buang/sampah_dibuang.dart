import 'package:ewaste_droppoin_2/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SampahDibuangPage extends StatefulWidget {
  const SampahDibuangPage({Key? key}) : super(key: key);

  @override
  State<SampahDibuangPage> createState() => _SampahDibuangPageState();
}

class _SampahDibuangPageState extends State<SampahDibuangPage> {
  Future<List<Map<String, dynamic>>> _getSampahDibuangList() async {
    final droppoinId = await _getDroppoinId();
    final response = await supabase
        .from('sampah_dibuang')
        .select('''
                    id,
                    status_dibuang,
                    profile(
                      nama_lengkap
                    )
        ''')
        .eq('status_dibuang', "Belum diserahkan")
        .eq('pilihan_antar_jemput', "diantar")
        .eq("droppoin_id", droppoinId);
    return response;
  }

  Future<num> _getDroppoinId() async {
    final response = await supabase
        .from('profile_droppoin')
        .select('id')
        .eq('email', supabase.auth.currentUser!.email!)
        .single()
        .limit(1);
    return response['id'];
  }

  Future<void> _konfirmasi(num id) async {
    await supabase
        .from('sampah_dibuang')
        .update({'status_dibuang': 'Sudah diserahkan'}).eq('id', id);
    final userId = (await supabase
        .from('sampah_dibuang')
        .select('id_user')
        .eq('id', id)
        .single()
        .limit(1))['id_user'];

    final jumlahSampahDibuangList = await supabase
        .from('detail_sampah_dibuang')
        .select('jumlah')
        .eq('id_sampah_dibuang', id);
    final jumlahSampahDibuang = jumlahSampahDibuangList
        .map((item) => item['jumlah'])
        .reduce((value, element) => value + element) as num;
    final jumlahPoin = await supabase
        .from('profile')
        .select('jumlah_poin')
        .eq('id', userId)
        .single()
        .limit(1);

    await supabase.from('profile').update({
      'jumlah_poin': jumlahPoin['jumlah_poin'] + jumlahSampahDibuang
    }).eq('id', userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          FutureBuilder(
            future: _getSampahDibuangList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              final listSampahDibuang = snapshot.data as List;

              if (listSampahDibuang.isEmpty)
                return const Center(
                    child: Text("Tidak ada sampah yang belum diterima"));

              return Column(
                children: listSampahDibuang
                    .map((itemSampahDibuang) => Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Id: ${itemSampahDibuang['id'].toString()}"),
                                    Text(itemSampahDibuang['profile']
                                        ['nama_lengkap']),
                                    const Text("Sampah belum diterima"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.orange[500]),
                                        onPressed: () {
                                          context.go(
                                              '/detailSampahDibuang/${itemSampahDibuang['id']}');
                                        },
                                        child: const Text('detail')),
                                    const SizedBox(height: 4),
                                    ElevatedButton(
                                      onPressed: () {
                                        _konfirmasi(itemSampahDibuang['id']);
                                      },
                                      child: const Text("Terima"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}


// Future<num> _getTotalJumlah(idSampahDibuang) async {
//   final jumlah = await supabase.from('detail_sampah_dibuang').select('jumlah').eq('id_sampah_dibuang', idSampahDibuang);
//   num jumlahSementara = 0;
//   for (var i = 0; i < jumlah.length; i++) {
//     jumlahSementara += jumlah[i]['jumlah'];
//   }
//   return jumlahSementara;
// }