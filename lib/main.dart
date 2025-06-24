import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_glass_ui_design/liquid_glass_ui.dart';
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
final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>(
  (ref) => BookmarksNotifier(),
);

class BookmarksNotifier extends StateNotifier<Set<String>> {
  static const String _boxName = 'bookmarks';
  late final Box<String> _box;

  BookmarksNotifier() : super({}) {
    _initHive();
  }

  Future<void> _initHive() async {
    // Open the Hive box
    _box = await Hive.openBox<String>(_boxName);
    // Load bookmarks from Hive
    state = _box.values.toSet();
  }

  Future<void> toggleBookmark(String newsId) async {
    final newBookmarks = {...state};
    if (newBookmarks.contains(newsId)) {
      newBookmarks.remove(newsId);
      await _box.delete(newsId);
    } else {
      newBookmarks.add(newsId);
      await _box.put(newsId, newsId);
    }
    state = newBookmarks;
  }

  @override
  void dispose() {
    // Close the Hive box
    _box.close();
    super.dispose();
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
// Dummy news data
final List<NewsItem> dummyNews = [
  NewsItem(
    id: '1',
    title: 'Global Markets Surge in Q3 2025',
    content:
        'Global stock markets have shown remarkable resilience in Q3 2025, with major indices like the S&P 500 and FTSE 100 posting consistent gains. Analysts attribute this to strong corporate earnings, stabilizing inflation rates, and renewed investor confidence in tech and renewable energy sectors. Emerging markets, particularly in Southeast Asia, have also seen significant inflows. However, concerns linger about potential interest rate hikes by central banks, which could temper this optimism. Investors are advised to diversify portfolios to mitigate risks in this dynamic economic landscape.',
    category: 'Business',
    imageUrl: 'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3',
  ),
  NewsItem(
    id: '2',
    title: 'Epic Football Finals Thrill Fans',
    content:
        'The 2025 football season finals delivered unforgettable moments, with underdog teams staging stunning upsets. The championship match saw a nail-biting finish, with a last-minute goal securing victory for the challengers. Fans across stadiums and online platforms celebrated the high-energy performances and tactical brilliance displayed by players. Off the pitch, discussions about new talent scouting strategies and the impact of advanced analytics on team selections are gaining traction. The season has set a high bar for 2026, with anticipation already building.',
    category: 'Sports',
    imageUrl: 'https://images.unsplash.com/photo-1516321497487-e288fb19713f',
  ),
  NewsItem(
    id: '3',
    title: 'AI Model Breaks Performance Records',
    content:
        'A groundbreaking AI model, unveiled in 2025, has shattered previous benchmarks in natural language processing and image recognition. Developed by a leading tech consortium, the model boasts unprecedented efficiency, reducing training times by 40% while achieving near-human accuracy. Its applications range from medical diagnostics to autonomous vehicles, sparking excitement across industries. However, ethical concerns about data privacy and job displacement are prompting calls for stricter regulations. The tech community is abuzz with debates on balancing innovation with societal impacts.',
    category: 'Tech',
    imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3',
  ),
  NewsItem(
    id: '4',
    title: 'Renewable Energy Hits Milestone',
    content:
        'In 2025, global renewable energy production reached a historic milestone, accounting for 35% of total energy consumption. Solar and wind projects, particularly in Europe and Asia, have driven this surge, supported by government subsidies and technological advancements in energy storage. Experts predict that continued investment could see renewables overtake fossil fuels by 2035. Challenges remain, including grid infrastructure upgrades and the environmental impact of battery production. The shift is reshaping energy markets and geopolitics, with new leaders emerging in the green economy.',
    category: 'Science',
    imageUrl: 'https://images.unsplash.com/photo-1508514177221-188b645fd5af',
  ),
  NewsItem(
    id: '5',
    title: 'Tech Giants Face Antitrust Scrutiny',
    content:
        'Major tech companies are under intensified antitrust investigations in 2025, as regulators in the US and EU probe monopolistic practices. Allegations include stifling competition, manipulating app store policies, and exploiting user data for unfair advantage. The probes could lead to hefty fines or even forced breakups, reshaping the tech landscape. Industry leaders argue that innovation thrives in competitive markets, but consumer advocates demand stronger oversight. The outcome of these cases will likely set precedents for digital markets globally, influencing future regulations.',
    category: 'Business',
    imageUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa',
  ),
  NewsItem(
    id: '6',
    title: 'Cricket World Cup Sparks Global Fever',
    content:
        'The 2025 Cricket World Cup has captivated audiences worldwide, with thrilling matches showcasing emerging talents and veteran stars. Host nations have reported record tourism and economic boosts, with stadiums packed to capacity. The tournament’s adoption of AI-driven umpiring technology has sparked debates about tradition versus innovation, though it’s reduced human error significantly. Social media is abuzz with fan reactions, memes, and predictions for the finals. The event underscores cricket’s growing global appeal, uniting diverse cultures through sport.',
    category: 'Sports',
    imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
  ),
  NewsItem(
    id: '7',
    title: 'Quantum Computing Leap Forward',
    content:
        'In 2025, researchers achieved a major breakthrough in quantum computing, developing a stable qubit system that operates at room temperature. This advancement could accelerate the commercialization of quantum computers, promising exponential gains in processing power for fields like cryptography, drug discovery, and climate modeling. Tech firms are racing to integrate the technology, but scaling remains a challenge due to high costs and complexity. The discovery has sparked optimism about solving previously intractable problems, though experts caution that widespread adoption is still years away.',
    category: 'Tech',
    imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3',
  ),
  NewsItem(
    id: '8',
    title: 'Climate Summit Yields Bold Pledges',
    content:
        'The 2025 Global Climate Summit concluded with ambitious commitments to cut carbon emissions by 50% by 2030. Participating nations agreed to phase out coal plants and boost funding for climate adaptation in vulnerable regions. Breakthroughs in carbon capture technology were showcased, offering hope for industrial sectors. However, critics argue that enforcement mechanisms are weak, and developing nations need more financial support. The summit highlighted the urgency of collective action as extreme weather events continue to escalate worldwide.',
    category: 'Science',
    imageUrl: 'https://images.unsplash.com/photo-1472214103451-9374bd1c798e',
  ),
  NewsItem(
    id: '9',
    title: 'Retail Sector Embraces AR Shopping',
    content:
        'Augmented Reality (AR) is transforming retail in 2025, with major brands rolling out virtual try-on and in-store navigation tools. Shoppers can now visualize products in their homes or test outfits digitally, boosting online sales by 25%. Retailers report higher customer satisfaction and reduced return rates. However, the technology’s high development costs and accessibility issues limit its reach to smaller businesses. As AR hardware becomes more affordable, experts predict it will redefine the shopping experience, blending physical and digital worlds seamlessly.',
    category: 'Business',
    imageUrl: 'https://images.unsplash.com/photo-1556740714-a8395b3bf30f',
  ),
  NewsItem(
    id: '10',
    title: 'Olympic Preparations in High Gear',
    content:
        'Preparations for the 2026 Winter Olympics are intensifying, with host cities unveiling eco-friendly venues and advanced training facilities. Athletes are leveraging wearable tech to optimize performance, while organizers prioritize sustainability through renewable energy and recycled materials. The games aim to set a new standard for inclusivity, with expanded para-athletic events. Global excitement is building, though logistical challenges like accommodation and security remain. The event is expected to boost local economies and showcase cutting-edge sports technology.',
    category: 'Sports',
    imageUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
  ),
  NewsItem(
    id: '11',
    title: 'Blockchain Reshapes Finance',
    content:
        'Blockchain technology is revolutionizing finance in 2025, with decentralized platforms enabling faster, cheaper cross-border transactions. Major banks are adopting blockchain for secure record-keeping, while cryptocurrencies gain mainstream acceptance. Startups offering blockchain-based lending and insurance are attracting significant investment. However, regulatory hurdles and concerns about energy consumption pose challenges. The technology’s potential to democratize finance is undeniable, but experts warn that scalability and consumer trust must improve for widespread adoption to take hold.',
    category: 'Tech',
    imageUrl: 'https://images.unsplash.com/photo-1516251193007-45ef944ab0c6',
  ),
  NewsItem(
    id: '12',
    title: 'Mars Mission Yields New Data',
    content:
        'NASA’s 2025 Mars rover mission has uncovered evidence of ancient microbial life, igniting excitement in the scientific community. The rover’s advanced sensors detected organic compounds in subsurface rock samples, suggesting Mars was once habitable. Researchers are now planning follow-up missions to retrieve samples for Earth-based analysis. The discovery fuels debates about human colonization and the ethical implications of exploring extraterrestrial ecosystems. Public interest in space exploration is soaring, with private firms like SpaceX accelerating their Mars ambitions.',
    category: 'Science',
    imageUrl: 'https://images.unsplash.com/photo-1541877944-ac82a689dd12',
  ),
  NewsItem(
    id: '13',
    title: 'Automotive Industry Goes Electric',
    content:
        'The automotive sector is undergoing a seismic shift in 2025, with electric vehicles (EVs) accounting for 40% of global sales. Major manufacturers have committed to phasing out internal combustion engines by 2035, driven by stricter emissions regulations and consumer demand. Innovations in battery technology have extended EV range and reduced charging times. However, supply chain disruptions for rare earth metals pose risks. The transition is reshaping job markets, with new opportunities in green manufacturing and infrastructure development.',
    category: 'Business',
    imageUrl: 'https://images.unsplash.com/photo-1554744512-d6c6032d825f',
  ),
  NewsItem(
    id: '14',
    title: 'Tennis Grand Slam Breaks Records',
    content:
        'The 2025 tennis season culminated in a historic Grand Slam, with new champions emerging in both men’s and women’s categories. Record-breaking viewership and ticket sales underscored the sport’s global appeal. Advanced racket materials and AI-driven coaching tools have elevated player performance, sparking debates about technology’s role in traditional sports. Off-court, initiatives to promote diversity and mental health support for athletes gained traction. The season has set a vibrant stage for upcoming tournaments, with fans eagerly awaiting 2026.',
    category: 'Sports',
    imageUrl: 'https://images.unsplash.com/photo-1518291344630-4857135fb425',
  ),
  NewsItem(
    id: '15',
    title: 'Cybersecurity Threats Escalate',
    content:
        'Cybersecurity threats have surged in 2025, with ransomware attacks targeting critical infrastructure and corporations. Hackers are exploiting vulnerabilities in IoT devices and cloud systems, prompting governments to bolster digital defenses. New AI-based security tools are being deployed to detect and neutralize threats in real time. Businesses are investing heavily in employee training and encryption technologies. The rising cost of cyberattacks—estimated at dollar 10 trillion annually—has made cybersecurity a top priority, with calls for global cooperation to combat cybercrime.',
    category: 'Tech',
    imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3',
  ),
  NewsItem(
    id: '16',
    title: 'Ocean Cleanup Breakthrough',
    content:
        'A 2025 ocean cleanup initiative has successfully removed 100,000 tons of plastic from the Pacific Ocean, using autonomous drones and advanced filtration systems. The project, backed by international NGOs and tech firms, aims to clean 50% of the Great Pacific Garbage Patch by 2030. Marine ecosystems are showing signs of recovery, though long-term impacts remain under study. Public awareness campaigns are driving reduced plastic use, but critics argue that systemic changes in manufacturing are needed to address the root causes of ocean pollution.',
    category: 'Science',
    imageUrl: 'https://images.unsplash.com/photo-1513553404607-9881d1be8393',
  ),
  NewsItem(
    id: '17',
    title: 'Luxury Travel Booms Post-Pandemic',
    content:
        'The luxury travel sector is thriving in 2025, with affluent travelers seeking unique, sustainable experiences. Private jet bookings and eco-lodges in remote destinations like Antarctica and the Maldives are at record highs. Travel companies are integrating VR previews and carbon offset programs to attract eco-conscious clients. Despite the boom, labor shortages and rising fuel costs are straining operators. The trend reflects a broader shift toward meaningful travel, with consumers prioritizing experiences over material goods in the post-pandemic era.',
    category: 'Business',
    imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
  ),
  NewsItem(
    id: '18',
    title: 'Esports Industry Sets New Records',
    content:
        'The esports industry smashed revenue records in 2025, surpassing dollar 3 billion globally, driven by sponsorships, streaming, and live events. Major tournaments for games like Valorant and League of Legends drew millions of viewers, rivaling traditional sports. Innovations in VR gaming and blockchain-based rewards are enhancing player and fan engagement. However, concerns about player burnout and inclusivity in competitive gaming persist. The industry’s growth is reshaping entertainment, with esports arenas becoming cultural hubs in major cities.',
    category: 'Sports',
    imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e',
  ),
  NewsItem(
    id: '19',
    title: 'Gene Editing Advances Healthcare',
    content:
        'Gene-editing technologies like CRISPR have made significant strides in 2025, with successful trials treating genetic disorders such as sickle cell anemia. New techniques allow precise edits with minimal off-target effects, raising hopes for curing rare diseases. Biotech firms are securing billions in funding, but ethical dilemmas about designer babies and access disparities are intensifying. Regulatory bodies are working to balance innovation with safety. The breakthroughs signal a new era in personalized medicine, with potential to transform healthcare globally.',
    category: 'Science',
    imageUrl: 'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69',
  ),
  NewsItem(
    id: '20',
    title: 'Metaverse Expands Digital Economy',
    content:
        'The metaverse is reshaping the digital economy in 2025, with virtual worlds driving commerce, education, and social interaction. Companies are investing in immersive platforms where users can work, shop, and attend events using avatars. Blockchain integration ensures secure digital ownership of assets like virtual real estate. Despite the hype, challenges like high hardware costs and privacy concerns limit mass adoption. The metaverse’s growth is fueling debates about its impact on mental health and real-world relationships, with regulators eyeing new policies.',
    category: 'Tech',
    imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3',
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await Hive.initFlutter();
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
        debugShowCheckedModeBanner: false,
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
    final screenHeight =
        MediaQuery.of(context).size.height -
        kToolbarHeight -
        kBottomNavigationBarHeight;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News App',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          semanticsLabel: 'App Title',
        ),
        actions: [
          LiquidSwitch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).state =
                  value ? ThemeMode.dark : ThemeMode.light;
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
                  ? 'https://images.unsplash.com/photo-1531415074968-036ba1b575da'
                  : _selectedIndex == 2
                  ? 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3'
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
                icons: const [
                  Icons.list,
                  Icons.sports,
                  Icons.computer,
                  Icons.bookmark,
                ],
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
    final newsItems =
        category == 'All'
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
              semanticsLabel: 'News Card ${news.title}',
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

                    Center(
                      child: Image.network(
                        news.imageUrl,
                        width: 180,
                        height: 150,
                      ),
                    ),
                    LiquidText(
                      text: news.content,
                      semanticsLabel: 'News Content ${news.content}',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
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
                                ref
                                    .read(bookmarksProvider.notifier)
                                    .toggleBookmark(news.id);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
        final bookmarkedNews =
            dummyNews.where((news) => bookmarks.contains(news.id)).toList();

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
                  semanticsLabel: 'News Card ${news.title}',
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
                              onTap: () => print('Read ${news.title}'),
                              semanticsLabel: 'Read More ${news.title}',
                              child: const Text(
                                'Read More',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.bookmark,
                                color: AppColors.indigo600,
                              ),
                              onPressed: () {
                                ref
                                    .read(bookmarksProvider.notifier)
                                    .toggleBookmark(news.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
