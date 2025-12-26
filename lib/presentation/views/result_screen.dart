import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/plant_controller.dart';
import '../../core/constants/app_colors.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlantController>();
    final plant = controller.plant.value!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            stretch: true,
            leadingWidth: 80,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Hero(
                tag: 'plant_image',
                child: Image.file(
                  File(controller.imageFile.value!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plant.name,
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              plant.scientificName,
                              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      _buildConfidenceIndicator(plant.confidence),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Dynamic Info Grid – Only show meaningful data
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      _buildInfoTile("Family", plant.family, Icons.eco_outlined),

                      // Origin: Only show if not vague
                      if (!_isUninformative(plant.origin))
                        _buildInfoTile("Origin", plant.origin, Icons.language),

                      // Edible: Show only if we have a positive hint
                      if (plant.isEdible)
                        _buildInfoTile("Edible", "Yes", Icons.restaurant_menu)
                      else
                        _buildInfoTile("Edible", "Likely not", Icons.restaurant),

                      // Pet Safety / Toxicity – Always show helpful version
                      _buildInfoTile(
                        "Pet Safety",
                        "Check ASPCA database for toxicity",
                        Icons.pets,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  const Text("About this Plant", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    plant.description,
                    style: TextStyle(fontSize: 16, height: 1.6, color: Colors.grey[800]),
                  ),

                  const SizedBox(height: 32),

                  const Text("Care Guide", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...plant.careTips.map((tip) => _buildCareStep(tip)),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isUninformative(String value) {
    final lower = value.toLowerCase().trim();
    return lower == "unknown" || 
           lower == "not specified" || 
           lower.contains("distribution varies") ||
           lower.isEmpty;
  }

  Widget _buildConfidenceIndicator(double confidence) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "${(confidence * 100).toInt()}%",
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 20),
          ),
          const Text("Match", style: TextStyle(fontSize: 12, color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareStep(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 16, height: 1.4))),
        ],
      ),
    );
  }
}