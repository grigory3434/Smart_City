import 'package:flutter/material.dart';
import '../models/chat_room.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/themed_image.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatRoom> _chats = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getChats();

      if (result['success']) {
        setState(() {
          _chats = (result['chats'] as List)
              .map((chat) => ChatRoom.fromJson(chat))
              .toList();
          _isLoading = false;
        });
      } else {
        // Если API недоступен, используем демо-данные
        _loadDemoChats();
      }
    } catch (e) {
      // Если ошибка сети, используем демо-данные
      _loadDemoChats();
    }
  }

  void _loadDemoChats() {
    setState(() {
      _chats = [
        ChatRoom(
          id: '1',
          name: 'Чат дома 12',
          description: 'Обсуждение проблем и новостей дома 12',
          lastMessage: 'Кто-нибудь знает, когда починят лифт?',
          lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
          unreadCount: 2,
          participantsCount: 45,
          category: 'Дом',
          imageUrl: 'https://picsum.photos/80/80?random=30',
        ),
        ChatRoom(
          id: '2',
          name: 'Чат двора',
          description: 'Соседи по двору, помощь и обмен вещами',
          lastMessage: 'Отличная идея! Давайте организуем субботник',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 1)),
          unreadCount: 0,
          participantsCount: 23,
          category: 'Двор',
          imageUrl: 'https://picsum.photos/80/80?random=31',
        ),
        ChatRoom(
          id: '3',
          name: 'Чат улицы Ленина',
          description: 'Вопросы благоустройства улицы Ленина',
          lastMessage: 'Дороги действительно нужно ремонтировать',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 3)),
          unreadCount: 5,
          participantsCount: 67,
          category: 'Улица',
          imageUrl: 'https://picsum.photos/80/80?random=32',
        ),
        ChatRoom(
          id: '4',
          name: 'Безопасность района',
          description: 'Обсуждение вопросов безопасности',
          lastMessage: 'Видел подозрительную активность возле школы',
          lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
          unreadCount: 0,
          participantsCount: 89,
          category: 'Безопасность',
          imageUrl: 'https://picsum.photos/80/80?random=33',
        ),
        ChatRoom(
          id: '5',
          name: 'Волонтёрство',
          description: 'Координация волонтёрских мероприятий',
          lastMessage: 'Завтра уборка парка в 10:00',
          lastMessageTime: DateTime.now().subtract(Duration(days: 2)),
          unreadCount: 1,
          participantsCount: 34,
          category: 'Волонтерство',
          imageUrl: 'https://picsum.photos/80/80?random=34',
        ),
        ChatRoom(
          id: '6',
          name: 'Чат подъезда 3',
          description: 'Обсуждение вопросов подъезда №3',
          lastMessage: 'Кто-то оставил мусор в подъезде',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
          unreadCount: 3,
          participantsCount: 28,
          category: 'Подъезд',
          imageUrl: 'https://picsum.photos/80/80?random=35',
        ),
        ChatRoom(
          id: '7',
          name: 'Детская площадка',
          description: 'Родители детей, играющих на площадке',
          lastMessage: 'Нужно починить качели',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 4)),
          unreadCount: 0,
          participantsCount: 15,
          category: 'Дети',
          imageUrl: 'https://picsum.photos/80/80?random=36',
        ),
        ChatRoom(
          id: '8',
          name: 'Парковка',
          description: 'Вопросы парковки и автомобилей',
          lastMessage: 'Кто-то заблокировал выезд',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 6)),
          unreadCount: 7,
          participantsCount: 42,
          category: 'Парковка',
          imageUrl: 'https://picsum.photos/80/80?random=37',
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Соседские чаты'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: _showCreateChatDialog,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadChats,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : _buildChatsList(),
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
            'Ошибка загрузки чатов',
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
            onPressed: _loadChats,
            child: Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList() {
    if (_chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Нет активных чатов',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Создайте новый чат или присоединитесь к существующему',
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showCreateChatDialog,
              child: Text('Создать чат'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _chats.length,
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (ctx, i) => _buildChatTile(_chats[i]),
    );
  }

  Widget _buildChatTile(ChatRoom chat) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openChat(chat),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Аватар чата
              ClipOval(
                child: ThemedImage(
                  title: chat.name,
                  type: 'chat',
                  width: 48,
                  height: 48,
                ),
              ),
              SizedBox(width: 16),
              // Информация о чате
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (chat.unreadCount > 0) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              chat.unreadCount.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      chat.description,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.lastMessage,
                            style: TextStyle(
                              color: chat.unreadCount > 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: chat.unreadCount > 0
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _formatTime(chat.lastMessageTime),
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.5),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${chat.participantsCount} участников',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(ChatRoom chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chat: chat),
      ),
    );
  }

  void _showCreateChatDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Создать новый чат'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Название чата',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите название чата';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание (необязательно)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                _createChat(nameController.text.trim(),
                    descriptionController.text.trim());
              }
            },
            child: Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _createChat(String name, String description) {
    final newChat = ChatRoom(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      lastMessage: 'Чат создан',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      participantsCount: 1,
      category: 'Общий',
    );

    setState(() {
      _chats.insert(0, newChat);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Чат "${name}" успешно создан'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}д';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}ч';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}м';
    } else {
      return 'сейчас';
    }
  }
}

class ChatDetailScreen extends StatefulWidget {
  final ChatRoom chat;

  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.getChatMessages(widget.chat.id);

      if (result['success']) {
        setState(() {
          _messages = (result['messages'] as List)
              .map((msg) => ChatMessage.fromJson(msg))
              .toList();
          _isLoading = false;
        });
      } else {
        // Если API недоступен, используем демо-данные
        _loadDemoMessages();
      }
    } catch (e) {
      // Если ошибка сети, используем демо-данные
      _loadDemoMessages();
    }
  }

  void _loadDemoMessages() {
    setState(() {
      _messages = [
        ChatMessage(
          id: '1',
          chatId: widget.chat.id,
          userId: 'user1',
          userName: 'Анна Петрова',
          message: 'Привет всем! Как дела?',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          isOwn: false,
        ),
        ChatMessage(
          id: '2',
          chatId: widget.chat.id,
          userId: 'user2',
          userName: 'Иван Сидоров',
          message: 'Привет! Всё хорошо, спасибо!',
          timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
          isOwn: false,
        ),
        ChatMessage(
          id: '3',
          chatId: widget.chat.id,
          userId: 'current_user',
          userName: 'Вы',
          message: 'Отлично! Кто-нибудь знает, когда починят лифт?',
          timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
          isOwn: true,
        ),
        ChatMessage(
          id: '4',
          chatId: widget.chat.id,
          userId: 'user3',
          userName: 'Мария Козлова',
          message: 'Слышала, что завтра должны прийти мастера',
          timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
          isOwn: false,
        ),
        ChatMessage(
          id: '5',
          chatId: widget.chat.id,
          userId: 'user4',
          userName: 'Пётр Волков',
          message: 'Наконец-то! Уже неделю хожу пешком на 9-й этаж 😅',
          timestamp: DateTime.now().subtract(Duration(hours: 1)),
          isOwn: false,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chat.name),
            Text(
              '${widget.chat.participantsCount} участников',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showChatInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          // Список сообщений
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Нет сообщений',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Будьте первым, кто напишет!',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageTile(_messages[index]);
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isOwn) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                message.userName[0].toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isOwn
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!message.isOwn) ...[
                  Text(
                    message.userName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 2),
                ],
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isOwn
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: message.isOwn
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatMessageTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          if (message.isOwn) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                'Вы',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Добавляем сообщение в список
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: widget.chat.id,
      userId: 'current_user',
      userName: 'Вы',
      message: message,
      timestamp: DateTime.now(),
      isOwn: true,
    );

    setState(() {
      _messages.add(newMessage);
    });

    _messageController.clear();

    // Прокручиваем к последнему сообщению
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // TODO: Отправить сообщение на сервер
    // ApiService.sendMessage(chatId: widget.chat.id, message: message);
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Информация о чате'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Название: ${widget.chat.name}'),
            SizedBox(height: 8),
            Text('Описание: ${widget.chat.description}'),
            SizedBox(height: 8),
            Text('Участников: ${widget.chat.participantsCount}'),
            SizedBox(height: 8),
            Text('Создан: ${_formatDate(widget.chat.lastMessageTime)}'),
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

  String _formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.day}.${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
