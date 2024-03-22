import 'package:ewaste_droppoin_2/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SampahDidonasikanPage extends StatefulWidget {
  const SampahDidonasikanPage({Key? key}) : super(key: key);

  @override
  State<SampahDidonasikanPage> createState() => _SampahDidonasikanPageState();
}

class _SampahDidonasikanPageState extends State<SampahDidonasikanPage> {
  Future<List<Map<String, dynamic>>> _getSampahDidonasikanList() async {
    final droppoinId = await _getDroppoinId();
    final response = await supabase
        .from('sampah_didonasikan')
        .select('''
                    id,
                    status_didonasikan,
                    profile(
                      nama_lengkap
                    )
                ''')
        .eq('status_didonasikan', "Belum diserahkan")
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
        .from('sampah_didonasikan')
        .update({'status_didonasikan': 'Sudah diserahkan'}).eq('id', id);
    final userId = (await supabase
        .from('sampah_didonasikan')
        .select('id_user')
        .eq('id', id)
        .single()
        .limit(1))['id_user'];

    final jumlahSampahdidonasikanList = await supabase
        .from('detail_sampah_didonasikan')
        .select('jumlah')
        .eq('id_sampah_didonasikan', id);
    final jumlahSampahdidonasikan = jumlahSampahdidonasikanList
        .map((item) => item['jumlah'])
        .reduce((value, element) => value + element) as num;
    final jumlahPoin = await supabase
        .from('profile')
        .select('jumlah_poin')
        .eq('id', userId)
        .single()
        .limit(1);

    await supabase.from('profile').update({
      'jumlah_poin': jumlahPoin['jumlah_poin'] + jumlahSampahdidonasikan
    }).eq('id', userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          FutureBuilder(
            future: _getSampahDidonasikanList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              final data = snapshot.data as List;
              if (data.isEmpty) {
                return const Center(
                    child: Text("Tidak ada sampah didonasikan"));
              }
              return Column(
                children: data
                    .map((itemSampahDidonasikan) => Card(
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
                                        "Id: ${itemSampahDidonasikan['id'].toString()}"),
                                    Text(itemSampahDidonasikan['profile']
                                        ['nama_lengkap']),
                                    const Text("Sampah belum diterima"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange[500],
                                        ),
                                        onPressed: () {
                                          context.go(
                                              '/detailSampahDidonasikan/${itemSampahDidonasikan['id']}');
                                        },
                                        child: const Text('detail')),
                                    const SizedBox(height: 4),
                                    ElevatedButton(
                                      onPressed: () {
                                        _konfirmasi(
                                            itemSampahDidonasikan['id']);
                                      },
                                      child: const Text("selesai"),
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
