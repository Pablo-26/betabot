import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GlucoseDashboard extends StatefulWidget {
  const GlucoseDashboard({super.key});

  @override
  State createState() => _GlucoseDashboardState();
}

class _GlucoseDashboardState extends State<GlucoseDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Control de Glucosa",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                // Tarjeta de Objetivo
                Expanded(
                  child: _buildObjectiveCard(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Tarjeta de Pastillas
                Expanded(
                  child: _buildPillCard(),
                ),
                const SizedBox(width: 16),
                // Tarjeta de Glucosa
                Expanded(
                  child: _buildGlucoseCard(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Gráfica de Nivel de Glucosa
            _buildGlucoseChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildObjectiveCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10.0, left: 16, right: 16, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Objetivo",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Indicador circular
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: CircularProgressIndicator(
                        value: 0.55,
                        strokeWidth: 18,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    ),
                    const Text("55%",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "11.5 GL",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 34),
                    ),
                    Text(
                      "de 20 GL",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 216, 167, 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "8.5 GL aún",
                        style: TextStyle(
                          color: Color.fromARGB(255, 252, 122, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pastillas",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.add_circle_outline, color: Colors.grey),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "3",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                ),
                Text(
                  "Tomadas",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlucoseCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Glucosa",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.water_drop_outlined, color: Colors.grey),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "150",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                ),
                Text(
                  "mg/dl",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlucoseChart() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nivel de Glucosa",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(
                    border: const Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5),
                      left: BorderSide(color: Colors.grey, width: 0.5),
                      right: BorderSide.none,
                      top: BorderSide.none,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          );
                          switch (value.toInt()) {
                            case 0:
                              return Text('Do', style: style);
                            case 1:
                              return Text('Lu', style: style);
                            case 2:
                              return Text('Ma', style: style);
                            case 3:
                              return Text('Mi', style: style);
                            case 4:
                              return Text('Ju', style: style);
                            case 5:
                              return Text('Vi', style: style);
                            case 6:
                              return Text('Sa', style: style);
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 100),
                        FlSpot(1, 120),
                        FlSpot(2, 140),
                        FlSpot(3, 150),
                        FlSpot(4, 110),
                        FlSpot(5, 130),
                        FlSpot(6, 125),
                      ],
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orange.withOpacity(0.2),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: 6,
                  minY: 90,
                  maxY: 160,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
