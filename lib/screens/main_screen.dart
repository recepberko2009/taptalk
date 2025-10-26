// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 ? _buildChatsAppBar() : null,
      body: _buildCurrentScreen(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildChatsAppBar() {
    return AppBar(
      title: Text(
        'TapTalk',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 1,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.blue),
          onPressed: () {
            // Arama sayfasına git
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.blue),
          onSelected: (value) {
            _handlePopupMenuSelection(value);
          },
          itemBuilder: (BuildContext context) {
            return {'Çıkış Yap', 'Ayarlar', 'Yeni Grup'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.blue,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: 'Sohbetler'),
          Tab(text: 'Durum'),
          Tab(text: 'Topluluk'),
          Tab(text: 'Aramalar'),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildChatsScreen();
      case 1:
        return _buildStatusScreen();
      case 2:
        return _buildCommunityScreen();
      case 3:
        return _buildCallsScreen();
      default:
        return _buildChatsScreen();
    }
  }

  Widget _buildChatsScreen() {
    return TabBarView(
      controller: _tabController,
      children: [
        // Sohbetler Tab
        ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return _buildChatItem(index);
          },
        ),
        // Durum Tab
        _buildStatusTab(),
        // Topluluk Tab
        _buildCommunityTab(),
        // Aramalar Tab
        _buildCallsTab(),
      ],
    );
  }

  Widget _buildChatItem(int index) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue.withOpacity(0.3),
        ),
        child: Center(
          child: Text(
            'K${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ),
      title: Text(
        'Kullanıcı ${index + 1}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Son mesaj buraya gelecek...',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '12:30',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // Sohbet ekranına git
        _openChat(context, index);
      },
    );
  }

  Widget _buildStatusScreen() {
    return Column(
      children: [
        // Kendi status
        ListTile(
          leading: Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Icon(Icons.person, color: Colors.grey[600]),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          title: Text(
            'Durumum',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Durumunu eklemek için dokun'),
        ),
        Divider(),
        // Son güncellemeler
        Padding(
          padding: EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Son güncellemeler',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 2),
                    color: Colors.blue.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Text(
                      'U${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'Kullanıcı ${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${index + 10} dakika önce'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            'Topluluklar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Topluluklarını burada görüntüle ve yönet',
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Yeni topluluk oluştur
            },
            child: Text('Yeni Topluluk Oluştur'),
          ),
        ],
      ),
    );
  }

  Widget _buildCallsScreen() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                'A${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          title: Text(
            'Kullanıcı ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              Icon(
                index % 3 == 0 ? Icons.call_made : Icons.call_received,
                size: 14,
                color: index % 3 == 0 ? Colors.green : Colors.red,
              ),
              SizedBox(width: 4),
              Text('${index + 1} Eylül, 12:${30 + index}'),
            ],
          ),
          trailing: Icon(
            index % 2 == 0 ? Icons.videocam : Icons.call,
            color: Colors.blue,
          ),
        );
      },
    );
  }

  Widget _buildStatusTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kendi status
        _buildMyStatus(),
        // Son güncellemeler
        _buildRecentUpdates(),
      ],
    );
  }

  Widget _buildMyStatus() {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, color: Colors.grey[600]),
        ),
        title: Text('Durumum', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Durum eklemek için dokunun'),
        trailing: Icon(Icons.camera_alt, color: Colors.blue),
        onTap: () {
          // Durum ekleme
        },
      ),
    );
  }

  Widget _buildRecentUpdates() {
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue.withOpacity(0.2),
              child: Text(
                'U${index + 1}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            title: Text('Kullanıcı ${index + 1}'),
            subtitle: Text('${index * 2} saat önce'),
          );
        },
      ),
    );
  }

  Widget _buildCommunityTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            'Topluluklarını Yönet',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Yeni Topluluk Başlat'),
          ),
        ],
      ),
    );
  }

  Widget _buildCallsTab() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Text(
              'A${index + 1}',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          title: Text('Kullanıcı ${index + 1}'),
          subtitle: Text('Dün ${12 + index}:30'),
          trailing: Icon(
            index % 2 == 0 ? Icons.video_call : Icons.phone,
            color: Colors.blue,
          ),
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Sohbetler',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.photo_library),
          label: 'Durum',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Topluluk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.call),
          label: 'Aramalar',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    switch (_currentIndex) {
      case 0: // Sohbetler
        return FloatingActionButton(
          onPressed: () {
            _showNewChatOptions(context);
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.chat),
        );
      case 1: // Durum
        return FloatingActionButton(
          onPressed: () {
            // Yeni durum ekle
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.camera_alt),
        );
      case 2: // Topluluk
        return FloatingActionButton(
          onPressed: () {
            // Yeni topluluk oluştur
          },
          backgroundColor: Colors.purple,
          child: Icon(Icons.group_add),
        );
      case 3: // Aramalar
        return FloatingActionButton(
          onPressed: () {
            // Yeni arama yap
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.add_call),
        );
      default:
        return FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.blue,
          child: Icon(Icons.chat),
        );
    }
  }

  void _showNewChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.blue),
              title: Text('Yeni Sohbet'),
              onTap: () {
                Navigator.pop(context);
                // Yeni sohbet ekranına git
              },
            ),
            ListTile(
              leading: Icon(Icons.group, color: Colors.green),
              title: Text('Yeni Grup'),
              onTap: () {
                Navigator.pop(context);
                // Yeni grup oluştur
              },
            ),
          ],
        );
      },
    );
  }

  void _openChat(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userName: 'Kullanıcı ${index + 1}',
          userId: 'user_$index',
        ),
      ),
    );
  }

  void _handlePopupMenuSelection(String value) {
    switch (value) {
      case 'Çıkış Yap':
        _signOut();
        break;
      case 'Ayarlar':
        // Ayarlar sayfasına git
        break;
      case 'Yeni Grup':
        // Yeni grup oluştur
        break;
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}

// Geçici Chat Screen
class ChatScreen extends StatelessWidget {
  final String userName;
  final String userId;

  const ChatScreen({super.key, required this.userName, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.3),
              child: Text(
                userName[0],
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName),
                Text(
                  'çevrimiçi',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return {'Bilgi', 'Sil', 'Blokla'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Sohbet ekranı burada olacak\n\n($userName ile sohbet)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.emoji_emotions, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Mesaj yazın...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}