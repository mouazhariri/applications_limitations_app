import 'dart:convert';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:applications_limitations/src/infrastructure/api/endpoint/services_urls.dart';
import 'package:applications_limitations/src/infrastructure/network/services/network_service.dart';
import 'package:applications_limitations/src/logger/log_services/dev_logger.dart';
import 'package:translator_plus/translator_plus.dart';

class GeminiService {
  final NetworkService? networkService;
  // final String apiKey;

  GeminiService( {this.networkService});

  // ─── Base Model Builder ─────────────────────────────────────────────────────
  GenerativeModel _buildModel({String? systemInstruction}) {
    return GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: ServicesUrls.aiApiKey,
      systemInstruction: systemInstruction != null
          ? Content.text(systemInstruction)
          : null,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
      ),
    );
  }

  List<SafetySetting> get _safetySettings => [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ];

        // ─── Doctor Chat with RAG Context ──────────────────────────────────────────

 Future<String> askDoctor(
    String question, {
    String? ragContext,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final model = _buildModel(
        systemInstruction: '''
You are Dr. AI, a professional medical assistant integrated into a doctor support application.

${ragContext != null && ragContext.isNotEmpty ? ragContext : ''}

Core Rules:
- Never provide a final diagnosis
- Use markdown formatting with proper headings (##, ###)
- Use numbered lists for steps/instructions
- Use bullet points for symptoms/notes
- Highlight **warnings** and **⚠️ emergencies** prominently
- Always recommend consulting a healthcare professional
- Be empathetic, clear, and professional
- Reference past conversation context when relevant
- If OCR text is provided, analyze it carefully

Response Structure:
1. Brief acknowledgment
2. Main information with clear sections
3. Important warnings if any
4. Recommendation to see a doctor
''',
      );

      // Build conversation parts with history
      final parts = <Part>[];

      if (conversationHistory != null && conversationHistory.isNotEmpty) {
        // Add recent history as context (last 10 exchanges)
        final recentHistory = conversationHistory.length > 20
            ? conversationHistory.sublist(conversationHistory.length - 20)
            : conversationHistory;

        for (final entry in recentHistory) {
          parts.add(TextPart(
            '${entry['role'] == 'user' ? 'Patient' : 'Dr. AI'}: ${entry['content']}',
          ));
        }
        parts.add(TextPart('\nCurrent question: $question'));
      } else {
        parts.add(TextPart(question));
      }

      final response = await model.generateContent(
        [Content.multi(parts)],
        safetySettings: _safetySettings,
      );

      return response.text ?? 'No response received.';
    } catch (e) {
      Dev.logError('askDoctorE: $e');
      return 'Something went wrong. Please try again.';
    }
  }
  // ─── Analyze File / PDF ────────────────────────────────────────────────────
Future<String> analyzeFile({
    required Uint8List fileBytes,
    required String mimeType,
    required String fileName,
    String? userContext,
    String? ocrText, // OCR extracted text for PDFs
    String? ragContext,
  }) async {
    try {
      final model = _buildModel(
        systemInstruction: '''
You are Dr. AI analyzing a medical document.
${ragContext ?? ''}

Analysis Guidelines:
- Extract ALL key medical information
- List lab values with normal ranges
- Identify medications and dosages
- Note diagnoses and recommendations
- Highlight **abnormal values** prominently
- Use clear markdown formatting
- Compare with past records if context provided
''',
      );

      final parts = <Part>[];

      // Add the file if it's not a PDF (PDFs use OCR text)
      if (mimeType != 'application/pdf') {
        parts.add(DataPart(mimeType, fileBytes));
      }

      // Build the prompt
      final promptBuffer = StringBuffer();
      promptBuffer.writeln('## Medical Document Analysis Request');
      promptBuffer.writeln('**File:** $fileName');

      if (userContext != null && userContext.isNotEmpty) {
        promptBuffer.writeln('**Patient Note:** $userContext');
      }

      if (ocrText != null && ocrText.isNotEmpty) {
        promptBuffer.writeln('\n### Extracted Text from Document:');
        promptBuffer.writeln('```');
        promptBuffer.writeln(ocrText);
        promptBuffer.writeln('```');
        promptBuffer.writeln(
            '\nPlease analyze the above extracted medical document text thoroughly.');
      } else {
        promptBuffer.writeln(
            '\nPlease analyze this medical document thoroughly.');
      }

      parts.add(TextPart(promptBuffer.toString()));

      final response = await model.generateContent(
        [Content.multi(parts)],
        safetySettings: _safetySettings,
      );

      return response.text ?? 'Could not analyze the file.';
    } catch (e) {
      Dev.logError('analyzeFileE: $e');
      return 'Failed to analyze file. Please try again.';
    }
  }

  // ─── Analyze Receipt / Prescription with OCR ───────────────────────────────

  Future<String> analyzeReceipt({
    required Uint8List imageBytes,
    String? userContext,
    String? ocrText,
    String? ragContext,
  }) async {
    try {
      final model = _buildModel(
        systemInstruction: '''
You are Dr. AI specializing in prescription and medication analysis.
${ragContext ?? ''}

Prescription Analysis Protocol:
1. List ALL medications with exact dosages
2. Explain each medication's purpose clearly
3. Detail dosage schedule and instructions
4. **Highlight potential drug interactions**
5. Note any special warnings or precautions
6. Explain in simple patient-friendly language
7. Always emphasize following the prescribing doctor
''',
      );

      final parts = <Part>[
        DataPart('image/jpeg', imageBytes),
      ];

      final promptBuffer = StringBuffer();
      promptBuffer.writeln('## Prescription Analysis Request');

      if (userContext != null && userContext.isNotEmpty) {
        promptBuffer.writeln('**Patient Question:** $userContext');
      }

      if (ocrText != null && ocrText.isNotEmpty) {
        promptBuffer.writeln('\n### OCR Extracted Text:');
        promptBuffer.writeln('```');
        promptBuffer.writeln(ocrText);
        promptBuffer.writeln('```');
      }

      promptBuffer.writeln(
          '\nPlease analyze this prescription/medical receipt thoroughly, '
          'using both the image and extracted text.');

      parts.add(TextPart(promptBuffer.toString()));

      final response = await model.generateContent(
        [Content.multi(parts)],
        safetySettings: _safetySettings,
      );

      return response.text ?? 'Could not analyze the prescription.';
    } catch (e) {
      Dev.logError('analyzeReceiptE: $e');
      return 'Failed to analyze prescription. Please try again.';
    }
  }


// ─── Generate Session Title ────────────────────────────────────────────────

  Future<String> generateSessionTitle(String firstMessage) async {
    try {
      final model = _buildModel();
      final response = await model.generateContent([
        Content.text(
          'Generate a very short (max 5 words) medical chat session title '
          'for this message: "$firstMessage". '
          'Return ONLY the title, nothing else.',
        ),
      ]);
      return response.text?.trim() ?? 'Medical Consultation';
    } catch (e) {
      return 'Medical Consultation';
    }
  }
  // ─── Image Search ──────────────────────────────────────────────────────────

  Future<List<String>> searchAiImages(String prompt) async {
    try {
      final res = await networkService!
          .get("https://lexica.art/api/v1/search?q=$prompt");
      final data = jsonDecode(res.body);
      return List.from(data['images'])
          .map((e) => e['src'].toString())
          .toList();
    } catch (e) {
      Dev.logError('searchAiImagesE: $e');
      return [];
    }
  }

  // ─── Translation ───────────────────────────────────────────────────────────

  Future<String> googleTranslate({
    required String from,
    required String to,
    required String text,
  }) async {
    try {
      final res =
          await GoogleTranslator().translate(text, from: from, to: to);
      return res.text;
    } catch (e) {
      Dev.logError('googleTranslateE: $e');
      return 'Translation failed.';
    }
  }
}