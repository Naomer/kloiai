import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:remixicon/remixicon.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  final ScrollController _scrollController = ScrollController();
  bool _isFocused = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _isFocused = true;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final suggestions = _query.isEmpty
        ? _defaultSuggestions
        : _searchSuggestions(_query);

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: _isFocused ? 10 : 10,
        centerTitle: !_isFocused,

        leadingWidth: 0, // no arrow
        leading: const SizedBox.shrink(),

        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
          ),
          child: Row(
            children: [
              Icon(
                RemixIcons.search_line,
                color: isDark ? Colors.white60 : Colors.black45,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                  ),
                  style: const TextStyle(fontSize: 13),
                  onChanged: (v) => setState(() => _query = v.trim()),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => setState(() => _query = v.trim()),
                ),
              ),
            ],
          ),
        ),

        // CANCEL button
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 14,
                    //fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],

        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: NotificationListener<UserScrollNotification>(
              onNotification: (n) {
                if (n.direction != ScrollDirection.idle) {
                  _focusNode.unfocus();
                  setState(() => _isFocused = false);
                }
                return false;
              },
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final s = suggestions[index];
                  return _SuggestionCard(text: s);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _searchSuggestions(String query) {
    final q = query.toLowerCase();
    return _defaultSuggestions
        .where((e) => e.toLowerCase().contains(q))
        .toList();
  }
}

const _defaultSuggestions = [
  'Flutter developer',
  'SaaS dashboard',
  'Mobile performance',
  'UX researcher',
  'AI tools',
  'Upwork jobs',
  'LinkedIn leads',
];

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              RemixIcons.search_2_line,
              size: 18,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ).copyWith(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            RemixIcons.arrow_right_up_line,
            size: 18,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ],
      ),
    );
  }
}

class _TopCircleIcon extends StatelessWidget {
  const _TopCircleIcon({required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.06),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: 18,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }
}
