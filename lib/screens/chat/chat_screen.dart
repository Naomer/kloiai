import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../data/services/open_router_service.dart';
import '../../data/history_store.dart';
import '../../widgets/glass_widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Map<String, String>> _modelOptions = const [
    {'label': 'Auto', 'id': 'auto'},
    {'label': 'Gemini 2.0 Flash', 'id': 'google/gemini-2.0-flash-001'},
    {'label': 'Gemini Flash 1.5', 'id': 'google/gemini-flash-1.5'},
    {'label': 'Gemini Pro 1.5', 'id': 'google/gemini-pro-1.5'},
    {'label': 'Llama 3.1 8B', 'id': 'meta-llama/llama-3.1-8b-instruct'},
    {'label': 'Mistral 7B', 'id': 'mistralai/mistral-7b-instruct'},
    {'label': 'Qwen 2.5 7B', 'id': 'qwen/qwen2.5-7b-instruct'},
    {'label': 'Phi-3 Mini', 'id': 'microsoft/phi-3-mini-128k-instruct'},
  ];
  String _modelSelection = 'auto';
  String? _activeModelId;
  bool isRecording = false;
  bool isSpeechAvailable = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  String _lastWords = '';
  late final OpenRouterService openRouterService;
  bool _isSpeaking = false;
  String _currentStreamingResponse = '';
  bool _isStreaming = false;
  StreamSubscription<String>? _currentStreamSubscription;
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;
  final FocusNode inputFocusNode = FocusNode();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusManager.instance.primaryFocus?.unfocus();
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        inputFocusNode.unfocus();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.addListener(() {
      setState(() {});
    });
    _initSpeech();
    _initTts();
    final key = dotenv.isInitialized
        ? (dotenv.env['OPENROUTER_API_KEY'] ?? '')
        : '';
    openRouterService = OpenRouterService(apiKey: key);

    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final initialPrompt = args?['initialPrompt'] as String?;
      if (initialPrompt != null && initialPrompt.trim().isNotEmpty) {
        sendMessage(initialPrompt);
      }
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
    _flutterTts.setErrorHandler((_) {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _speakText(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      await _flutterTts.speak(text);
    }
  }

  Future<void> _initSpeech() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isDenied) {
        setState(() {
          isSpeechAvailable = false;
        });
        return;
      }
      final available = await _speech.initialize(
        onError: (_) {
          setState(() {
            isSpeechAvailable = false;
            isRecording = false;
          });
        },
        onStatus: (status) {
          if (status == 'done') {
            setState(() {
              isRecording = false;
            });
          }
        },
        debugLogging: true,
      );
      setState(() {
        isSpeechAvailable = available;
      });
    } catch (_) {
      setState(() {
        isSpeechAvailable = false;
      });
    }
  }

  void toggleRecording() async {
    if (!isSpeechAvailable) {
      FocusScope.of(context).requestFocus(FocusNode());
      return;
    }
    try {
      if (!isRecording) {
        setState(() {
          isRecording = true;
          _lastWords = '';
        });
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _lastWords = result.recognizedWords;
              if (result.finalResult) {
                controller.text = _lastWords;
                isRecording = false;
              }
            });
          },
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          localeId: 'en_US',
          cancelOnError: true,
          listenMode: stt.ListenMode.confirmation,
        );
      } else {
        setState(() {
          isRecording = false;
        });
        await _speech.stop();
      }
    } catch (_) {
      setState(() {
        isRecording = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    inputFocusNode.dispose();
    scrollController.dispose();
    _speech.stop();
    _flutterTts.stop();
    _typingAnimationController.dispose();
    _currentStreamSubscription?.cancel();
    super.dispose();
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    if (_isStreaming) {
      _currentStreamSubscription?.cancel();
      setState(() {
        _isStreaming = false;
        _currentStreamingResponse = '';
      });
    }
    FocusScope.of(context).unfocus();
    setState(() {
      messages.add({'text': text, 'isUser': true});
      messages.add({
        'text': '',
        'isUser': false,
        'isLiked': false,
        'isDisliked': false,
      });
      _isStreaming = true;
      _currentStreamingResponse = '';
    });
    controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    try {
      final conversationHistory = <Map<String, String>>[];
      String? lastRole;
      String? lastContent;
      for (var i = 0; i < messages.length - 1; i++) {
        final message = messages[i];
        final rawText = (message['text'] ?? '').toString();
        final cleaned = rawText.trim();
        if (cleaned.isEmpty) continue;
        final role = message['isUser'] == true ? 'user' : 'assistant';
        if (lastRole == role && lastContent == cleaned) continue;
        conversationHistory.add({'role': role, 'content': cleaned});
        lastRole = role;
        lastContent = cleaned;
      }
      final preferred = _modelSelection == 'auto' ? null : _modelSelection;
      _currentStreamSubscription = openRouterService
          .generateStreamingResponse(
            text,
            conversationHistory: conversationHistory,
            preferredModelId: preferred,
            onModelSelected: (m) {
              if (_activeModelId != m) {
                setState(() => _activeModelId = m);
              }
            },
          )
          .listen(
            (chunk) {
              if (!_isStreaming) return;
              setState(() {
                _currentStreamingResponse += chunk;
                messages.last = {
                  'text': _currentStreamingResponse,
                  'isUser': false,
                  'isLiked': messages.last['isLiked'] ?? false,
                };
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
            onError: (_) {
              if (!_isStreaming) return;
              setState(() {
                if (_currentStreamingResponse.trim().isEmpty) {
                  messages.last = {
                    'text': 'Sorry, an error occurred. Please try again.',
                    'isUser': false,
                    'isLiked': false,
                    'isDisliked': false,
                  };
                }
              });
            },
            onDone: () {
              final entry = HistoryEntry(
                prompt: text,
                reply: _currentStreamingResponse,
                timestamp: DateTime.now(),
                modelId: _activeModelId,
              );
              HistoryStore.instance.addEntry(entry);
            },
          );
      await _currentStreamSubscription?.asFuture();
    } catch (_) {
      setState(() {
        if (_currentStreamingResponse.trim().isEmpty) {
          messages.last = {
            'text': 'Sorry, an error occurred. Please try again.',
            'isUser': false,
            'isLiked': false,
          };
        }
      });
    } finally {
      setState(() {
        _isStreaming = false;
      });
    }
  }

  Widget buildTypingIndicator() {
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: _typingAnimation.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget buildMessage(Map<String, dynamic> msg, int index) {
    final isUser = msg['isUser'] == true;
    final isLiked = msg['isLiked'] ?? false;
    final isDisliked = msg['isDisliked'] ?? false;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isUser ? 29 * 8.0 : double.infinity,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isUser ? 14 : 5,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? (isDark ? Colors.grey[900] : Colors.grey[200])
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: !isUser && msg['text'].isEmpty && _isStreaming
                      ? buildTypingIndicator()
                      : Text(
                          msg['text'],
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ],
          ),
          if (!isUser && msg['text'].isNotEmpty && !_isStreaming) ...[
            Padding(
              padding: const EdgeInsets.only(left: 0, top: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: msg['text']));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -17),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: PhosphorIcon(
                          PhosphorIcons.copySimple(),
                          size: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        if (messages[index]['isLiked'] == true) {
                          messages[index]['isLiked'] = false;
                        } else {
                          messages[index]['isLiked'] = true;
                          messages[index]['isDisliked'] = false;
                        }
                      });
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -17),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: PhosphorIcon(
                          PhosphorIcons.thumbsUp(),
                          size: 14,
                          color: isLiked
                              ? Colors.blue
                              : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        if (messages[index]['isDisliked'] == true) {
                          messages[index]['isDisliked'] = false;
                        } else {
                          messages[index]['isDisliked'] = true;
                          messages[index]['isLiked'] = false;
                        }
                      });
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -17),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: PhosphorIcon(
                          PhosphorIcons.thumbsDown(),
                          size: 14,
                          color: isDisliked
                              ? Colors.red
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _speakText(msg['text']),
                    child: Transform.translate(
                      offset: const Offset(0, -17),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: PhosphorIcon(
                          _isSpeaking
                              ? PhosphorIcons.stop()
                              : PhosphorIcons.speakerHigh(),
                          size: 14,
                          color: _isSpeaking
                              ? Colors.blue
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 48,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GlassCircleIcon(
            child: PhosphorIcon(PhosphorIcons.arrowLeft()),
            onTap: () => Navigator.of(context).pop(),
            diameter: 29,
            iconSize: 16,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: isDark
                  ? Colors.black.withOpacity(0.60)
                  : Colors.white.withOpacity(0.08),
            ),
          ),
        ),

        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _modelSelection,
            isDense: true,
            icon: const SizedBox.shrink(),
            dropdownColor: isDark ? Colors.black : Colors.white,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            alignment: Alignment.center,
            selectedItemBuilder: (context) {
              return _modelOptions.map((opt) {
                final label = opt['label']!;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    PhosphorIcon(
                      PhosphorIcons.caretDown(),
                      size: 14,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ],
                );
              }).toList();
            },
            items: _modelOptions
                .map(
                  (opt) => DropdownMenuItem<String>(
                    value: opt['id'],
                    child: Text(
                      opt['label']!,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              if (val == null) return;
              setState(() => _modelSelection = val);
            },
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 90, bottom: 140),
              itemCount: messages.length,
              itemBuilder: (_, index) => buildMessage(messages[index], index),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.black.withOpacity(0.04),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 0,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: 4 * 16 * 1.4 + 24,
                                minHeight: 1 * 16 * 1.4 + 24,
                              ),
                              child: SingleChildScrollView(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Icon(
                                        RemixIcons.attachment_2,
                                        size: 20,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextField(
                                        controller: controller,
                                        focusNode: inputFocusNode,
                                        maxLines: null,
                                        minLines: 1,
                                        textInputAction:
                                            TextInputAction.newline,
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          height: 1.4,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: isRecording
                                              ? 'Listening...'
                                              : 'Ask anything...',
                                          hintStyle: TextStyle(
                                            color: isRecording
                                                ? Colors.red
                                                : (isDark
                                                      ? Colors.white60
                                                      : Colors.black54),
                                            fontSize: 16,
                                            height: 1.4,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 12,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          GestureDetector(
                            onTap: () {
                              if (_isStreaming) {
                                _currentStreamSubscription?.cancel();
                                setState(() {
                                  _isStreaming = false;
                                });
                              } else if (controller.text.isNotEmpty) {
                                sendMessage(controller.text);
                              } else if (isSpeechAvailable) {
                                toggleRecording();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isStreaming
                                    ? Colors.grey
                                    : (isRecording
                                          ? Colors.red
                                          : (isDark
                                                ? Colors.white
                                                : Colors.black)),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isStreaming
                                    ? Icons.stop_rounded
                                    : (!isSpeechAvailable ||
                                              controller.text.isNotEmpty
                                          ? Icons.arrow_upward_rounded
                                          : (isRecording
                                                ? Icons.stop_rounded
                                                : RemixIcons.mic_2_line)),
                                color: (_isStreaming || isRecording)
                                    ? Colors.white
                                    : (isDark ? Colors.black87 : Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
