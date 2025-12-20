import 'dart:async';

/// Very small stub of the OpenRouterService to keep the chat UI working.
///
/// Later you can replace this with real calls to OpenRouter (or any LLM
/// provider like DeepSeek / Groq / HuggingFace) without touching the UI.
class OpenRouterService {
  OpenRouterService({required this.apiKey});

  final String apiKey;

  /// Simulates a streaming response from an LLM.
  ///
  /// For now this just emits a short, hard-coded reply in chunks so that
  /// the typing/streaming UI works and nothing crashes.
  Stream<String> generateStreamingResponse(
    String prompt, {
    required List<Map<String, String>> conversationHistory,
    String? preferredModelId,
    void Function(String modelId)? onModelSelected,
  }) async* {
    // Report a "selected" model to the UI.
    onModelSelected?.call(preferredModelId ?? 'mock-model');

    const reply =
        'This is a placeholder KLOI response. '
        'Later this will come from a real LLM via OpenRouter or Groq/DeepSeek.';

    // Emit the text in chunks to mimic streaming.
    const chunkSize = 25;
    for (var i = 0; i < reply.length; i += chunkSize) {
      await Future.delayed(const Duration(milliseconds: 80));
      yield reply.substring(i, i + chunkSize > reply.length ? reply.length : i + chunkSize);
    }
  }
}


