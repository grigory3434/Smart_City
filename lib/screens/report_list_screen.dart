import 'package:flutter/material.dart';
import '../models/report.dart';
import '../services/api_service.dart';
import 'report_detail_screen.dart';

class ReportListScreen extends StatefulWidget {
  @override
  _ReportListScreenState createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final _searchController = TextEditingController();
  List<Report> _reports = [];
  List<Report> _filteredReports = [];
  bool _isLoading = true;
  String? _error;
  ReportStatus? _selectedStatus;
  ReportCategory? _selectedCategory;
  int _currentPage = 1;
  bool _hasMorePages = true;

  final List<String> _statusOptions = [
    'Все',
    'Новый',
    'В работе',
    'Завершенный',
    'Отклонен',
  ];

  final List<String> _categoryOptions = [
    'Все',
    'Дороги',
    'Освещение',
    'Мусор',
    'Укрытия',
    'Другое',
  ];

  @override
  void initState() {
    super.initState();
    _loadReports();
    _addDemoAnnouncementReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReports({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMorePages = true;
      });
    }

    if (!_hasMorePages && !refresh) return;

    setState(() {
      if (refresh) {
        _isLoading = true;
        _error = null;
      }
    });

    try {
      final result = await ApiService.getReports(
        status: _selectedStatus,
        category: _selectedCategory,
      );

      if (result['success']) {
        final newReports = (result['reports'] as List)
            .map((report) => Report.fromJson(report))
            .toList();

        setState(() {
          if (refresh) {
            _reports = newReports;
          } else {
            _reports.addAll(newReports);
          }
          _currentPage = result['page'] + 1;
          _hasMorePages = result['page'] < result['pages'];
          _isLoading = false;
        });

        _filterReports();
      } else {
        // Если API недоступен, используем демо-данные
        _loadDemoReports();
      }
    } catch (e) {
      // Если ошибка сети, используем демо-данные
      _loadDemoReports();
    }
  }

  void _loadDemoReports() {
    setState(() {
      _reports = [
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
          photoUrl: null,
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
          photoUrl: null,
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
          photoUrl: null,
          reporterName: 'Пётр Волков',
          priority: ReportPriority.high,
        ),
        Report(
          id: '4',
          title: 'Отсутствует укрытие от дождя',
          description:
              'Нет навеса на остановке, люди мокнут под дождём. Нужно установить козырёк.',
          category: ReportCategory.shelter,
          status: ReportStatus.rejected,
          latitude: 55.754244,
          longitude: 37.621423,
          createdAt: DateTime.now().subtract(Duration(days: 7)),
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
          photoUrl: null,
          reporterName: 'Анна Козлова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '5',
          title: 'Сломанная скамейка в парке',
          description:
              'Скамейка сломана, нельзя сидеть. Опасность для детей, которые могут пораниться.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.755244,
          longitude: 37.622423,
          createdAt: DateTime.now().subtract(Duration(hours: 1)),
          updatedAt: DateTime.now().subtract(Duration(hours: 1)),
          photoUrl: null,
          reporterName: 'Сергей Иванов',
          priority: ReportPriority.low,
        ),
        Report(
          id: '6',
          title: 'Протекает крыша в подъезде',
          description:
              'Во время дождя вода капает с потолка в подъезде. Может повредить электропроводку.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.756244,
          longitude: 37.623423,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          updatedAt: DateTime.now().subtract(Duration(hours: 12)),
          photoUrl: null,
          reporterName: 'Елена Смирнова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '7',
          title: 'Сломанный лифт',
          description:
              'Лифт не работает уже 2 дня. Пожилые люди не могут подниматься на верхние этажи.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.757244,
          longitude: 37.624423,
          createdAt: DateTime.now().subtract(Duration(hours: 6)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          photoUrl: null,
          reporterName: 'Виктор Козлов',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '8',
          title: 'Не работает отопление',
          description:
              'В квартирах холодно, батареи не греют. Температура в комнатах 15 градусов.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.758244,
          longitude: 37.625423,
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 2)),
          photoUrl: null,
          reporterName: 'Ольга Петрова',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '9',
          title: 'Сломанная детская площадка',
          description:
              'Качели сломаны, горка повреждена. Дети не могут играть безопасно.',
          category: ReportCategory.other,
          status: ReportStatus.completed,
          latitude: 55.759244,
          longitude: 37.626423,
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          updatedAt: DateTime.now().subtract(Duration(days: 1)),
          photoUrl: null,
          reporterName: 'Александр Волков',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '10',
          title: 'Затопленный подвал',
          description:
              'В подвале стоит вода после дождя. Может повредить фундамент здания.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.760244,
          longitude: 37.627423,
          createdAt: DateTime.now().subtract(Duration(hours: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 4)),
          photoUrl: null,
          reporterName: 'Татьяна Иванова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '11',
          title: 'Сломанное освещение в подъезде',
          description:
              'Лампочки в подъезде не работают, темно и опасно для жильцов.',
          category: ReportCategory.lighting,
          status: ReportStatus.new_,
          latitude: 55.761244,
          longitude: 37.628423,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 2)),
          photoUrl: null,
          reporterName: 'Михаил Соколов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '12',
          title: 'Яма на тротуаре',
          description:
              'Большая яма на тротуаре, люди могут споткнуться и упасть.',
          category: ReportCategory.road,
          status: ReportStatus.inProgress,
          latitude: 55.762244,
          longitude: 37.629423,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          updatedAt: DateTime.now().subtract(Duration(hours: 8)),
          photoUrl: null,
          reporterName: 'Наталья Морозова',
          priority: ReportPriority.high,
        ),
        // Дополнительные репорты (в 6 раз больше)
        Report(
          id: '13',
          title: 'Сломанная лавочка в сквере',
          description:
              'Лавочка сломана, спинка отвалилась. Нужно починить или заменить.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.763244,
          longitude: 37.630423,
          createdAt: DateTime.now().subtract(Duration(hours: 12)),
          updatedAt: DateTime.now().subtract(Duration(hours: 12)),
          photoUrl: null,
          reporterName: 'Дмитрий Соколов',
          priority: ReportPriority.low,
        ),
        Report(
          id: '14',
          title: 'Не работает фонтан',
          description:
              'Фонтан в парке не работает уже месяц. Вода не течёт, насос сломан.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.764244,
          longitude: 37.631423,
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 1)),
          photoUrl: null,
          reporterName: 'Анна Морозова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '15',
          title: 'Сломанная урна',
          description:
              'Урна сломана, мусор высыпается на тротуар. Нужно заменить.',
          category: ReportCategory.garbage,
          status: ReportStatus.completed,
          latitude: 55.765244,
          longitude: 37.632423,
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          updatedAt: DateTime.now().subtract(Duration(days: 1)),
          photoUrl: null,
          reporterName: 'Сергей Петров',
          priority: ReportPriority.low,
        ),
        Report(
          id: '16',
          title: 'Не работает светофор',
          description:
              'Светофор на перекрёстке не работает, опасно для пешеходов.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.766244,
          longitude: 37.633423,
          createdAt: DateTime.now().subtract(Duration(hours: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 4)),
          photoUrl: null,
          reporterName: 'Мария Иванова',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '17',
          title: 'Сломанная калитка',
          description:
              'Калитка в парке сломана, не закрывается. Дети могут выбежать на дорогу.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.767244,
          longitude: 37.634423,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          photoUrl: null,
          reporterName: 'Ольга Сидорова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '18',
          title: 'Не работает колонка',
          description:
              'Колонка с питьевой водой не работает, течёт ржавая вода.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.768244,
          longitude: 37.635423,
          createdAt: DateTime.now().subtract(Duration(days: 8)),
          updatedAt: DateTime.now().subtract(Duration(days: 3)),
          photoUrl: null,
          reporterName: 'Виктор Козлов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '19',
          title: 'Сломанная лестница',
          description:
              'Лестница в подземном переходе сломана, опасно для пожилых людей.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.769244,
          longitude: 37.636423,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 2)),
          photoUrl: null,
          reporterName: 'Елена Волкова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '20',
          title: 'Не работает эскалатор',
          description:
              'Эскалатор в метро не работает, люди вынуждены подниматься пешком.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.770244,
          longitude: 37.637423,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          updatedAt: DateTime.now().subtract(Duration(hours: 10)),
          photoUrl: null,
          reporterName: 'Александр Морозов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '21',
          title: 'Сломанная дверь',
          description:
              'Дверь в подъезде сломана, не закрывается. Холодно в подъезде.',
          category: ReportCategory.other,
          status: ReportStatus.completed,
          latitude: 55.771244,
          longitude: 37.638423,
          createdAt: DateTime.now().subtract(Duration(days: 6)),
          updatedAt: DateTime.now().subtract(Duration(days: 1)),
          photoUrl: null,
          reporterName: 'Татьяна Петрова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '22',
          title: 'Не работает домофон',
          description:
              'Домофон не работает, не слышно звонков. Нужно починить.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.772244,
          longitude: 37.639423,
          createdAt: DateTime.now().subtract(Duration(hours: 8)),
          updatedAt: DateTime.now().subtract(Duration(hours: 8)),
          photoUrl: null,
          reporterName: 'Михаил Иванов',
          priority: ReportPriority.low,
        ),
        Report(
          id: '23',
          title: 'Сломанная почтовая ящик',
          description: 'Почтовый ящик сломан, почта может потеряться.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.773244,
          longitude: 37.640423,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 4)),
          photoUrl: null,
          reporterName: 'Наталья Сидорова',
          priority: ReportPriority.low,
        ),
        Report(
          id: '24',
          title: 'Не работает кондиционер',
          description: 'Кондиционер в магазине не работает, очень жарко.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.774244,
          longitude: 37.641423,
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          updatedAt: DateTime.now().subtract(Duration(days: 5)),
          photoUrl: null,
          reporterName: 'Сергей Козлов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '25',
          title: 'Сломанная велопарковка',
          description: 'Велопарковка сломана, велосипеды падают.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.775244,
          longitude: 37.642423,
          createdAt: DateTime.now().subtract(Duration(hours: 6)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          photoUrl: null,
          reporterName: 'Анна Волкова',
          priority: ReportPriority.low,
        ),
        Report(
          id: '26',
          title: 'Не работает банкомат',
          description: 'Банкомат не работает, не выдаёт деньги.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.776244,
          longitude: 37.643423,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          updatedAt: DateTime.now().subtract(Duration(hours: 12)),
          photoUrl: null,
          reporterName: 'Дмитрий Морозов',
          priority: ReportPriority.high,
        ),
        Report(
          id: '27',
          title: 'Сломанная телефонная будка',
          description: 'Телефонная будка сломана, не работает.',
          category: ReportCategory.other,
          status: ReportStatus.completed,
          latitude: 55.777244,
          longitude: 37.644423,
          createdAt: DateTime.now().subtract(Duration(days: 7)),
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
          photoUrl: null,
          reporterName: 'Ольга Петрова',
          priority: ReportPriority.low,
        ),
        Report(
          id: '28',
          title: 'Не работает Wi-Fi',
          description: 'Wi-Fi в парке не работает, нет интернета.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.778244,
          longitude: 37.645423,
          createdAt: DateTime.now().subtract(Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 3)),
          photoUrl: null,
          reporterName: 'Виктор Иванов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '29',
          title: 'Сломанная камера наблюдения',
          description: 'Камера наблюдения сломана, не записывает видео.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.779244,
          longitude: 37.646423,
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 8)),
          photoUrl: null,
          reporterName: 'Елена Сидорова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '30',
          title: 'Не работает турникет',
          description: 'Турникет в метро не работает, люди проходят бесплатно.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.780244,
          longitude: 37.647423,
          createdAt: DateTime.now().subtract(Duration(days: 9)),
          updatedAt: DateTime.now().subtract(Duration(days: 4)),
          photoUrl: null,
          reporterName: 'Александр Козлов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '31',
          title: 'Сломанная скамейка на остановке',
          description: 'Скамейка на остановке сломана, негде сидеть.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.781244,
          longitude: 37.648423,
          createdAt: DateTime.now().subtract(Duration(hours: 5)),
          updatedAt: DateTime.now().subtract(Duration(hours: 5)),
          photoUrl: null,
          reporterName: 'Татьяна Волкова',
          priority: ReportPriority.low,
        ),
        Report(
          id: '32',
          title: 'Не работает автомат с водой',
          description: 'Автомат с питьевой водой не работает, не выдаёт воду.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.782244,
          longitude: 37.649423,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          photoUrl: null,
          reporterName: 'Михаил Морозов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '33',
          title: 'Сломанная урна для раздельного сбора',
          description: 'Урна для раздельного сбора мусора сломана.',
          category: ReportCategory.garbage,
          status: ReportStatus.completed,
          latitude: 55.783244,
          longitude: 37.650423,
          createdAt: DateTime.now().subtract(Duration(days: 6)),
          updatedAt: DateTime.now().subtract(Duration(days: 1)),
          photoUrl: null,
          reporterName: 'Наталья Петрова',
          priority: ReportPriority.low,
        ),
        Report(
          id: '34',
          title: 'Не работает светодиодная вывеска',
          description:
              'Светодиодная вывеска не работает, не видно названия магазина.',
          category: ReportCategory.lighting,
          status: ReportStatus.new_,
          latitude: 55.784244,
          longitude: 37.651423,
          createdAt: DateTime.now().subtract(Duration(hours: 7)),
          updatedAt: DateTime.now().subtract(Duration(hours: 7)),
          photoUrl: null,
          reporterName: 'Сергей Иванов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '35',
          title: 'Сломанная велополоса',
          description:
              'Велополоса на дороге разбита, опасно для велосипедистов.',
          category: ReportCategory.road,
          status: ReportStatus.inProgress,
          latitude: 55.785244,
          longitude: 37.652423,
          createdAt: DateTime.now().subtract(Duration(days: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 10)),
          photoUrl: null,
          reporterName: 'Анна Сидорова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '36',
          title: 'Не работает подземный переход',
          description: 'Подземный переход затоплен, нельзя пройти.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.786244,
          longitude: 37.653423,
          createdAt: DateTime.now().subtract(Duration(days: 11)),
          updatedAt: DateTime.now().subtract(Duration(days: 6)),
          photoUrl: null,
          reporterName: 'Дмитрий Козлов',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '37',
          title: 'Сломанная детская горка',
          description: 'Детская горка сломана, дети не могут кататься.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.787244,
          longitude: 37.654423,
          createdAt: DateTime.now().subtract(Duration(hours: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 4)),
          photoUrl: null,
          reporterName: 'Ольга Волкова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '38',
          title: 'Не работает система полива',
          description: 'Система полива газонов не работает, трава сохнет.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.788244,
          longitude: 37.655423,
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 8)),
          photoUrl: null,
          reporterName: 'Виктор Морозов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '39',
          title: 'Сломанная беседка',
          description: 'Беседка в парке сломана, крыша протекает.',
          category: ReportCategory.shelter,
          status: ReportStatus.completed,
          latitude: 55.789244,
          longitude: 37.656423,
          createdAt: DateTime.now().subtract(Duration(days: 8)),
          updatedAt: DateTime.now().subtract(Duration(days: 2)),
          photoUrl: null,
          reporterName: 'Елена Петрова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '40',
          title: 'Не работает система вентиляции',
          description: 'Система вентиляции в подземном переходе не работает.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.790244,
          longitude: 37.657423,
          createdAt: DateTime.now().subtract(Duration(hours: 6)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          photoUrl: null,
          reporterName: 'Александр Иванов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '41',
          title: 'Сломанная лестница в парке',
          description: 'Лестница в парке сломана, ступеньки шатаются.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.791244,
          longitude: 37.658423,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 12)),
          photoUrl: null,
          reporterName: 'Татьяна Сидорова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '42',
          title: 'Не работает система отопления в павильоне',
          description: 'Система отопления в павильоне не работает, холодно.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.792244,
          longitude: 37.659423,
          createdAt: DateTime.now().subtract(Duration(days: 12)),
          updatedAt: DateTime.now().subtract(Duration(days: 7)),
          photoUrl: null,
          reporterName: 'Михаил Козлов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '43',
          title: 'Сломанная карусель',
          description: 'Карусель в парке сломана, дети не могут кататься.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.793244,
          longitude: 37.660423,
          createdAt: DateTime.now().subtract(Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 3)),
          photoUrl: null,
          reporterName: 'Наталья Волкова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '44',
          title: 'Не работает система освещения в сквере',
          description: 'Система освещения в сквере не работает, темно.',
          category: ReportCategory.lighting,
          status: ReportStatus.inProgress,
          latitude: 55.794244,
          longitude: 37.661423,
          createdAt: DateTime.now().subtract(Duration(days: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          photoUrl: null,
          reporterName: 'Сергей Морозов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '45',
          title: 'Сломанная ограда',
          description: 'Ограда вокруг детской площадки сломана.',
          category: ReportCategory.other,
          status: ReportStatus.completed,
          latitude: 55.795244,
          longitude: 37.662423,
          createdAt: DateTime.now().subtract(Duration(days: 9)),
          updatedAt: DateTime.now().subtract(Duration(days: 3)),
          photoUrl: null,
          reporterName: 'Анна Петрова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '46',
          title: 'Не работает система пожаротушения',
          description: 'Система пожаротушения в здании не работает.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.796244,
          longitude: 37.663423,
          createdAt: DateTime.now().subtract(Duration(hours: 5)),
          updatedAt: DateTime.now().subtract(Duration(hours: 5)),
          photoUrl: null,
          reporterName: 'Дмитрий Иванов',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '47',
          title: 'Сломанная система канализации',
          description: 'Система канализации забита, вода не уходит.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.797244,
          longitude: 37.664423,
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 10)),
          photoUrl: null,
          reporterName: 'Ольга Сидорова',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '48',
          title: 'Не работает система кондиционирования',
          description:
              'Система кондиционирования в торговом центре не работает.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.798244,
          longitude: 37.665423,
          createdAt: DateTime.now().subtract(Duration(days: 13)),
          updatedAt: DateTime.now().subtract(Duration(days: 8)),
          photoUrl: null,
          reporterName: 'Виктор Морозов',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '49',
          title: 'Сломанная система ливневой канализации',
          description:
              'Система ливневой канализации забита, вода стоит на дороге.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.799244,
          longitude: 37.666423,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 2)),
          photoUrl: null,
          reporterName: 'Елена Козлова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '50',
          title: 'Не работает система очистки воздуха',
          description: 'Система очистки воздуха в метро не работает.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.800244,
          longitude: 37.667423,
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          updatedAt: DateTime.now().subtract(Duration(hours: 4)),
          photoUrl: null,
          reporterName: 'Александр Волкова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '51',
          title: 'Сломанная система видеонаблюдения',
          description: 'Система видеонаблюдения в парке не работает.',
          category: ReportCategory.other,
          status: ReportStatus.completed,
          latitude: 55.801244,
          longitude: 37.668423,
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          updatedAt: DateTime.now().subtract(Duration(days: 4)),
          photoUrl: null,
          reporterName: 'Татьяна Морозова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '52',
          title: 'Не работает система оповещения',
          description: 'Система оповещения в торговом центре не работает.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.802244,
          longitude: 37.669423,
          createdAt: DateTime.now().subtract(Duration(hours: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 4)),
          photoUrl: null,
          reporterName: 'Михаил Петров',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '53',
          title: 'Сломанная система контроля доступа',
          description: 'Система контроля доступа в здании не работает.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.803244,
          longitude: 37.670423,
          createdAt: DateTime.now().subtract(Duration(days: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 8)),
          photoUrl: null,
          reporterName: 'Наталья Иванова',
          priority: ReportPriority.high,
        ),
        Report(
          id: '54',
          title: 'Не работает система вентиляции в метро',
          description: 'Система вентиляции в метро не работает, душно.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.804244,
          longitude: 37.671423,
          createdAt: DateTime.now().subtract(Duration(days: 14)),
          updatedAt: DateTime.now().subtract(Duration(days: 9)),
          photoUrl: null,
          reporterName: 'Сергей Сидорова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '55',
          title: 'Сломанная система отопления в школе',
          description: 'Система отопления в школе не работает, детям холодно.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.805244,
          longitude: 37.672423,
          createdAt: DateTime.now().subtract(Duration(hours: 1)),
          updatedAt: DateTime.now().subtract(Duration(hours: 1)),
          photoUrl: null,
          reporterName: 'Анна Козлова',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '56',
          title: 'Не работает система пожаротушения в больнице',
          description: 'Система пожаротушения в больнице не работает.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.806244,
          longitude: 37.673423,
          createdAt: DateTime.now().subtract(Duration(days: 6)),
          updatedAt: DateTime.now().subtract(Duration(hours: 2)),
          photoUrl: null,
          reporterName: 'Дмитрий Волкова',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '57',
          title: 'Сломанная система кондиционирования в кинотеатре',
          description: 'Система кондиционирования в кинотеатре не работает.',
          category: ReportCategory.other,
          status: ReportStatus.completed,
          latitude: 55.807244,
          longitude: 37.674423,
          createdAt: DateTime.now().subtract(Duration(days: 11)),
          updatedAt: DateTime.now().subtract(Duration(days: 5)),
          photoUrl: null,
          reporterName: 'Ольга Морозова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '58',
          title: 'Не работает система освещения в библиотеке',
          description: 'Система освещения в библиотеке не работает.',
          category: ReportCategory.lighting,
          status: ReportStatus.new_,
          latitude: 55.808244,
          longitude: 37.675423,
          createdAt: DateTime.now().subtract(Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 3)),
          photoUrl: null,
          reporterName: 'Виктор Петрова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '59',
          title: 'Сломанная система отопления в детском саду',
          description: 'Система отопления в детском саду не работает.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.809244,
          longitude: 37.676423,
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          photoUrl: null,
          reporterName: 'Елена Иванова',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '60',
          title: 'Не работает система вентиляции в спортзале',
          description: 'Система вентиляции в спортзале не работает.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.810244,
          longitude: 37.677423,
          createdAt: DateTime.now().subtract(Duration(days: 15)),
          updatedAt: DateTime.now().subtract(Duration(days: 10)),
          photoUrl: null,
          reporterName: 'Александр Сидорова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '61',
          title: 'Сломанная система отопления в поликлинике',
          description: 'Система отопления в поликлинике не работает.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.811244,
          longitude: 37.678423,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 2)),
          photoUrl: null,
          reporterName: 'Татьяна Козлова',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '62',
          title: 'Не работает система кондиционирования в ресторане',
          description: 'Система кондиционирования в ресторане не работает.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.812244,
          longitude: 37.679423,
          createdAt: DateTime.now().subtract(Duration(days: 7)),
          updatedAt: DateTime.now().subtract(Duration(hours: 4)),
          photoUrl: null,
          reporterName: 'Михаил Волкова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '63',
          title: 'Сломанная система отопления в музее',
          description: 'Система отопления в музее не работает.',
          category: ReportCategory.other,
          status: ReportStatus.completed,
          latitude: 55.813244,
          longitude: 37.680423,
          createdAt: DateTime.now().subtract(Duration(days: 12)),
          updatedAt: DateTime.now().subtract(Duration(days: 6)),
          photoUrl: null,
          reporterName: 'Наталья Морозова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '64',
          title: 'Не работает система освещения в театре',
          description: 'Система освещения в театре не работает.',
          category: ReportCategory.lighting,
          status: ReportStatus.new_,
          latitude: 55.814244,
          longitude: 37.681423,
          createdAt: DateTime.now().subtract(Duration(hours: 4)),
          updatedAt: DateTime.now().subtract(Duration(hours: 4)),
          photoUrl: null,
          reporterName: 'Сергей Петрова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '65',
          title: 'Сломанная система отопления в цирке',
          description: 'Система отопления в цирке не работает.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.815244,
          longitude: 37.682423,
          createdAt: DateTime.now().subtract(Duration(days: 6)),
          updatedAt: DateTime.now().subtract(Duration(hours: 8)),
          photoUrl: null,
          reporterName: 'Анна Иванова',
          priority: ReportPriority.critical,
        ),
        Report(
          id: '66',
          title: 'Не работает система вентиляции в бассейне',
          description: 'Система вентиляции в бассейне не работает.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.816244,
          longitude: 37.683423,
          createdAt: DateTime.now().subtract(Duration(days: 16)),
          updatedAt: DateTime.now().subtract(Duration(days: 11)),
          photoUrl: null,
          reporterName: 'Дмитрий Сидорова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '67',
          title: 'Сломанная система отопления в сауне',
          description: 'Система отопления в сауне не работает.',
          category: ReportCategory.other,
          status: ReportStatus.new_,
          latitude: 55.817244,
          longitude: 37.684423,
          createdAt: DateTime.now().subtract(Duration(hours: 3)),
          updatedAt: DateTime.now().subtract(Duration(hours: 3)),
          photoUrl: null,
          reporterName: 'Ольга Козлова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '68',
          title: 'Не работает система кондиционирования в салоне красоты',
          description:
              'Система кондиционирования в салоне красоты не работает.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.818244,
          longitude: 37.685423,
          createdAt: DateTime.now().subtract(Duration(days: 8)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          photoUrl: null,
          reporterName: 'Виктор Волкова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '69',
          title: 'Сломанная система отопления в парикмахерской',
          description: 'Система отопления в парикмахерской не работает.',
          category: ReportCategory.other,
          status: ReportStatus.completed,
          latitude: 55.819244,
          longitude: 37.686423,
          createdAt: DateTime.now().subtract(Duration(days: 13)),
          updatedAt: DateTime.now().subtract(Duration(days: 7)),
          photoUrl: null,
          reporterName: 'Елена Морозова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '70',
          title: 'Не работает система освещения в аптеке',
          description: 'Система освещения в аптеке не работает.',
          category: ReportCategory.lighting,
          status: ReportStatus.new_,
          latitude: 55.820244,
          longitude: 37.687423,
          createdAt: DateTime.now().subtract(Duration(hours: 5)),
          updatedAt: DateTime.now().subtract(Duration(hours: 5)),
          photoUrl: null,
          reporterName: 'Александр Петрова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '71',
          title: 'Сломанная система отопления в банке',
          description: 'Система отопления в банке не работает.',
          category: ReportCategory.other,
          status: ReportStatus.inProgress,
          latitude: 55.821244,
          longitude: 37.688423,
          createdAt: DateTime.now().subtract(Duration(days: 7)),
          updatedAt: DateTime.now().subtract(Duration(hours: 10)),
          photoUrl: null,
          reporterName: 'Татьяна Иванова',
          priority: ReportPriority.medium,
        ),
        Report(
          id: '72',
          title: 'Не работает система вентиляции в офисе',
          description: 'Система вентиляции в офисе не работает.',
          category: ReportCategory.other,
          status: ReportStatus.rejected,
          latitude: 55.822244,
          longitude: 37.689423,
          createdAt: DateTime.now().subtract(Duration(days: 17)),
          updatedAt: DateTime.now().subtract(Duration(days: 12)),
          photoUrl: null,
          reporterName: 'Михаил Сидорова',
          priority: ReportPriority.medium,
        ),
      ];
      _isLoading = false;
    });

    _filterReports();
  }

  void _filterReports() {
    final searchQuery = _searchController.text.toLowerCase();

    setState(() {
      _filteredReports = _reports.where((report) {
        final matchesSearch =
            report.title.toLowerCase().contains(searchQuery) ||
                report.description.toLowerCase().contains(searchQuery) ||
                report.reporterName.toLowerCase().contains(searchQuery);

        return matchesSearch;
      }).toList();
    });
  }

  void _onStatusChanged(String? status) {
    setState(() {
      _selectedStatus =
          status == 'Все' ? null : _getStatusFromString(status ?? '');
    });
    _loadReports(refresh: true);
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory =
          category == 'Все' ? null : _getCategoryFromString(category ?? '');
    });
    _loadReports(refresh: true);
  }

  ReportStatus _getStatusFromString(String status) {
    switch (status) {
      case 'Новый':
        return ReportStatus.new_;
      case 'В работе':
        return ReportStatus.inProgress;
      case 'Завершенный':
        return ReportStatus.completed;
      case 'Отклонен':
        return ReportStatus.rejected;
      default:
        return ReportStatus.new_;
    }
  }

  ReportCategory _getCategoryFromString(String category) {
    switch (category) {
      case 'Дороги':
        return ReportCategory.road;
      case 'Освещение':
        return ReportCategory.lighting;
      case 'Мусор':
        return ReportCategory.garbage;
      case 'Укрытия':
        return ReportCategory.shelter;
      case 'Другое':
        return ReportCategory.other;
      default:
        return ReportCategory.other;
    }
  }

  String _getStatusString(ReportStatus status) {
    switch (status) {
      case ReportStatus.new_:
        return 'Новый';
      case ReportStatus.inProgress:
        return 'В работе';
      case ReportStatus.completed:
        return 'Завершенный';
      case ReportStatus.rejected:
        return 'Отклонен';
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Лента репортов'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _loadReports(refresh: true),
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
                hintText: 'Поиск по репортам...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterReports();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _filterReports(),
            ),
          ),

          // Фильтры
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus == null
                        ? 'Все'
                        : _getStatusString(_selectedStatus!),
                    decoration: InputDecoration(
                      labelText: 'Статус',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _statusOptions.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: _onStatusChanged,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory == null
                        ? 'Все'
                        : _getCategoryString(_selectedCategory!),
                    decoration: InputDecoration(
                      labelText: 'Категория',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: _categoryOptions.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: _onCategoryChanged,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Список репортов
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredReports.isEmpty
                    ? _buildEmptyWidget()
                    : ListView.builder(
                        itemCount: _filteredReports.length,
                        itemBuilder: (context, index) {
                          final report = _filteredReports[index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.08),
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => _openReportDetail(report),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (report.photoUrl != null &&
                                          report.photoUrl!.startsWith(
                                              'assets/images/reports/'))
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: Image.asset(
                                            report.photoUrl!,
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      if (report.photoUrl != null &&
                                          report.photoUrl!.startsWith(
                                              'assets/images/reports/'))
                                        SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getCategoryColor(
                                                        report.category),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    _getCategoryString(
                                                        report.category),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(
                                                        report.status),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    _getStatusString(
                                                        report.status),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              report.title,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue.shade900),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              report.description,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      Colors.blueGrey.shade700),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Icon(Icons.person,
                                                    size: 16,
                                                    color: Colors
                                                        .blueGrey.shade400),
                                                SizedBox(width: 4),
                                                Text(report.reporterName,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.blueGrey
                                                            .shade500)),
                                                Spacer(),
                                                Icon(Icons.access_time,
                                                    size: 14,
                                                    color: Colors
                                                        .blueGrey.shade300),
                                                SizedBox(width: 2),
                                                Text(
                                                    _formatTime(
                                                        report.createdAt),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blueGrey
                                                            .shade400)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Ошибка загрузки',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _loadReports(refresh: true),
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
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Репорты не найдены',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Попробуйте изменить поисковый запрос или фильтры',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _openReportDetail(Report report) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportDetailScreen(report: report),
      ),
    );
  }

  Color _getCategoryColor(ReportCategory category) {
    switch (category) {
      case ReportCategory.road:
        return Colors.orange;
      case ReportCategory.lighting:
        return Colors.yellow[700]!;
      case ReportCategory.garbage:
        return Colors.green;
      case ReportCategory.shelter:
        return Colors.blue;
      case ReportCategory.other:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}д назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}ч назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}м назад';
    } else {
      return 'сейчас';
    }
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.new_:
        return Colors.blue;
      case ReportStatus.inProgress:
        return Colors.orange;
      case ReportStatus.completed:
        return Colors.green;
      case ReportStatus.rejected:
        return Colors.red;
    }
  }

  void _addDemoAnnouncementReports() {
    final now = DateTime.now();
    _reports.insertAll(0, [
      Report(
        id: 'a1',
        title: 'Объявление: Потерялась собака',
        description:
            'На столбе найдено объявление о пропаже собаки. Просьба откликнуться, если видели.',
        category: ReportCategory.other,
        status: ReportStatus.new_,
        priority: ReportPriority.medium,
        latitude: 55.751244,
        longitude: 37.618423,
        createdAt: now.subtract(Duration(days: 1)),
        updatedAt: now.subtract(Duration(days: 1)),
        photoUrl: 'assets/images/reports/announcement_dog.jpg',
        reporterName: 'Алексей',
        tags: ['объявление'],
      ),
      Report(
        id: 'a2',
        title: 'Объявление: Продажа велосипеда',
        description:
            'На подъезде размещено объявление о продаже велосипеда. Контакт указан на фото.',
        category: ReportCategory.other,
        status: ReportStatus.inProgress,
        priority: ReportPriority.low,
        latitude: 55.752244,
        longitude: 37.619423,
        createdAt: now.subtract(Duration(days: 2)),
        updatedAt: now.subtract(Duration(days: 2)),
        photoUrl: 'assets/images/reports/announcement_bike.jpg',
        reporterName: 'Мария',
        tags: ['объявление'],
      ),
    ]);
  }
}
