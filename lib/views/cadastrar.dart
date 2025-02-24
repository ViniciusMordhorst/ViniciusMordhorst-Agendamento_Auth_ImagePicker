import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastrar extends StatefulWidget {
  const Cadastrar({super.key});

  @override
  State<Cadastrar> createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  Future<void> _salvarForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Criando conta no Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text,
      );

      // Pegando o UID do usuário cadastrado
      String uid = userCredential.user!.uid;

      // Convertendo data de nascimento
      DateTime? dataNascimento;
      if (_dataNascimentoController.text.isNotEmpty) {
        dataNascimento = DateFormat("dd/MM/yyyy").parseStrict(_dataNascimentoController.text);
      }

      // Criando documento do usuário no Firestore
      await _firestore.collection('Usuario').doc(uid).set({
        'nome': _nomeController.text.trim(),
        'cpf': _cpfController.text.trim(),
        'email': _emailController.text.trim(),
        'dataNascimento': dataNascimento != null ? Timestamp.fromDate(dataNascimento) : null,
        'endereco': _enderecoController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuário cadastrado com sucesso!")),
      );

      Navigator.pop(context); // Fecha a tela de cadastro
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro inesperado ao cadastrar.")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _enderecoController.dispose();
    _senhaController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _abrirCalendario(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
    );
    if (data != null) {
      setState(() {
        _dataNascimentoController.text = DateFormat("dd/MM/yyyy").format(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: const Text('Cadastrar'),
        backgroundColor: Colors.blue[400],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                _buildTextField(_nomeController, "Nome", "Digite seu nome"),
                const SizedBox(height: 30.0),
                _buildTextField(_cpfController, "CPF", "Digite seu CPF", TextInputType.number),
                const SizedBox(height: 30.0),
                TextFormField(
                  controller: _dataNascimentoController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    hintText: 'dd/MM/yyyy',
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_month, color: Colors.blue[600]),
                      onPressed: () => _abrirCalendario(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Campo obrigatório';
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                _buildTextField(_emailController, "Email", "Digite seu email", TextInputType.emailAddress),
                const SizedBox(height: 30.0),
                _buildTextField(_enderecoController, "Endereço", "Digite seu endereço"),
                const SizedBox(height: 30.0),
                _buildTextField(_senhaController, "Senha", "Digite uma senha", TextInputType.visiblePassword, ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _salvarForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white70,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Enviar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, [
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  ]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        return null;
      },
    );
  }
}
