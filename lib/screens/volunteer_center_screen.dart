import 'package:flutter/material.dart';
import 'package:smart_city_app/models/volunteer_event.dart';
import '../widgets/themed_image.dart';

class VolunteerCenterScreen extends StatefulWidget {
  const VolunteerCenterScreen({super.key});

  @override
  State<VolunteerCenterScreen> createState() => _VolunteerCenterScreenState();
}

class _VolunteerCenterScreenState extends State<VolunteerCenterScreen> {
  String _selectedFilter = 'Все';
  final List<String> _filters = [
    'Все',
    'Экология',
    'Безопасность',
    'Образование',
    'Медицина'
  ];

  final List<VolunteerEvent> _events = [
    VolunteerEvent(
      id: '1',
      title: 'Уборка парка "Зелёный"',
      description:
          'Приглашаем всех желающих принять участие в уборке парка. Будем собирать мусор, сажать деревья и обустраивать зоны отдыха.',
      date: DateTime.now().add(const Duration(days: 3)),
      location: 'Парк "Зелёный", ул. Ленина, 15',
      maxParticipants: 30,
      currentParticipants: 12,
      participants: ['user1', 'user2', 'user3'],
      organizerId: 'org1',
      organizerName: 'Экологическое сообщество',
      isActive: true,
    ),
    VolunteerEvent(
      id: '2',
      title: 'Патрулирование района',
      description:
          'Добровольное патрулирование района для обеспечения безопасности жителей. Обучение основам безопасности.',
      date: DateTime.now().add(const Duration(days: 1)),
      location: 'Район "Центральный"',
      maxParticipants: 15,
      currentParticipants: 8,
      participants: ['user4', 'user5'],
      organizerId: 'org2',
      organizerName: 'Совет безопасности района',
      isActive: true,
    ),
    VolunteerEvent(
      id: '3',
      title: 'Помощь пожилым людям',
      description:
          'Оказание помощи пожилым людям: покупка продуктов, уборка квартир, сопровождение в поликлинику.',
      date: DateTime.now().add(const Duration(days: 5)),
      location: 'Дом престарелых, ул. Мира, 25',
      maxParticipants: 10,
      currentParticipants: 5,
      participants: ['user6', 'user7'],
      organizerId: 'org3',
      organizerName: 'Волонтёрская служба "Доброе сердце"',
      isActive: true,
    ),
    VolunteerEvent(
      id: '4',
      title: 'Обучение компьютерной грамотности',
      description:
          'Бесплатные курсы компьютерной грамотности для людей старшего возраста.',
      date: DateTime.now().add(const Duration(days: 7)),
      location: 'Библиотека им. Пушкина',
      maxParticipants: 20,
      currentParticipants: 15,
      participants: ['user8', 'user9', 'user10'],
      organizerId: 'org4',
      organizerName: 'Центр цифрового образования',
      isActive: true,
    ),
    VolunteerEvent(
      id: '5',
      title: 'Посадка деревьев',
      description:
          'Массовая посадка деревьев в городском парке. Приглашаем всех желающих помочь озеленению города.',
      date: DateTime.now().add(const Duration(days: 10)),
      location: 'Городской парк культуры и отдыха',
      maxParticipants: 50,
      currentParticipants: 25,
      participants: ['user11', 'user12', 'user13'],
      organizerId: 'org1',
      organizerName: 'Экологическое сообщество',
      isActive: true,
    ),
    VolunteerEvent(
      id: '6',
      title: 'Помощь в приюте для животных',
      description:
          'Уход за животными, кормление, уборка территории приюта. Приглашаем любителей животных.',
      date: DateTime.now().add(const Duration(days: 2)),
      location: 'Приют "Дружок", ул. Животных, 8',
      maxParticipants: 12,
      currentParticipants: 6,
      participants: ['user14', 'user15'],
      organizerId: 'org5',
      organizerName: 'Приют для животных "Дружок"',
      isActive: true,
    ),
    VolunteerEvent(
      id: '7',
      title: 'Бесплатная юридическая консультация',
      description:
          'Оказание бесплатных юридических консультаций для малоимущих граждан.',
      date: DateTime.now().add(const Duration(days: 4)),
      location: 'Центр социальной помощи, ул. Правовая, 12',
      maxParticipants: 8,
      currentParticipants: 3,
      participants: ['user16'],
      organizerId: 'org6',
      organizerName: 'Центр правовой помощи',
      isActive: true,
    ),
    VolunteerEvent(
      id: '8',
      title: 'Уборка берега реки',
      description:
          'Экологическая акция по уборке берега реки от мусора. Защита водных ресурсов.',
      date: DateTime.now().add(const Duration(days: 6)),
      location: 'Набережная реки, ул. Набережная, 1',
      maxParticipants: 30,
      currentParticipants: 18,
      participants: ['user17', 'user18', 'user19'],
      organizerId: 'org1',
      organizerName: 'Экологическое сообщество',
      isActive: true,
    ),
  ];

  List<VolunteerEvent> get _filteredEvents {
    if (_selectedFilter == 'Все') {
      return _events;
    }
    return _events
        .where((event) => _getEventCategory(event) == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Волонтёрский центр'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // Статистика
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                    'Активных мероприятий', _events.length.toString()),
                _buildStatItem(
                    'Участников',
                    _events
                        .fold(
                            0, (sum, event) => sum + event.currentParticipants)
                        .toString()),
                _buildStatItem(
                    'Организаций',
                    _events
                        .map((e) => e.organizerName)
                        .toSet()
                        .length
                        .toString()),
              ],
            ),
          ),

          // Фильтры
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Список мероприятий
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return _buildEventCard(event);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateEventDialog();
        },
        icon: const Icon(Icons.add),
        label: const Text('Создать мероприятие'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Theme.of(context).iconTheme.color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Экология':
        return Colors.green;
      case 'Безопасность':
        return Colors.blue;
      case 'Образование':
        return Colors.purple;
      case 'Медицина':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEventCard(VolunteerEvent event) {
    final isParticipating = event.currentParticipants < event.maxParticipants;
    final progress = event.currentParticipants / event.maxParticipants;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: ThemedImage(
              title: event.title,
              type: 'volunteer',
              width: double.infinity,
              height: 150,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок и категория
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(_getEventCategory(event)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getEventCategory(event),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Описание
                Text(
                  event.description,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // Информация о мероприятии
                _buildInfoRow(Icons.calendar_today, _formatDate(event.date)),
                _buildInfoRow(Icons.location_on, event.location),
                _buildInfoRow(Icons.person, event.organizerName),

                const SizedBox(height: 16),

                // Прогресс участников
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Участники: ${event.currentParticipants}/${event.maxParticipants}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 1.0 ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Кнопки действий
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            isParticipating ? () => _joinEvent(event) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isParticipating
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          isParticipating ? 'Присоединиться' : 'Мест нет',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showEventDetails(event),
                      icon: const Icon(Icons.info_outline),
                      tooltip: 'Подробности',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Сегодня';
    } else if (difference == 1) {
      return 'Завтра';
    } else if (difference < 7) {
      return 'Через $difference дней';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  void _joinEvent(VolunteerEvent event) {
    setState(() {
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] =
            event.copyWith(currentParticipants: event.currentParticipants + 1);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Вы успешно присоединились к мероприятию "${event.title}"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showEventDetails(VolunteerEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Описание: ${event.description}'),
            const SizedBox(height: 8),
            Text('Дата: ${_formatDate(event.date)}'),
            Text('Место: ${event.location}'),
            Text('Организатор: ${event.organizerName}'),
            Text(
                'Участников: ${event.currentParticipants}/${event.maxParticipants}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showCreateEventDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final organizerController = TextEditingController();
    final maxParticipantsController = TextEditingController();
    String selectedCategory = 'Экология';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать мероприятие'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Название мероприятия',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Категория',
                  border: OutlineInputBorder(),
                ),
                items: _filters.where((f) => f != 'Все').map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Место проведения',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: organizerController,
                decoration: const InputDecoration(
                  labelText: 'Организатор',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxParticipantsController,
                decoration: const InputDecoration(
                  labelText: 'Максимум участников',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  locationController.text.isNotEmpty &&
                  organizerController.text.isNotEmpty &&
                  maxParticipantsController.text.isNotEmpty) {
                final newEvent = VolunteerEvent(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  date: selectedDate,
                  location: locationController.text,
                  maxParticipants: int.parse(maxParticipantsController.text),
                  currentParticipants: 0,
                  participants: [],
                  organizerId: 'user',
                  organizerName: organizerController.text,
                  isActive: true,
                );

                setState(() {
                  _events.add(newEvent);
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Мероприятие успешно создано!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  String _getEventCategory(VolunteerEvent event) {
    switch (event.id) {
      case '1':
      case '5':
      case '8':
        return 'Экология';
      case '2':
        return 'Безопасность';
      case '3':
        return 'Медицина';
      case '4':
        return 'Образование';
      case '6':
        return 'Животные';
      case '7':
        return 'Право';
      default:
        return 'Другое';
    }
  }
}
