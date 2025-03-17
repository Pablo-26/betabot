import 'package:flutter/material.dart';

class ChatbotReceta extends StatelessWidget {
  const ChatbotReceta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(
            color: Colors.black), 
        title: Row(
          children: [
            Container(
              width: 50,
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                'images/logobetabot.png',
                fit: BoxFit.contain,
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BetaBot',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.more_horiz, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Chat Section
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    botMessage(
                        "Tu salud, mi prioridad. ¿En qué puedo asistirte?"),
                    const SizedBox(height: 10),
                    quickButtons(),
                    const SizedBox(height: 10),
                    userMessage("Agendar cita médica"),
                    const SizedBox(height: 10),
                    botMessage(
                      "Con gusto te ayudo. Para empezar, ¿tienes algun establecimiento médico de preferencia o prefieres que te siguera uno según tu ubicación?",
                    ),
                    const SizedBox(height: 10),
                    quickButtons2(),
                    const SizedBox(height: 10),
                    userMessage(
                        "Sugerencia según la ubicación"),
                  ],
                ),
              ),
            ),
          ),
          // Message Input Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Mensaje a Beta',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
                const Icon(Icons.mic_none, color: Colors.black54, size: 28),
                const SizedBox(width: 10),
                const Icon(Icons.image, color: Colors.black54, size: 28),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.send, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bot message widget
  Widget botMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // User message widget
  Widget userMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Quick action buttons
  Widget quickButtons() {
    return Column(
      children: [
        quickActionButton('Generar cita médica'),
        const SizedBox(height: 10),
        quickActionButton('Registrar mi receta'),
        const SizedBox(height: 10),
        quickActionButton('Educación en salud'),
      ],
    );
  }

    // Quick action buttons
  Widget quickButtons2() {
    return Column(
      children: [
        quickActionButton('Establecimiento médico de preferencia'),
        const SizedBox(height: 10),
        quickActionButton('Sugerencia según la ubicación             '),
        const SizedBox(height: 10),
        quickActionButton('Sugerencia según la ubicación             '),
      ],
    );
  }

  Widget quickActionButton(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
