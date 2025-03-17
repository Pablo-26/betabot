import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final Gemini gemini = Gemini.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'BetaBot',
  );

  bool _isListening = false;
  String _voiceInput = '';
  late stt.SpeechToText _speech;

  @override
  void initState() {
    _speech = stt.SpeechToText();
    _loadMessagesFromFirebase('01');
    super.initState();
  }

  void _loadMessagesFromFirebase(String conversationId) async {
    try {
      // Accede a la subcolección 'messages' dentro de la colección 'conversations'
      final snapshot = await firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      // Procesa los mensajes y actualiza el estado
      setState(() {
        messages = snapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage(
            user: data['sender'] == '0' ? currentUser : geminiUser,
            text: data['content'],
            createdAt: (data['timestamp'] as Timestamp).toDate(),
          );
        }).toList();
      });
    } catch (e) {
      print('Error al cargar mensajes: $e');
    }
  }

  Future<void> _saveMessageToFirebase(
      String conversationId, ChatMessage chatMessage) async {
    try {
      await firestore
          .collection('conversations') // Colección principal
          .doc(conversationId) // Documento específico de la conversación
          .collection('messages') // Subcolección para los mensajes
          .add({
        'content': chatMessage.text, // Contenido del mensaje
        'read': false, // Por defecto, el mensaje no ha sido leído
        'sender': chatMessage.user.id, // Usuario que envió el mensaje
        'timestamp': FieldValue
            .serverTimestamp(), // Marca de tiempo automática de Firebase
        'type':
            'text', // Tipo del mensaje (puedes ajustarlo si hay otros tipos, como imágenes)
      });
    } catch (e) {
      print('Error saving message to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
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
        body: _buildUI());
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(
            Icons.image,
          ),
        ),
        IconButton(
          onPressed: _sendVoiceMessage,
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: _isListening
                ? Color.fromARGB(255, 255, 117, 54)
                : const Color.fromARGB(255, 64, 64, 64),
          ),
        ),
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: Color.fromARGB(255, 255, 117, 54),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    _saveMessageToFirebase('01', chatMessage);

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
        question = 'Imagen adjunta';
      }

      StringBuffer responseBuffer = StringBuffer();

      // Escucha el stream de respuesta del API de Gemini
      gemini
          .streamGenerateContent(
        question,
        images: images,
        generationConfig: GenerationConfig(
          maxOutputTokens: 100,
          temperature: 0.5,
          stopSequences: ['\n'],
        ),
      )
          .listen(
        (event) {
          event.content?.parts?.whereType<TextPart>().forEach((part) {
            responseBuffer.write(part.text + ' ');
          });
        },
        onDone: () {
          String response = responseBuffer.toString().trim();

          if (response.isNotEmpty) {
            ChatMessage botMessage = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response, // Elimina espacios en blanco adicionales
              customProperties: {
                'isMarkdown': true, // Indica que el mensaje es Markdown
              },
            );

            setState(() {
              messages = [botMessage, ...messages];
            });

            _saveMessageToFirebase('01', botMessage);
          }
        },
        onError: (error) {
          print('Error receiving response: $error');
        },
      );
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text:
            'Describe esta imagen de mi receta medica y recuerdame tomar mis medicamentos. Responde únicamente en español.',
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          ),
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _sendVoiceMessage() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech status: $status'),
        onError: (error) => print('Speech error: $error'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _voiceInput = result.recognizedWords;
            });
            if (result.finalResult && _voiceInput.trim().isNotEmpty) {
              _sendMessage(
                ChatMessage(
                  user: currentUser,
                  text: _voiceInput.trim(),
                  createdAt: DateTime.now(),
                ),
              );
              _speech.stop();
              setState(() {
                _isListening = false;
              });
            }
          },
          onSoundLevelChange: (level) {
            print('Sound level: $level');
          },
        );
      } else {
        _speech.stop();
        setState(() {
          _isListening = false;
        });
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();

      if (_voiceInput.trim().isNotEmpty) {
        ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: _voiceInput.trim(),
        );
        _sendMessage(chatMessage);
      }
      _voiceInput = '';
    }
  }

  // Bot message widget
  Widget botMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
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

  Widget quickActionButton(String title) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.orange,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Prescription Card
  Widget prescriptionCard() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Image.asset(
          'images/recetamed.png',
          width: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
