import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class KnowledgeBaseScreen extends StatefulWidget {
  const KnowledgeBaseScreen({super.key});

  @override
  State<KnowledgeBaseScreen> createState() => _KnowledgeBaseScreenState();
}

class _KnowledgeBaseScreenState extends State<KnowledgeBaseScreen> {
  final _searchController = TextEditingController();
  List<SafetyArticle> _articles = [];
  List<SafetyArticle> _filteredArticles = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'Все';
  final List<String> _categories = [
    'Все',
    'Пожарная безопасность',
    'Медицинская помощь',
    'Дорожная безопасность',
    'Криминальная безопасность',
    'Гражданская оборона',
    'Кибербезопасность',
    'Транспортная безопасность',
    'Безопасность дома',
    'Безопасность детей',
    'Экологическая безопасность',
    'Промышленная безопасность'
  ];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Пытаемся загрузить из API
      final result = await ApiService.getKnowledgeBase();

      if (result['success']) {
        setState(() {
          _articles = (result['articles'] as List)
              .map((article) => SafetyArticle.fromJson(article))
              .toList();
          _filteredArticles = List.from(_articles);
          _isLoading = false;
        });
      } else {
        // Если API недоступен, используем демо-данные
        _loadDemoArticles();
      }
    } catch (e) {
      // Если ошибка сети, используем демо-данные
      _loadDemoArticles();
    }
  }

  void _loadDemoArticles() {
    setState(() {
      _articles = [
        SafetyArticle(
          id: '1',
          title: 'Что делать при пожаре',
          category: 'Пожарная безопасность',
          content:
              'При обнаружении пожара немедленно позвоните в пожарную службу по номеру 101 или 112. Эвакуируйтесь из здания, не используйте лифт. Прикрывайте рот и нос влажной тканью. Если путь к выходу отрезан, закройте двери и окна, подавайте сигналы о помощи.',
          imageUrl:
              'https://via.placeholder.com/300x200/FF5722/FFFFFF?text=Пожар',
          isBookmarked: false,
          emergencyPhone: '101',
        ),
        SafetyArticle(
          id: '2',
          title: 'Первая помощь при травмах',
          category: 'Медицинская помощь',
          content:
              'При кровотечении наложите давящую повязку. При переломах зафиксируйте конечность. При ожогах охладите место холодной водой. Вызовите скорую помощь по номеру 103. При остановке сердца начинайте непрямой массаж сердца.',
          imageUrl:
              'https://via.placeholder.com/300x200/F44336/FFFFFF?text=Медицина',
          isBookmarked: true,
          emergencyPhone: '103',
        ),
        SafetyArticle(
          id: '3',
          title: 'Правила дорожного движения',
          category: 'Дорожная безопасность',
          content:
              'Переходите дорогу только по пешеходному переходу. Соблюдайте сигналы светофора. Будьте внимательны к движущемуся транспорту. Носите светоотражающие элементы в темное время суток.',
          imageUrl:
              'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Дорога',
          isBookmarked: false,
          emergencyPhone: '102',
        ),
        SafetyArticle(
          id: '4',
          title: 'Действия при землетрясении',
          category: 'Гражданская оборона',
          content:
              'При землетрясении укройтесь под прочным столом или кроватью. Держитесь подальше от окон и тяжелых предметов. После толчков эвакуируйтесь на открытое место. Не пользуйтесь лифтом.',
          imageUrl:
              'https://via.placeholder.com/300x200/795548/FFFFFF?text=Землетрясение',
          isBookmarked: false,
          emergencyPhone: '112',
        ),
        SafetyArticle(
          id: '5',
          title: 'Безопасность в интернете',
          category: 'Кибербезопасность',
          content:
              'Не переходите по подозрительным ссылкам. Не передавайте личные данные неизвестным лицам. Используйте надежные пароли и двухфакторную аутентификацию. Регулярно обновляйте антивирусное ПО.',
          imageUrl:
              'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=Безопасность',
          isBookmarked: true,
          emergencyPhone: null,
        ),
        SafetyArticle(
          id: '6',
          title: 'Правила поведения в метро',
          category: 'Транспортная безопасность',
          content:
              'Не заходите за ограничительную линию. Держитесь за поручни. При экстренной ситуации используйте кнопку связи с машинистом. Не бегайте по эскалатору.',
          imageUrl:
              'https://via.placeholder.com/300x200/607D8B/FFFFFF?text=Транспорт',
          isBookmarked: false,
          emergencyPhone: '112',
        ),
        SafetyArticle(
          id: '7',
          title: 'Безопасность в подъезде',
          category: 'Криминальная безопасность',
          content:
              'Не открывайте дверь незнакомцам. Установите домофон или видеодомофон. Освещайте подъезд. Сообщайте о подозрительных лицах в полицию.',
          imageUrl:
              'https://via.placeholder.com/300x200/3F51B5/FFFFFF?text=Подъезд',
          isBookmarked: false,
          emergencyPhone: '102',
        ),
        SafetyArticle(
          id: '8',
          title: 'Безопасность электроприборов',
          category: 'Безопасность дома',
          content:
              'Не перегружайте электросеть. Используйте только исправные электроприборы. Не оставляйте включенные приборы без присмотра. Установите УЗО.',
          imageUrl:
              'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Электричество',
          isBookmarked: true,
          emergencyPhone: '101',
        ),
        SafetyArticle(
          id: '9',
          title: 'Безопасность детей дома',
          category: 'Безопасность детей',
          content:
              'Уберите лекарства и химикаты в недоступные места. Закройте розетки заглушками. Установите блокираторы на окна. Не оставляйте детей без присмотра.',
          imageUrl:
              'https://via.placeholder.com/300x200/FFC107/FFFFFF?text=Дети',
          isBookmarked: false,
          emergencyPhone: '103',
        ),
        SafetyArticle(
          id: '10',
          title: 'Действия при утечке газа',
          category: 'Безопасность дома',
          content:
              'Не включайте свет и электроприборы. Откройте окна и двери. Перекройте газовый кран. Позвоните в газовую службу по номеру 104. Эвакуируйтесь из помещения.',
          imageUrl:
              'https://via.placeholder.com/300x200/FF5722/FFFFFF?text=Газ',
          isBookmarked: false,
          emergencyPhone: '104',
        ),
        SafetyArticle(
          id: '11',
          title: 'Безопасность на воде',
          category: 'Гражданская оборона',
          content:
              'Не купайтесь в незнакомых местах. Не заплывайте за буйки. Не плавайте в состоянии алкогольного опьянения. Следите за детьми у воды.',
          imageUrl:
              'https://via.placeholder.com/300x200/00BCD4/FFFFFF?text=Вода',
          isBookmarked: false,
          emergencyPhone: '112',
        ),
        SafetyArticle(
          id: '12',
          title: 'Действия при террористической угрозе',
          category: 'Криминальная безопасность',
          content:
              'При обнаружении подозрительного предмета не трогайте его. Сообщите в полицию. Эвакуируйтесь на безопасное расстояние. Следуйте указаниям правоохранительных органов.',
          imageUrl:
              'https://via.placeholder.com/300x200/795548/FFFFFF?text=Терроризм',
          isBookmarked: false,
          emergencyPhone: '102',
        ),
        SafetyArticle(
          id: '13',
          title: 'Безопасность в лифте',
          category: 'Транспортная безопасность',
          content:
              'Не пользуйтесь лифтом при пожаре. При застревании нажмите кнопку вызова диспетчера. Не прыгайте в лифте. Не перегружайте лифт.',
          imageUrl:
              'https://via.placeholder.com/300x200/607D8B/FFFFFF?text=Лифт',
          isBookmarked: false,
          emergencyPhone: '112',
        ),
        SafetyArticle(
          id: '14',
          title: 'Защита от мошенников',
          category: 'Криминальная безопасность',
          content:
              'Не передавайте данные банковских карт по телефону. Не переводите деньги незнакомцам. Проверяйте информацию о компаниях. Не подписывайте документы не читая.',
          imageUrl:
              'https://via.placeholder.com/300x200/E91E63/FFFFFF?text=Мошенники',
          isBookmarked: true,
          emergencyPhone: '102',
        ),
        SafetyArticle(
          id: '15',
          title: 'Безопасность в общественном транспорте',
          category: 'Транспортная безопасность',
          content:
              'Держитесь за поручни. Не высовывайтесь из окон. При экстренной ситуации используйте аварийные выходы. Сообщайте о подозрительных предметах.',
          imageUrl:
              'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Автобус',
          isBookmarked: false,
          emergencyPhone: '112',
        ),
        SafetyArticle(
          id: '16',
          title: 'Действия при химической аварии',
          category: 'Промышленная безопасность',
          content:
              'Закройте окна и двери. Включите кондиционер или вентиляцию. Используйте респиратор или влажную ткань. Следуйте указаниям МЧС.',
          imageUrl:
              'https://via.placeholder.com/300x200/8BC34A/FFFFFF?text=Химия',
          isBookmarked: false,
          emergencyPhone: '112',
        ),
        SafetyArticle(
          id: '17',
          title: 'Безопасность при грозе',
          category: 'Гражданская оборона',
          content:
              'Не находитесь на открытой местности. Не прячьтесь под деревьями. Не используйте мобильный телефон. Отключите электроприборы.',
          imageUrl:
              'https://via.placeholder.com/300x200/673AB7/FFFFFF?text=Гроза',
          isBookmarked: false,
          emergencyPhone: '112',
        ),
        SafetyArticle(
          id: '18',
          title: 'Безопасность в торговых центрах',
          category: 'Криминальная безопасность',
          content:
              'Не оставляйте детей без присмотра. Следите за личными вещами. Знайте расположение выходов. При эвакуации следуйте указателям.',
          imageUrl: 'https://via.placeholder.com/300x200/FF5722/FFFFFF?text=ТЦ',
          isBookmarked: false,
          emergencyPhone: '102',
        ),
        SafetyArticle(
          id: '19',
          title: 'Защита от коронавируса',
          category: 'Медицинская помощь',
          content:
              'Носите маску в общественных местах. Мойте руки с мылом. Соблюдайте социальную дистанцию. При симптомах обращайтесь к врачу.',
          imageUrl:
              'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Ковид',
          isBookmarked: true,
          emergencyPhone: '103',
        ),
        SafetyArticle(
          id: '20',
          title: 'Безопасность в парке',
          category: 'Безопасность детей',
          content:
              'Не кормите диких животных. Не заходите в темные места. Следите за детьми на аттракционах. Не оставляйте мусор.',
          imageUrl:
              'https://via.placeholder.com/300x200/8BC34A/FFFFFF?text=Парк',
          isBookmarked: false,
          emergencyPhone: '102',
        ),
      ];
      _filteredArticles = List.from(_articles);
      _isLoading = false;
    });
  }

  void _filterArticles() {
    final searchQuery = _searchController.text.toLowerCase();

    setState(() {
      _filteredArticles = _articles.where((article) {
        final matchesSearch =
            article.title.toLowerCase().contains(searchQuery) ||
                article.content.toLowerCase().contains(searchQuery);
        final matchesCategory =
            _selectedCategory == 'Все' || article.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _toggleBookmark(String articleId) {
    setState(() {
      final article = _articles.firstWhere((a) => a.id == articleId);
      article.isBookmarked = !article.isBookmarked;
      _filterArticles(); // Обновляем отфильтрованный список
    });
  }

  void _callEmergency(String? phoneNumber) async {
    if (phoneNumber == null) return;

    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось совершить звонок')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('База знаний'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => _showBookmarkedArticles(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Поисковая строка
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск по базе знаний...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterArticles();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _filterArticles(),
            ),
          ),

          // Фильтр по категориям
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _filterArticles();
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                    checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
              },
            ),
          ),

          // Список статей
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorWidget()
                    : _filteredArticles.isEmpty
                        ? _buildEmptyWidget()
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: _filteredArticles.length,
                            itemBuilder: (context, index) {
                              return _buildArticleCard(
                                  _filteredArticles[index]);
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _callEmergency('112'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: Icon(Icons.emergency),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          SizedBox(height: 16),
          Text(
            'Ошибка загрузки',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadArticles,
            child: Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
          SizedBox(height: 16),
          Text(
            'Ничего не найдено',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Попробуйте изменить поисковый запрос или категорию',
            style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(SafetyArticle article) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showArticleDetail(article),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      article.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: article.isBookmarked ? Colors.orange : null,
                    ),
                    onPressed: () => _toggleBookmark(article.id),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(article.category),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  article.category,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                article.content,
                style: TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  if (article.emergencyPhone != null) ...[
                    ElevatedButton.icon(
                      onPressed: () => _callEmergency(article.emergencyPhone),
                      icon: Icon(Icons.phone, size: 16),
                      label: Text(article.emergencyPhone!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                  Spacer(),
                  TextButton(
                    onPressed: () => _showArticleDetail(article),
                    child: Text('Читать далее'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showArticleDetail(SafetyArticle article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(article.title)),
            IconButton(
              icon: Icon(
                article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: article.isBookmarked ? Colors.orange : null,
              ),
              onPressed: () {
                _toggleBookmark(article.id);
                Navigator.of(context).pop();
                _showArticleDetail(article);
              },
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(article.category),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  article.category,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(article.content),
            ],
          ),
        ),
        actions: [
          if (article.emergencyPhone != null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _callEmergency(article.emergencyPhone);
              },
              icon: Icon(Icons.phone),
              label: Text('Позвонить ${article.emergencyPhone}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showBookmarkedArticles() {
    final bookmarkedArticles = _articles.where((a) => a.isBookmarked).toList();

    if (bookmarkedArticles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('У вас пока нет закладок')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Закладки'),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bookmarkedArticles.length,
            itemBuilder: (context, index) {
              final article = bookmarkedArticles[index];
              return ListTile(
                title: Text(article.title),
                subtitle: Text(article.category),
                trailing: IconButton(
                  icon: Icon(Icons.bookmark, color: Colors.orange),
                  onPressed: () {
                    _toggleBookmark(article.id);
                    Navigator.of(context).pop();
                    _showBookmarkedArticles();
                  },
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showArticleDetail(article);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Пожарная безопасность':
        return Colors.red;
      case 'Медицинская помощь':
        return Colors.green;
      case 'Дорожная безопасность':
        return Colors.orange;
      case 'Экстренные службы':
        return Colors.blue;
      case 'Гражданская оборона':
        return Colors.purple;
      case 'Кибербезопасность':
        return Colors.indigo;
      case 'Транспортная безопасность':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class SafetyArticle {
  final String id;
  final String title;
  final String category;
  final String content;
  final String imageUrl;
  bool isBookmarked;
  final String? emergencyPhone;

  SafetyArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.imageUrl,
    this.isBookmarked = false,
    this.emergencyPhone,
  });

  factory SafetyArticle.fromJson(Map<String, dynamic> json) {
    return SafetyArticle(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      content: json['content'],
      imageUrl: json['image_url'],
      isBookmarked: json['is_bookmarked'] ?? false,
      emergencyPhone: json['emergency_phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'content': content,
      'image_url': imageUrl,
      'is_bookmarked': isBookmarked,
      'emergency_phone': emergencyPhone,
    };
  }
}
