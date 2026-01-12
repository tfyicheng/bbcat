import 'package:bbcat/services/isar_service.dart';
import 'package:bbcat/services/sync_service.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../services/summary_service.dart';
import '../widgets/video_player_component.dart';

class SummaryPage extends StatefulWidget {
  final Isar isar;
  const SummaryPage({super.key, required this.isar});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSummaryData();
  }

  Future<void> _loadSummaryData() async {
    setState(() => _isLoading = true);

    // 从设置中读取限制条数
    final settings = await IsarService.getSetting('summary_limit');
    int limit = int.tryParse(settings ?? '') ?? 200;

    final result = await SummaryService.getAggregatedData(limit);

    setState(() {
      _data = result;
      _isLoading = false;
    });
    _syncSummaryData();
  }

  Future<void> _syncSummaryData() async {
    String msg = await SyncService.syncFromSummary(widget.isar);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("汇总数据 (${_data.length})"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSummaryData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1.0,
              ),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final item = _data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerComponent(
                          isar: widget.isar,
                          videoData: item,
                        ),
                      ),
                    );
                  },
                  child: _buildCard(item), // 这里复用你带圆角的卡片代码
                );
              },
            ),
    );
  }

  Widget _buildCard(item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(0),
      child: Stack(
        children: [
          Positioned.fill(child: Image.network(item['img'], fit: BoxFit.cover)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              child: Text(
                item['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
