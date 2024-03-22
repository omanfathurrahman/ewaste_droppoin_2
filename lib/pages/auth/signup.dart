import 'package:ewaste_droppoin_2/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  num? droppoinId;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register(String nama, String email, String password) async {
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    await supabase.from("profile_droppoin").insert({
      "nama": nama,
      "email": email,
      "droppoin_id": droppoinId,
      "user_id": res.user!.id
    });
    await supabase.auth.signOut();
    if (!mounted) return;
    
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            shrinkWrap: true,
            reverse: true,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const Text('Daftar akunmu disini'),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              const Text("Droppoin:"),
              FutureBuilder(
                future: _getAllDroppoin(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final droppoinList = snapshot.data!;
                  return DropdownMenu(
                    onSelected: (value) {
                      setState(() {
                        droppoinId = value?['id'];
                      });
                    },
                    dropdownMenuEntries: droppoinList
                        .map((dropdownItem) => DropdownMenuEntry(
                            value: dropdownItem, label: dropdownItem['nama']))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Perform registration logic here
                    final name = _nameController.text;
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    _register(name, email, password);

                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    context.replace('/login');
                  },
                  child: const Text('Register'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun?'),
                  TextButton(
                    onPressed: () {
                      context.replace('/login');
                    },
                    child: const Text('Login'),
                  ),
                ],
              )
            ].reversed.toList(),
          ),
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> _getAllDroppoin() async {
  final response = await supabase.from('daftar_droppoin').select();
  return response;
}
