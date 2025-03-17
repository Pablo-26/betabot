import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calendario extends StatefulWidget {
  const Calendario({super.key});

  @override
  State<Calendario> createState() => _CalendarioState();
}

class _CalendarioState extends State<Calendario> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, String>>> _events = {};

  void _loadReminders() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Obtener los recordatorios del usuario actual
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('reminders')
        .get();

    // Mapear los recordatorios a un formato compatible con TableCalendar
    final Map<DateTime, List<Map<String, String>>> eventsMap = {};
    snapshot.docs.forEach((doc) {
      final data = doc.data();
      final DateTime reminderTime = (data['time'] as Timestamp).toDate();
      final String title = data['title'];
      final String description = data['description'];

      // Si ya existe un evento para este día, añadirlo a la lista
      final eventDate =
          DateTime(reminderTime.year, reminderTime.month, reminderTime.day);
      if (!eventsMap.containsKey(eventDate)) {
        eventsMap[eventDate] = [];
      }
      eventsMap[eventDate]?.add({
        'time': reminderTime.toString(),
        'title': title,
        'description': description,
      });
    });

    setState(() {
      _events.addAll(eventsMap);
    });
  }

  // Obtener los eventos para el día seleccionado
  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  // Modificar el número de eventos en los días (mostrar hasta 2 puntos)
  List<Widget> _eventMarkersForDay(DateTime day) {
    List<Map<String, String>> eventsForDay = _getEventsForDay(day);

    if (eventsForDay.length > 2) {
      return [
        Container(
          width: 10.0,
          height: 10.0,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 10.0,
          height: 10.0,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
        const Text('..')
      ]; // Mostrar hasta 2 puntos y '...' al final
    } else {
      return List.generate(eventsForDay.length, (index) {
        return Container(
          width: 10.0,
          height: 10.0,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        );
      });
    }
  }

  @override
  void initState() {
    _loadReminders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          'Calendario',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF6F6F6),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'es_ES', // Para mostrar en español
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return _selectedDay != null && isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return _getEventsForDay(
                  day); // Cargar eventos para el día seleccionado
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _eventMarkersForDay(day),
                ); // Mostrar puntos o '...'
              },
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible:
                  false, // Ocultar el botón de cambio de formato (día/semana/mes)
              titleCentered: true, // Centrar el título del mes
            ),
          ),
          const Divider(), // Línea separadora entre el calendario y la lista de eventos
          if (_selectedDay != null)
            Expanded(
              child: ListView.builder(
                itemCount: _getEventsForDay(_selectedDay!).length,
                itemBuilder: (context, index) {
                  final event = _getEventsForDay(_selectedDay!)[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0), // Espaciado externo
                    padding:
                        const EdgeInsets.all(10.0), // Relleno dentro del cuadro
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo del cuadro
                      borderRadius:
                          BorderRadius.circular(8), // Bordes redondeados
                      border: Border.all(
                        color: Colors.black, // Color del borde
                        width: 0.5, // Grosor del borde
                      ),
                    ),
                    height:
                        120, // Establece un tamaño fijo para cada contenedor de evento
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _formatTime(event['time']!),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(event['description']!),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    final parsedTime =
        DateTime.parse(time); // Convierte la cadena de hora a DateTime
    final formatter =
        DateFormat('dd/MM/yyy h:mm a'); // Formato de hora con AM/PM
    return formatter.format(parsedTime); // Formatea la hora y la devuelve
  }
}
