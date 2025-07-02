import 'package:flutter/material.dart';
import '../models/report.dart';
import '../services/api_service.dart';

class ReportDetailScreen extends StatefulWidget {
  final Report report;

  const ReportDetailScreen({Key? key, required this.report}) : super(key: key);

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали репорта'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и статус
            _buildHeader(),
            SizedBox(height: 16),

            // Фото
            if (widget.report.photoUrl != null) _buildPhoto(),
            SizedBox(height: 16),

            // Описание
            _buildDescription(),
            SizedBox(height: 16),

            // Информация о репорте
            _buildReportInfo(),
            SizedBox(height: 16),

            // Действия
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getCategoryIcon(widget.report.category),
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.report.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            _buildStatusChip(widget.report.status),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto() {
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          widget.report.photoUrl!,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: Icon(
                Icons.broken_image,
                size: 64,
                color: Colors.grey[600],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Описание',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Text(widget.report.description),
          ],
        ),
      ),
    );
  }

  Widget _buildReportInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Информация о репорте',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            _buildInfoRow('Автор', widget.report.reporterName),
            _buildInfoRow(
                'Категория', _getCategoryString(widget.report.category)),
            _buildInfoRow(
                'Приоритет', _getPriorityString(widget.report.priority)),
            _buildInfoRow('Создан', _formatDate(widget.report.createdAt)),
            if (widget.report.updatedAt != null)
              _buildInfoRow('Обновлён', _formatDate(widget.report.updatedAt!)),
            _buildInfoRow('Координаты',
                '${widget.report.latitude.toStringAsFixed(6)}, ${widget.report.longitude.toStringAsFixed(6)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ReportStatus status) {
    Color color;
    String text;

    switch (status) {
      case ReportStatus.new_:
        color = Colors.orange;
        text = 'Новый';
        break;
      case ReportStatus.inProgress:
        color = Colors.blue;
        text = 'В работе';
        break;
      case ReportStatus.completed:
        color = Colors.green;
        text = 'Завершён';
        break;
      case ReportStatus.rejected:
        color = Colors.red;
        text = 'Отклонён';
        break;
    }

    return Chip(
      label: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        if (widget.report.status == ReportStatus.new_ ||
            widget.report.status == ReportStatus.inProgress)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _updateStatus,
              icon: Icon(Icons.update),
              label: Text('Обновить статус'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _shareReport,
            icon: Icon(Icons.share),
            label: Text('Поделиться'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _updateStatus() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Определяем следующий статус
      ReportStatus nextStatus;
      switch (widget.report.status) {
        case ReportStatus.new_:
          nextStatus = ReportStatus.inProgress;
          break;
        case ReportStatus.inProgress:
          nextStatus = ReportStatus.completed;
          break;
        default:
          nextStatus = widget.report.status;
      }

      final result =
          await ApiService.updateReport(widget.report.id, nextStatus);

      if (result['success']) {
        // Обновляем локальный репорт
        final updatedReport = Report(
          id: widget.report.id,
          title: widget.report.title,
          description: widget.report.description,
          category: widget.report.category,
          status: nextStatus,
          latitude: widget.report.latitude,
          longitude: widget.report.longitude,
          createdAt: widget.report.createdAt,
          updatedAt: DateTime.now(),
          photoUrl: widget.report.photoUrl,
          reporterName: widget.report.reporterName,
          priority: widget.report.priority,
        );

        // Обновляем виджет
        setState(() {
          // Обновляем репорт в виджете
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Статус обновлён'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showError(result['error'] ?? 'Ошибка обновления статуса');
      }
    } catch (e) {
      _showError('Ошибка сети: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _shareReport() {
    // TODO: Реализовать шаринг репорта
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Функция шаринга будет добавлена в следующем обновлении')),
    );
  }

  void _showError(String message) {
    setState(() {
      _error = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
        return Icons.security;
      case ReportCategory.other:
        return Icons.report;
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
        return 'Укрытие';
      case ReportCategory.other:
        return 'Другое';
    }
  }

  String _getPriorityString(ReportPriority priority) {
    switch (priority) {
      case ReportPriority.low:
        return 'Низкий';
      case ReportPriority.medium:
        return 'Средний';
      case ReportPriority.high:
        return 'Высокий';
      case ReportPriority.critical:
        return 'Критический';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
