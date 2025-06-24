import 'package:flutter/material.dart';
import 'package:liquid_glass_ui_design/liquid_glass_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define indigo color palette
class AppColors {
  static const indigo50 = Color(0xFFE8EAF6);
  static const indigo100 = Color(0xFFC5CAE9);
  static const indigo200 = Color(0xFF9FA8DA);
  static const indigo300 = Color(0xFF7986CB);
  static const indigo400 = Color(0xFF5C6BC0);
  static const indigo500 = Color(0xFF3F51B5);
  static const indigo600 = Color(0xFF3949AB);
  static const indigo700 = Color(0xFF303F9F);
  static const indigo800 = Color(0xFF283593);
  static const indigo900 = Color(0xFF1A237E);
}

// Theme provider
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// Bookmarks provider
final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>((ref) => BookmarksNotifier());

class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier() : super({}) {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList('bookmarks')?.toSet() ?? {};
  }

  Future<void> toggleBookmark(String newsId) async {
    final newBookmarks = {...state};
    if (newBookmarks.contains(newsId)) {
      newBookmarks.remove(newsId);
    } else {
      newBookmarks.add(newsId);
    }
    state = newBookmarks;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', newBookmarks.toList());
  }
}

// News data model
class NewsItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final String imageUrl;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.imageUrl,
  });
}

// Dummy news data
final List<NewsItem> dummyNews = [
  NewsItem(
    id: '1',
    title: 'Global Market Update',
    content: 'Stock markets show steady growth in Q3 2025.',
    category: 'All',
    imageUrl: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3',
  ),
  NewsItem(
    id: '2',
    title: 'Football Finals Recap',
    content: 'Exciting matches in the 2025 season finals.',
    category: 'Sports',
    imageUrl: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f',
  ),
  NewsItem(
    id: '3',
    title: 'AI Breakthrough',
    content: 'New AI model achieves record performance.',
    category: 'Tech',
    imageUrl: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f',
  ),
];

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return LiquidThemeProvider(
      theme: LiquidTheme(
        primaryColor: AppColors.indigo50.withOpacity(0.9),
        accentColor: AppColors.indigo600,
        blurStrength: 10.0,
        borderRadius: 12.0,
        textStyle: const TextStyle(
          fontFamily: 'SFPro',
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        defaultPadding: const EdgeInsets.all(12.0),
        defaultMargin: const EdgeInsets.all(8.0),
      ),
      child: MaterialApp(
        title: 'Liquid Glass News App',
        theme: ThemeData.light().copyWith(
          primaryColor: AppColors.indigo500,
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.indigo50.withOpacity(0.8),
            foregroundColor: AppColors.indigo900,
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: AppColors.indigo700,
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.indigo900.withOpacity(0.8),
            foregroundColor: AppColors.indigo50,
          ),
        ),
        themeMode: themeMode,
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const LiquidText(
          text: 'News App',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          semanticsLabel: 'App Title',
        ),
        actions: [
          LiquidSwitch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).state = value ? ThemeMode.dark : ThemeMode.light;
            },
            semanticsLabel: 'Theme Toggle',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              _selectedIndex == 0
                  ? 'https://images.unsplash.com/photo-1504711434969-e33886168f5c'
                  : _selectedIndex == 1
                  ? 'https://images.unsplash.com/photo-1516321497487-e288fb19713f'
                  : _selectedIndex == 2
                  ? 'https://images.unsplash.com/photo-1516321497487-e288fb19713f'
                  : 'https://images.unsplash.com/photo-1504711434969-e33886168f5c',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    SizedBox(child: _buildNewsTab('All')),
                    SizedBox(child: _buildNewsTab('Sports')),
                    SizedBox(child: _buildNewsTab('Tech')),
                    SizedBox(child: _buildBookmarksTab()),
                  ],
                ),
              ),
              LiquidBottomNav(
                icons: const [Icons.list, Icons.sports, Icons.computer, Icons.bookmark],
                onItemSelected: _onItemSelected,
                semanticsLabel: 'News Navigation',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsTab(String category) {
    final newsItems = category == 'All'
        ? dummyNews
        : dummyNews.where((item) => item.category == category).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiquidText(
            text: category,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            semanticsLabel: '$category Title',
          ),
          const SizedBox(height: 16),
          for (var news in newsItems)
            LiquidCard(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LiquidText(
                      text: news.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      semanticsLabel: 'News Title ${news.title}',
                    ),
                    const SizedBox(height: 8),
                    LiquidText(
                      text: news.content,
                      semanticsLabel: 'News Content ${news.content}',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LiquidButton(
                          child: const Text(
                            'Read More',
                            style: TextStyle(color: Colors.black87),
                          ),
                          onTap: () => print('Read ${news.title}'),
                          semanticsLabel: 'Read More ${news.title}',
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final bookmarks = ref.watch(bookmarksProvider);
                            return IconButton(
                              icon: Icon(
                                bookmarks.contains(news.id)
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: AppColors.indigo600,
                              ),
                              onPressed: () {
                                ref.read(bookmarksProvider.notifier).toggleBookmark(news.id);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              semanticsLabel: 'News Card ${news.title}',
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBookmarksTab() {
    return Consumer(
      builder: (context, ref, child) {
        final bookmarks = ref.watch(bookmarksProvider);
        final bookmarkedNews = dummyNews.where((news) => bookmarks.contains(news.id)).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LiquidText(
                text: 'Bookmarked News',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                semanticsLabel: 'Bookmarked News Title',
              ),
              const SizedBox(height: 16),
              if (bookmarkedNews.isEmpty)
                const LiquidText(
                  text: 'No bookmarked news yet.',
                  semanticsLabel: 'No Bookmarks Message',
                ),
              for (var news in bookmarkedNews)
                LiquidCard(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LiquidText(
                          text: news.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          semanticsLabel: 'News Title ${news.title}',
                        ),
                        const SizedBox(height: 8),
                        LiquidText(
                          text: news.content,
                          semanticsLabel: 'News Content ${news.content}',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LiquidButton(
                              child: const Text(
                                'Read More',
                                style: TextStyle(color: Colors.black87),
                              ),
                              onTap: () => print('Read ${news.title}'),
                              semanticsLabel: 'Read More ${news.title}',
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.bookmark,
                                color: AppColors.indigo600,
                              ),
                              onPressed: () {
                                ref.read(bookmarksProvider.notifier).toggleBookmark(news.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  semanticsLabel: 'News Card ${news.title}',
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}