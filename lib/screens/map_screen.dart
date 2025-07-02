import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/report.dart';
import 'report_detail_screen.dart';

class Shelter {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int capacity;

  Shelter(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude,
      required this.capacity});
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController? _mapController;
  List<Marker> _markers = [];
  List<Marker> _shelterMarkers = [];

  ReportCategory? _selectedCategory;
  bool _showProblems = true;
  bool _showShelters = true;

  // Центр карты (Москва)
  static const LatLng _initialPoint = LatLng(55.751244, 37.618423);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadMarkers();
  }

  void _loadMarkers() {
    // Демонстрационные данные репортов
    final reports = [
      Report(
        id: '1',
        title: 'Разбитая дорога на ул. Ленина',
        description:
            'Большая яма на дороге, мешает проезду транспорта. Глубина ямы около 30 см, может повредить автомобили.',
        category: ReportCategory.road,
        status: ReportStatus.inProgress,
        latitude: 55.751244,
        longitude: 37.618423,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updatedAt: DateTime.now().subtract(Duration(hours: 5)),
        photoUrl: 'https://picsum.photos/400/300?random=1',
        reporterName: 'Иван Петров',
        priority: ReportPriority.medium,
      ),
      Report(
        id: '2',
        title: 'Не работает фонарь во дворе',
        description:
            'Фонарь не горит уже неделю, темно во дворе. Опасно для детей и пожилых людей в вечернее время.',
        category: ReportCategory.lighting,
        status: ReportStatus.new_,
        latitude: 55.752244,
        longitude: 37.619423,
        createdAt: DateTime.now().subtract(Duration(hours: 3)),
        updatedAt: DateTime.now().subtract(Duration(hours: 3)),
        photoUrl: 'https://picsum.photos/400/300?random=2',
        reporterName: 'Мария Сидорова',
        priority: ReportPriority.low,
      ),
      Report(
        id: '3',
        title: 'Мусор не вывозят',
        description:
            'Контейнеры переполнены, мусор не вывозят 3 дня. Запах и антисанитария во дворе.',
        category: ReportCategory.garbage,
        status: ReportStatus.completed,
        latitude: 55.753244,
        longitude: 37.620423,
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        photoUrl: 'https://picsum.photos/400/300?random=3',
        reporterName: 'Пётр Волков',
        priority: ReportPriority.high,
      ),
      Report(
        id: '4',
        title: 'Сломанное освещение в подъезде',
        description:
            'Лампочки в подъезде не работают, темно и опасно для жильцов.',
        category: ReportCategory.lighting,
        status: ReportStatus.new_,
        latitude: 55.754244,
        longitude: 37.621423,
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(Duration(hours: 2)),
        photoUrl: 'https://picsum.photos/400/300?random=11',
        reporterName: 'Михаил Соколов',
        priority: ReportPriority.medium,
      ),
      Report(
        id: '5',
        title: 'Яма на тротуаре',
        description:
            'Большая яма на тротуаре, люди могут споткнуться и упасть.',
        category: ReportCategory.road,
        status: ReportStatus.inProgress,
        latitude: 55.755244,
        longitude: 37.622423,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updatedAt: DateTime.now().subtract(Duration(hours: 8)),
        photoUrl: 'https://picsum.photos/400/300?random=12',
        reporterName: 'Наталья Морозова',
        priority: ReportPriority.high,
      ),
    ];

    _markers = reports.map((report) {
      return Marker(
        point: LatLng(report.latitude, report.longitude),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _openReportDetail(report),
          child: Container(
            decoration: BoxDecoration(
              color: _getCategoryColor(report.category),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              _getCategoryIcon(report.category),
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    }).toList();

    // Демонстрационные данные укрытий
    final shelters = [
      {
        'id': 's1',
        'name': 'Бомбоубежище №1',
        'lat': 55.754244,
        'lng': 37.621423
      },
      {
        'id': 's2',
        'name': 'Подземный переход',
        'lat': 55.755244,
        'lng': 37.622423
      },
      {
        'id': 's3',
        'name': 'Метро "Красная площадь"',
        'lat': 55.756244,
        'lng': 37.623423
      },
    ];

    _shelterMarkers = shelters.map((shelter) {
      return Marker(
        point: LatLng(shelter['lat'] as double, shelter['lng'] as double),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => _showShelterInfo(shelter['name'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              Icons.security,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _openReportDetail(Report report) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportDetailScreen(report: report),
      ),
    );
  }

  void _showShelterInfo(String shelterName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Укрытие'),
        content: Text(
            '$shelterName\n\nЭто безопасное место для укрытия в случае чрезвычайной ситуации.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(ReportCategory category) {
    switch (category) {
      case ReportCategory.road:
        return Colors.orange;
      case ReportCategory.lighting:
        return Colors.yellow;
      case ReportCategory.garbage:
        return Colors.green;
      case ReportCategory.shelter:
        return Colors.blue;
      case ReportCategory.other:
        return Colors.purple;
    }
  }

  IconData _getCategoryIcon(ReportCategory category) {
    switch (category) {
      case ReportCategory.road:
        return Icons.directions_car;
      case ReportCategory.lighting:
        return Icons.lightbulb;
      case ReportCategory.garbage:
        return Icons.delete;
      case ReportCategory.shelter:
        return Icons.home;
      case ReportCategory.other:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Карта города'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialPoint,
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.smart_city_app',
              ),
              if (_showProblems) MarkerLayer(markers: _markers),
              if (_showShelters) MarkerLayer(markers: _shelterMarkers),
            ],
          ),
          // Легенда
          Positioned(
            top: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Обозначения',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.orange, size: 16),
                        SizedBox(width: 4),
                        Text('Дороги', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.yellow, size: 16),
                        SizedBox(width: 4),
                        Text('Освещение', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text('Мусор', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.blue, size: 16),
                        SizedBox(width: 4),
                        Text('Укрытия', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Фильтры карты'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text('Показать проблемы'),
              value: _showProblems,
              onChanged: (value) {
                setState(() {
                  _showProblems = value ?? true;
                });
                Navigator.pop(context);
              },
            ),
            CheckboxListTile(
              title: Text('Показать укрытия'),
              value: _showShelters,
              onChanged: (value) {
                setState(() {
                  _showShelters = value ?? true;
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            Text('Категории проблем:'),
            ...ReportCategory.values.map((category) {
              return CheckboxListTile(
                title: Text(_getCategoryString(category)),
                value:
                    _selectedCategory == null || _selectedCategory == category,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value == true ? category : null;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  String _getCategoryString(ReportCategory category) {
    switch (category) {
      case ReportCategory.road:
        return 'Дороги';
      case ReportCategory.lighting:
        return 'Освещение';
      case ReportCategory.garbage:
        return 'Мусор';
      case ReportCategory.shelter:
        return 'Укрытия';
      case ReportCategory.other:
        return 'Другое';
    }
  }
}
