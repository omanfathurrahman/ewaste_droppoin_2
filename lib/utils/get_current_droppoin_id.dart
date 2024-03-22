import 'package:ewaste_droppoin_2/main.dart';

Future<num> getCurrentDroppoinId() async {
  final user = supabase.auth.currentUser;
  final userEmail = user?.email;
  final userDroppoinId = (await supabase.from('profile_droppoin').select('droppoin_id').eq('email', userEmail!).single().limit(1))['droppoin_id'] as num;
  return userDroppoinId;
}