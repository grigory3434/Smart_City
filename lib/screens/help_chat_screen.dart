import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../widgets/themed_image.dart';

class HelpChatScreen extends StatefulWidget {
  @override
  _HelpChatScreenState createState() => _HelpChatScreenState();
}

class _HelpChatScreenState extends State<HelpChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDemoMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadDemoMessages() {
    setState(() {
      _messages = [
        Message(
          id: '1',
          text: 'Добро пожаловать в чат поддержки! Чем могу помочь?',
          senderId: 'support',
          senderName: 'Поддержка',
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
          isFromUser: false,
        ),
        Message(
          id: '2',
          text: 'Здравствуйте! У меня есть вопрос по репорту',
          senderId: 'user',
          senderName: 'Вы',
          timestamp: DateTime.now().subtract(Duration(minutes: 4)),
          isFromUser: true,
        ),
        Message(
          id: '3',
          text: 'Конечно! Расскажите подробнее о вашем репорте',
          senderId: 'support',
          senderName: 'Поддержка',
          timestamp: DateTime.now().subtract(Duration(minutes: 3)),
          isFromUser: false,
        ),
        Message(
          id: '4',
          text: 'Я отправил репорт о разбитой дороге, но статус не меняется',
          senderId: 'user',
          senderName: 'Вы',
          timestamp: DateTime.now().subtract(Duration(minutes: 2)),
          isFromUser: true,
        ),
        Message(
          id: '5',
          text:
              'Понял, давайте проверим статус вашего репорта. Какой у вас ID репорта?',
          senderId: 'support',
          senderName: 'Поддержка',
          timestamp: DateTime.now().subtract(Duration(minutes: 1)),
          isFromUser: false,
        ),
      ];
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: 'user',
      senderName: 'Вы',
      timestamp: DateTime.now(),
      isFromUser: true,
    );

    setState(() {
      _messages.add(message);
    });

    _messageController.clear();
    _scrollToBottom();

    // Имитация ответа поддержки
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        final response = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text:
              'Спасибо за сообщение! Мы обработаем ваш запрос в ближайшее время.',
          senderId: 'support',
          senderName: 'Поддержка',
          timestamp: DateTime.now(),
          isFromUser: false,
        );

        setState(() {
          _messages.add(response);
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чат поддержки'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('О чате поддержки'),
                  content: Text(
                      'Здесь вы можете задать вопросы службе поддержки о работе приложения или получить помощь с репортами.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Понятно'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.support_agent, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Начните разговор',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Задайте вопрос службе поддержки',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),

          // Поле ввода сообщения
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isFromUser) ...[
            // Аватар службы поддержки
            ClipOval(
              child: ThemedImage(
                title: 'Поддержка',
                type: 'chat',
                width: 32,
                height: 32,
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isFromUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: !message.isFromUser
                    ? Border.all(color: Colors.grey[300]!)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isFromUser) ...[
                    Text(
                      message.senderName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 2),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isFromUser
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isFromUser) ...[
            SizedBox(width: 8),
            // Аватар пользователя
            ClipOval(
              child: ThemedImage(
                title: 'Пользователь',
                type: 'chat',
                width: 32,
                height: 32,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
