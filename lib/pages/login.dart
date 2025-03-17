import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  var _ci = '';
  var _password = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      // Paso 1: Buscar el correo asociado a la cédula en Firestore
      final cedulaIngresada = _ci.trim(); // La cédula ingresada por el usuario
      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('users')
          .where('ci', isEqualTo: cedulaIngresada)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró un usuario con esa cédula.'),
          ),
        );
        return;
      }

      // Obtener el correo del documento encontrado
      final userDoc = querySnapshot.docs.first;
      final email = userDoc['email'];

      // Paso 2: Realizar la autenticación usando el correo y contraseña
      final userCredentials = await _firebase.signInWithEmailAndPassword(
        email: email,
        password: _password,
      );

      print('Inicio de sesión exitoso: ${userCredentials.user}');
    } on FirebaseAuthException catch (error) {
      // Manejar errores de autenticación
      if (error.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontró un usuario con esas credenciales.'),
          ),
        );
      } else if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña incorrecta.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.message}'),
          ),
        );
      }
    } catch (error) {
      // Manejar otros errores
      print('Error al intentar iniciar sesión: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error. Intenta nuevamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 127, 68),
              Color.fromARGB(255, 255, 117, 54),
              Color.fromARGB(255, 255, 117, 54),
            ],
            stops: [0.6, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'BetaBot',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'images/logobetabot.png',
                      height: 80,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Correo Electrónico Input
                        TextFieldContainer(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person, color: Colors.white),
                              hintText: "Cédula de Identidad",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.none,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor, ingrese su número de cédula';
                              }
                              if (value.length > 10 || value.length < 10) {
                                return 'Ingrese un numero de cédula válido';
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              _ci = newValue!;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFieldContainer(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.lock, color: Colors.white),
                              hintText: "Contraseña",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor, ingrese su contraseña';
                              }

                              return null;
                            },
                            onSaved: (newValue) {
                              _password = newValue!;
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Olvidaste tu contraseña
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Acción al olvidar contraseña
                            },
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        // Botón Ingresar
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submit();
                              }
                            },
                            child: const Text(
                              'INGRESAR',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 117, 54),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget reutilizable para Input Containers
class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 141, 70),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Color de la sombra
            offset: const Offset(0, 4), // Desplazamiento de la sombra
            blurRadius: 10, // Desenfoque
            spreadRadius: 2, // Difusión
          ),
        ],
      ),
      child: child,
    );
  }
}
