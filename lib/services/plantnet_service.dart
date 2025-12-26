import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/plant_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlantNetService {
  static String get apiKey => dotenv.env['PLANT_NET_API_KEY'] ?? "YOUR_PLANTNET_API_KEY_HERE";

  static Future<Plant?> identifyPlant(List<int> imageBytes) async {
    if (apiKey.isEmpty || apiKey == "YOUR_PLANTNET_API_KEY_HERE") {
      print("Error: Missing PlantNet API key in .env file.");
      return null;
    }

    final url = Uri.parse(
      'https://my-api.plantnet.org/v2/identify/all?api-key=$apiKey',
    );

    final request = http.MultipartRequest('POST', url);

    request.files.add(
      http.MultipartFile.fromBytes('images', imageBytes, filename: 'plant.jpg'),
    );

    request.fields['organs'] = jsonEncode(['auto']);

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(respStr);
        final List<dynamic> results = json['results'] ?? [];

        if (results.isEmpty) return null;

        final best = results[0];
        final species = best['species'];

        return Plant(
          name: _extractCommonName(species),
          scientificName: species['scientificNameWithoutAuthor'] ?? "Unknown",
          family: species['family']?['scientificNameWithoutAuthor'] ?? "Unknown",
          confidence: (best['score'] as num).toDouble(),
          description: _buildDescription(best),
          careTips: _buildGenericCareTips(),
          toxicity: "Toxicity not specified in results – check ASPCA or similar for pets",
          origin: _extractOrigin(best),
          isEdible: _inferEdibility(best),
        );
      } else {
        print("API Error: ${response.statusCode} - $respStr");
        return null;
      }
    } catch (e) {
      print("Network/Parsing Error: $e");
      return null;
    }
  }

  static String _extractCommonName(Map<String, dynamic> species) {
    final commonNames = species['commonNames'] as List<dynamic>? ?? [];
    if (commonNames.isNotEmpty) {
      return commonNames[0].toString();
    }
    return species['scientificNameWithoutAuthor'] ?? "Unknown Plant";
  }

  static String _buildDescription(Map<String, dynamic> best) {
    final species = best['species'];
    final commonNames = species['commonNames'] as List<dynamic>? ?? [];
    final sciName = species['scientificNameWithoutAuthor'] ?? "this plant";
    final confidencePercent = (best['score'] as num).toDouble() * 100;

    if (commonNames.isNotEmpty) {
      return "The $sciName, commonly known as ${commonNames[0]}, has been identified with ${confidencePercent.toStringAsFixed(1)}% confidence.";
    }
    return "$sciName has been identified with ${confidencePercent.toStringAsFixed(1)}% confidence using Pl@ntNet.";
  }

  static List<String> _buildGenericCareTips() {
    return [
      "Place in bright, indirect light for optimal growth.",
      "Water when the top inch of soil feels dry.",
      "Use well-draining soil to prevent root rot.",
      "Fertilize monthly during the growing season.",
    ];
  }

  static String _extractOrigin(Map<String, dynamic> best) {
    return "Global distribution varies – consult regional sources.";
  }

  static bool _inferEdibility(Map<String, dynamic> best) {
    final commonNames = (best['species']?['commonNames'] as List<dynamic>? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toList();

    const knownEdibleHints = [
      "basil", "mint", "thyme", "rosemary", "parsley", "oregano",
      "tomato", "lemon", "lime", "strawberry", "apple", "cherry",
    ];

    return commonNames.any((name) => knownEdibleHints.any((hint) => name.contains(hint)));
  }
}