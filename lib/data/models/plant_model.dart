class Plant {
  final String name;
  final String scientificName;
  final String family;
  final double confidence;
  final String description;
  final List<String> careTips;
  final String toxicity;
  final String origin;
  final bool isEdible;

  Plant({
    required this.name,
    required this.scientificName,
    required this.family,
    required this.confidence,
    required this.description,
    required this.careTips,
    required this.toxicity,
    required this.origin,
    required this.isEdible,
  });
}