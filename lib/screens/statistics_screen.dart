import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../l10n/app_localizations.dart';

class StatisticsScreen extends StatelessWidget {
  // Реальные данные
  final List<int> reportsPerDay = [
    12,
    18,
    15,
    20,
    17,
    22,
    19,
    21,
    23,
    19,
    18,
    20,
    22,
    25,
    27,
    30,
    28,
    26,
    24,
    22,
    20,
    18,
    17,
    15,
    14,
    13,
    12,
    11,
    10,
    9
  ]; // 30 дней
  final List<String> monthDays = List.generate(30, (i) => (i + 1).toString());
  final Map<String, int> reportCategories = {
    'Дороги': 120,
    'Освещение': 80,
    'Мусор': 60,
    'Укрытия': 30,
    'Другое': 25,
  };
  final Map<String, int> userRoles = {
    'Жители': 950,
    'Волонтёры': 42,
    'Администраторы': 7,
  };
  final Map<String, int> reportStatuses = {
    'Новые': 60,
    'В работе': 40,
    'Завершённые': 180,
    'Отклонённые': 35,
  };
  final List<int> volunteersTrend = [30, 32, 33, 35, 36, 38, 40, 41, 42];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.statistics),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsRow(),
            SizedBox(height: 24),
            Text('Динамика новых репортов за месяц',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 220, child: _buildLineChart()),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Распределение по категориям',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 180, child: _buildPieChart()),
                      _buildLegend(reportCategories.keys.toList(), [
                        Colors.blue,
                        Colors.orange,
                        Colors.green,
                        Colors.purple,
                        Colors.grey
                      ]),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Статусы репортов',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 180, child: _buildDonutChart()),
                      _buildLegend(reportStatuses.keys.toList(), [
                        Colors.blue,
                        Colors.orange,
                        Colors.green,
                        Colors.red
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Text('Активность пользователей по ролям',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 220, child: _buildBarChart()),
            _buildLegend(userRoles.keys.toList(),
                [Colors.blue, Colors.orange, Colors.red]),
            SizedBox(height: 32),
            Text('Тренд волонтёров за 9 месяцев',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 120, child: _buildMiniLineChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricCard(Icons.people, 'Пользователи', '12'),
        _buildMetricCard(Icons.report, 'Репорты', '335'),
        _buildMetricCard(Icons.volunteer_activism, 'Волонтёры', '42'),
        _buildMetricCard(Icons.timer, 'Сред. время решения', '2.3 дн'),
      ],
    );
  }

  Widget _buildMetricCard(IconData icon, String label, String value) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.blue.shade700),
              SizedBox(height: 8),
              Text(value,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900)),
              SizedBox(height: 4),
              Text(label,
                  style: TextStyle(fontSize: 13, color: Colors.blueGrey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int idx = value.toInt();
                if (idx % 5 == 0 && idx >= 0 && idx < monthDays.length) {
                  return Text(monthDays[idx]);
                }
                return Text('');
              },
              reservedSize: 24,
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 29,
        minY: 0,
        maxY: 40,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(reportsPerDay.length,
                (i) => FlSpot(i.toDouble(), reportsPerDay[i].toDouble())),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            dotData: FlDotData(show: false),
            belowBarData:
                BarAreaData(show: true, color: Colors.blue.withOpacity(0.15)),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final total = reportCategories.values.fold(0, (a, b) => a + b);
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.grey
    ];
    return PieChart(
      PieChartData(
        sections: List.generate(reportCategories.length, (i) {
          final entry = reportCategories.entries.elementAt(i);
          final percent = (entry.value / total * 100).toStringAsFixed(1);
          return PieChartSectionData(
            color: colors[i % colors.length],
            value: entry.value.toDouble(),
            title: '${percent}%',
            radius: 54,
            titleStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }),
        sectionsSpace: 2,
        centerSpaceRadius: 32,
      ),
    );
  }

  Widget _buildDonutChart() {
    final total = reportStatuses.values.fold(0, (a, b) => a + b);
    final colors = [Colors.blue, Colors.orange, Colors.green, Colors.red];
    return PieChart(
      PieChartData(
        sections: List.generate(reportStatuses.length, (i) {
          final entry = reportStatuses.entries.elementAt(i);
          final percent = (entry.value / total * 100).toStringAsFixed(1);
          return PieChartSectionData(
            color: colors[i % colors.length],
            value: entry.value.toDouble(),
            title: '${percent}%',
            radius: 54,
            titleStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            showTitle: true,
          );
        }),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildBarChart() {
    final colors = [Colors.blue, Colors.orange, Colors.red];
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1000,
        minY: 0,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int idx = value.toInt();
                if (idx >= 0 && idx < userRoles.length) {
                  return Text(userRoles.keys.elementAt(idx));
                }
                return Text('');
              },
              reservedSize: 32,
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        barGroups: List.generate(userRoles.length, (i) {
          final entry = userRoles.entries.elementAt(i);
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: colors[i % colors.length],
                width: 32,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMiniLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 8,
        minY: 0,
        maxY: 50,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(volunteersTrend.length,
                (i) => FlSpot(i.toDouble(), volunteersTrend[i].toDouble())),
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData:
                BarAreaData(show: true, color: Colors.orange.withOpacity(0.18)),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(List<String> labels, List<Color> colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        children: List.generate(
            labels.length,
            (i) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: colors[i % colors.length],
                            shape: BoxShape.circle)),
                    SizedBox(width: 6),
                    Text(labels[i], style: TextStyle(fontSize: 13)),
                  ],
                )),
      ),
    );
  }
}
