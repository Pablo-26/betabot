import 'package:betabot/pages/chat_cansado.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BotonEmergencia extends StatelessWidget {
  const BotonEmergencia({super.key});

  void _callEmergency() async {
    const emergencyNumber = 'tel:+593989976281';
    if (await canLaunch(emergencyNumber)) {
      await launch(emergencyNumber);
    } else {
      throw 'No se puede realizar la llamada al número $emergencyNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color(0xFFF6F6F6),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              '¿Necesita ayuda de emergencia?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Solo mantén presionado el botón para llamar',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _callEmergency,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 120, 52, 1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFB0A8AC),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.emergency_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              '¿No sabes qué hacer?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  OptionButton(
                    text: 'Me siento cansado y sediento.',
                    image: 'images/cansado.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatCansado(), // Reemplaza con tu página
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  OptionButton(
                    text: 'He tenido una herida',
                    image: 'images/herido.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatCansado(), // Reemplaza con tu página
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  OptionButton(
                    text: 'Me siento mal emocionalmente',
                    image: 'images/triste.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatCansado(), // Reemplaza con tu página
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onTap; // Parámetro para la acción onTap

  const OptionButton({
    super.key,
    required this.text,
    required this.image,
    required this.onTap, // Aceptar la función onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Asociamos la acción de navegación
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          width: 250,
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Allow the text to wrap to the next line if it's too long
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2, // Allow two lines of text
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.orange,
                    size: 60,
                  ),
                  Image.asset(image),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


