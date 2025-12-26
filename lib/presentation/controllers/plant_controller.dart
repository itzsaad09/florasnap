import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/plant_model.dart';
import '../../services/plantnet_service.dart';

class PlantController extends GetxController {
  final isLoading = false.obs;
  final plant = Rxn<Plant>();
  final imageFile = Rxn<XFile>();
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
        Get.snackbar(
          "No Match Found",
          "Pl@ntNet couldn't identify this image. Try a clearer photo of the leaves.",
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred: $e",
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading(false);
    }
  }
}
