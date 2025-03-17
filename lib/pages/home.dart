import 'package:betabot/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name;
  final UserService userService = UserService();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  Future<void> _loadUserData() async {
    try {
      // Llama al servicio para obtener los datos del usuario
      Map<String, dynamic>? userData = await userService.getUserData();

      if (userData != null && mounted) {
        // Actualiza el estado para mostrar el nombre del usuario en la interfaz
        setState(() {
          name = userData['first_name'];
        });
      } else {
        print('No se pudieron obtener los datos del usuario.');
      }
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
        toolbarHeight: 20,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '¡Hola, $name!',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 32,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Banner Asistente
              Container(
                width: double.infinity,
                height: 104,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 253, 141, 89),
                      Color.fromARGB(255, 255, 117, 54),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child:
                            Image.asset('images/logobetabot.png', height: 40),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Beta, tu asistente, está\nlisto para ayudarte.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'chatbot');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 34,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Servicios
              const Text(
                'Servicios',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        serviceButton(
                          Icons.calendar_today,
                          'Calendario',
                          const Color(0xFFF6F6F6),
                          () {
                            Navigator.pushNamed(context, 'calendario');
                          },
                        ),
                        serviceButton(
                          Icons.medication,
                          'Gestión de medicinas',
                          const Color(0xFFF6F6F6),
                          () {
                            Navigator.pushNamed(context, 'chatbot');
                          },
                        ),
                        serviceButton(
                          Icons.bloodtype,
                          'Control de Glucosa',
                          const Color(0xFFF6F6F6),
                          () {
                            Navigator.pushNamed(context, 'control_glucosa');
                          },
                        ),
                        serviceButton(
                          Icons.meeting_room,
                          'Citas Médicas',
                          const Color(0xFFF6F6F6),
                          () {
                            Navigator.pushNamed(context, 'chatbot');
                          },
                        ),
                        serviceButton(
                          Icons.school,
                          'Educación y Apoyo',
                          const Color(0xFFF6F6F6),
                          () {
                            Navigator.pushNamed(context, 'chatbot');
                          },
                        ),
                        serviceButton(
                          Icons.warning_amber_rounded,
                          'Botón de Emergencia',
                          const Color(0xFFFFA83B),
                          () {
                            Navigator.pushNamed(context, 'boton_emergen');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Recordatorios
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recordatorios',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Ver todos >',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    reminderCard(
                      title: 'Próxima Cita Médica',
                      date: '29/01/2025',
                      time: '12:45 AM',
                      doctor: 'Dr. Juan Pérez',
                      color: Colors.blue.shade400,
                      icon: Icons.medical_services_rounded,
                    ),
                    const SizedBox(width: 10),
                    reminderCard(
                      title: 'Tomar Medicina',
                      subtitle: 'Metformina',
                      dosage: '500 mg',
                      time: '8:00 AM',
                      color: Colors.green.shade400,
                      icon: Icons.local_hospital_rounded,
                    ),
                    const SizedBox(width: 10),
                    reminderCard(
                      title: 'Ejercicio Diario',
                      subtitle: '30 minutos',
                      time: '6:00 PM',
                      color: Colors.orange.shade400,
                      icon: Icons.fitness_center_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para los botones de servicios
  Widget serviceButton(
      IconData icon, String title, Color backgroundColor, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.black54),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para los recordatorios
  Widget reminderCard({
    required String title,
    String? subtitle,
    String? date,
    String? time,
    String? doctor,
    String? dosage,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 240,
      height: 140, // Ancho fijo para asegurar el mismo tamaño
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        // Cambiado a Column para no expandir más de lo necesario
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Trunca texto si excede
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (subtitle != null)
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          if (date != null && time != null)
            Text(
              'Fecha: $date\nHora: $time',
              style: const TextStyle(color: Colors.white),
            ),
          if (doctor != null)
            Text(
              'Médico: $doctor',
              style: const TextStyle(color: Colors.white),
            ),
          if (dosage != null)
            Text(
              'Dosis: $dosage',
              style: const TextStyle(color: Colors.white),
            ),
        ],
      ),
    );
  }
}
