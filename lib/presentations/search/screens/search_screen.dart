/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/cubit/search_cubit.dart';
import 'package:presentation/cubit/search_state.dart';
import 'package:presentation/widgets/web_result_card.dart';
import 'package:presentation/widgets/image_result_card.dart';
import 'package:presentation/widgets/video_result_card.dart';
import 'package:presentation/widgets/news_result_card.dart';
import 'package:core/constants/app_color_schemes.dart';

/// Ana arama ekranı widget'ı
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  
  // Sekme bilgileri
  final List<Tab> _tabs = const [
    Tab(text: 'Web', icon: Icon(Icons.public)),
    Tab(text: 'Resimler', icon: Icon(Icons.image)),
    Tab(text: 'Videolar', icon: Icon(Icons.video_library)),
    Tab(text: 'Haberler', icon: Icon(Icons.article)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Arama yapan metot - aktif sekmeye göre farklı arama türü çalıştırır
  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final cubit = context.read<SearchCubit>();
    
    switch (_tabController.index) {
      case 0:
        cubit.searchWeb(query);
        break;
      case 1:
        cubit.searchImages(query);
        break;
      case 2:
        cubit.searchVideos(query);
        break;
      case 3:
        cubit.searchNews(query);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brave Arama'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      
      body: Column(
        children: [
          // Arama kutusu
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).colorScheme.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Arama yapın...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchCubit>().clearResults();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          
          // Sonuçlar
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWebResults(), // Web sonuçları
                _buildImageResults(), // Resim sonuçları
                _buildVideoResults(), // Video sonuçları
                _buildNewsResults(), // Haber sonuçları
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Web sonuçları widget'ını oluşturur
  Widget _buildWebResults() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const Center(
            child: Text('Web araması yapmak için yukarıdaki kutuyu kullanın'),
          );
        }
        
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SearchError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }
        
        if (state is SearchSuccess) {
          if (state.results.isEmpty) {
            return const Center(child: Text('Sonuç bulunamadı'));
          }
          
          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              return WebResultCard(result: state.results[index] as SearchResult);
            },
          );
        }
        
        return const SizedBox();
      },
    );
  }

  /// Resim sonuçları widget'ını oluşturur
  Widget _buildImageResults() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const Center(
            child: Text('Resim araması yapmak için yukarıdaki kutuyu kullanın'),
          );
        }
        
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SearchError) {
          return Center(child: Text(state.message));
        }
        
        if (state is SearchSuccess) {
          if (state.results.isEmpty) {
            return const Center(child: Text('Sonuç bulunamadı'));
          }
          
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              return ImageResultCard(result: state.results[index] as ImageResult);
            },
          );
        }
        
        return const SizedBox();
      },
    );
  }

  /// Video sonuçları widget'ını oluşturur
  Widget _buildVideoResults() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const Center(
            child: Text('Video araması yapmak için yukarıdaki kutuyu kullanın'),
          );
        }
        
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SearchError) {
          return Center(child: Text(state.message));
        }
        
        if (state is SearchSuccess) {
          if (state.results.isEmpty) {
            return const Center(child: Text('Sonuç bulunamadı'));
          }
          
          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              return VideoResultCard(result: state.results[index] as VideoResult);
            },
          );
        }
        
        return const SizedBox();
      },
    );
  }

  /// Haber sonuçları widget'ını oluşturur
  Widget _buildNewsResults() {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const Center(
            child: Text('Haber araması yapmak için yukarıdaki kutuyu kullanın'),
          );
        }
        
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is SearchError) {
          return Center(child: Text(state.message));
        }
        
        if (state is SearchSuccess) {
          if (state.results.isEmpty) {
            return const Center(child: Text('Sonuç bulunamadı'));
          }
          
          return ListView.builder(
            itemCount: state.results.length,
            itemBuilder: (context, index) {
              return NewsResultCard(result: state.results[index] as NewsResult);
            },
          );
        }
        
        return const SizedBox();
      },
    );
  }
}
*/