import 'package:ewaste_droppoin_2/pages/after_login_layout.dart';
import 'package:ewaste_droppoin_2/pages/auth/login.dart';
import 'package:ewaste_droppoin_2/pages/auth/signup.dart';
import 'package:ewaste_droppoin_2/pages/buang/riwayat/riwayat_buang.dart';
import 'package:ewaste_droppoin_2/pages/donasi/detail/detail_sampah_didonasikan.dart';
import 'package:ewaste_droppoin_2/pages/donasi/riwayat/riwayat_donasi.dart';
import 'package:ewaste_droppoin_2/pages/donasi/sampah_didonasikan.dart';
import 'package:ewaste_droppoin_2/pages/buang/detail/detail_sampah_dibuang.dart';
import 'package:ewaste_droppoin_2/pages/landing_page.dart';
import 'package:ewaste_droppoin_2/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
    url: 'https://oexltokstwraweaozqav.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9leGx0b2tzdHdyYXdlYW96cWF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ1NjM5OTEsImV4cCI6MjAyMDEzOTk5MX0.4IB_1dfaBU6Ew-CtE4Uvs2Pmfd5SPi1Lan1oe5PSwIU',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const IndexPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: 'signUp',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: 'afterLoginLayout',
          builder: (context, state) => const AfterLoginLayout(),
        ),
        GoRoute(
          path: 'detailSampahDibuang/:sampahDibuangId',
          builder: (context, state) => DetailSampahDibuangPage(
            sampahDibuangId:
                int.parse(state.pathParameters['sampahDibuangId']!),
          ),
        ),
        GoRoute(
          path: 'detailSampahDidonasikan/:sampahDidonasikanId',
          builder: (context, state) => DetailSampahDidonasikanPage(
            sampahDidonasikanId:
                int.parse(state.pathParameters['sampahDidonasikanId']!),
          ),
        ),
        GoRoute(
          path: 'riwayat-buang',
          builder: (context, state) => const RiwayatBuangPage(),
        ),
        GoRoute(
          path: 'riwayat-donasi',
          builder: (context, state) => const RiwayatDonasiPage(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
