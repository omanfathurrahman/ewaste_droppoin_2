import 'package:ewaste_droppoin_2/main.dart';

Future<String> getUserId() async {
  final response = supabase.auth.currentUser!.id;
  return response;
}

Future<String> getUserFullname() async {
  final userId = supabase.auth.currentUser!.id;
  final res = await supabase.from("profile_droppoin").select('nama').eq("user_id", userId).single().limit(1);
  final response = res['nama'] as String;
  return response;
}

Future<String> getUserEmail() async {
  final response = supabase.auth.currentUser!.email!;
  return response;
}

Future<num> getUserDroppoinId() async {
  final userId = supabase.auth.currentUser!.id;
  final res = await supabase.from("profile_droppoin").select('droppoin_id').eq("user_id", userId).single().limit(1);
  final response = res['droppoin_id'] as num;
  return response;
}


Future<String> getDroppoinName() async {
  final droppoinId = await getUserDroppoinId();
  final res = await supabase.from("daftar_droppoin").select('nama').eq("id", droppoinId).single().limit(1);
  final namaDroppoin = res['nama'] as String;
  return namaDroppoin;
}

Future<String> getDroppoinAlamat() async {
  final droppoinId = await getUserDroppoinId();
  final res = await supabase.from("daftar_droppoin").select('alamat').eq("id", droppoinId).single().limit(1);
  final alamatDroppoin = res['alamat'] as String;
  return alamatDroppoin;
}

Future<num> getBanksampahId() async {
  final droppoinId = await getUserDroppoinId();
  final res = await supabase.from("daftar_droppoin").select('banksampah_id').eq("id", droppoinId).single().limit(1);
  final banksampahId = res['banksampah_id'] as num;
  return banksampahId;
}

Future<String> getBanksampahName() async {
  final banksampahId = await getBanksampahId();
  final res = await supabase.from("daftar_banksampah").select('nama').eq("id", banksampahId).single().limit(1);
  final namaBanksampah = res['nama'] as String;
  return namaBanksampah;
}




