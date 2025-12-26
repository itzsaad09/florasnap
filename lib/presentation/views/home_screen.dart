import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../controllers/plant_controller.dart';
import '../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlantController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8), // Ultra-soft mint-white
      body: Stack(
        children: [
          // Elegant Organic Background
          Positioned(top: -50, right: -50, child: _buildBlob(300, AppColors.primary.withOpacity(0.05))),
          Positioned(bottom: -100, left: -50, child: _buildBlob(400, const Color(0xFFD4E9D4))),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  _buildAnimatedTitle(),
                  const Spacer(),
                  
                  // Central Dynamic Area
                  Obx(() => controller.isLoading.value 
                    ? _buildScanningAnimation() 
                    : _buildHeroLogo()),
                  
                  const Spacer(),
                  
                  // Glassmorphic Action Panel
                  _buildActionPanel(controller),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "FloraSnap",
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 3, width: 40, color: AppColors.primary),
        const SizedBox(height: 20),
        Text(
          "Identify and care for your\nplants with elegance.",
          style: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: Colors.black.withOpacity(0.4),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroLogo() {
    return Center(
      child: Container(
        height: 240,
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.12),
              blurRadius: 50,
              offset: const Offset(0, 25),
            ),
          ],
        ),
        child: const Icon(Icons.eco, size: 100, color: AppColors.primary),
      ),
    );
  }

  Widget _buildScanningAnimation() {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              _buildHeroLogo(),
              const SizedBox(
                height: 260,
                width: 260,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              // Inner pulsing leaf icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.2),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: Icon(Icons.eco, color: AppColors.primary.withOpacity(0.3), size: 140),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            "ANALYZING...",
            style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel(PlantController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Column(
        children: [
          _buildElegantButton(
            "Quick Scan", 
            Icons.camera_rounded, 
            true, 
            () => controller.takePhoto()
          ),
          const SizedBox(height: 12),
          _buildElegantButton(
            "Import Image", 
            Icons.image_search_rounded, 
            false, 
            () => controller.pickFromGallery()
          ),
        ],
      ),
    );
  }

  Widget _buildElegantButton(String label, IconData icon, bool primary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: primary ? null : Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primary ? Colors.white : AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: primary ? Colors.white : AppColors.primary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}