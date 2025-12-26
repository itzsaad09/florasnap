import 'package:florasnap/services/plantnet_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/plant_model.dart';
import '../../services/plantnet_service.dart';

class PlantController extends GetxController {
  var isLoading = false.obs;
  var plant = Rxn<Plant>();
  var imageFile = Rxn<XFile>();

  final picker = ImagePicker();

  void takePhoto() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      imageFile.value = pickedFile;
      identifyPlant(pickedFile);
    }
  }

  void pickFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      imageFile.value = pickedFile;
      identifyPlant(pickedFile);
    }
  }

  void identifyPlant(XFile file) async {
    isLoading(true);

    try {
      final bytes = await file.readAsBytes();
      final result = await PlantNetService.identifyPlant(bytes);

      if (result != null) {
        plant.value = result;
        Get.toNamed('/result');
      } else {
        // Show PlantNet's message (like "server busy" or "timeout")
        Get.snackbar(
          "Try Again",
          "Could not identify the plant. Please try again later.",
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
          duration: const Duration(seconds: 8),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Only show "No Internet" for real connection loss
      Get.snackbar(
        "No Internet",
        "Check your connection and try again",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }

    isLoading(false);
  }
}
