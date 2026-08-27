import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  static const primaryColor = Color(0xFF0F2537);
  static const accentColor = Color(0xFFD99036);
  static const backgroundColor = Color(0xFFF9F7F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildOverviewCard(),
              const SizedBox(height: 24),
              _buildSectionHeader('Vos modules actifs', onSeeAll: () {}),
              const SizedBox(height: 12),
              _buildActiveModulesList(),
              const SizedBox(height: 24),
              _buildSectionHeader('Prochaines Étapes'),
              const SizedBox(height: 12),
              _buildNextStepsCard('Test de pratique: 15min'),
              const SizedBox(height: 24),
              _buildSectionHeader('Outils Rapides'),
              const SizedBox(height: 12),
              _buildQuickTools(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
  // Récupère fullName en priorité; si absent ou vide, utilise le début de l'email
  final String displayName = user.fullName.trim().isNotEmpty
    ? user.fullName.trim()
    : user.email.split('@').first;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.explore, color: accentColor, size: 24),
          ),
          const SizedBox(width: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: primaryColor, fontSize: 18),
              children: [
                const TextSpan(text: 'Bonjour,\n'),
                TextSpan(
                  text: '$displayName !',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 28, color: primaryColor),
            onPressed: () {},
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aperçu de la préparation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 6),
          const Text(
            'Progression mise à jour après réalisation de vos tests.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 65,
                height: 65,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 0.65,
                      strokeWidth: 7,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                    const Center(
                      child: Text(
                        '65%',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Étape actuelle :', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    SizedBox(height: 2),
                    Text(
                      'Planification d\'études',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: const Text(
              'Voir tout',
              style: TextStyle(color: accentColor, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveModulesList() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildModuleCard('Mathématiques\npour l\'entrée', 0.7, Icons.calculate_outlined),
          const SizedBox(width: 12),
          _buildModuleCard('Physique-Chimie\npour la suite', 0.4, Icons.science_outlined),
          const SizedBox(width: 12),
          _buildModuleCard('SVT pour\napprofondir', 0.2, Icons.biotech_outlined),
        ],
      ),
    );
  }

  Widget _buildModuleCard(String title, double progress, IconData icon) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: EdgeInsets.zero,
              ),
              onPressed: () {},
              child: const Text('Reprendre', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard(String stepText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Text(
        stepText,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor),
      ),
    );
  }

  Widget _buildQuickTools() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildToolItem(Icons.calendar_today_outlined, 'Planificateur'),
        _buildToolItem(Icons.functions_outlined, 'Formules'),
        _buildToolItem(Icons.show_chart_outlined, 'Simulations'),
      ],
    );
  }

  Widget _buildToolItem(IconData icon, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryColor, size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Modules'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Progrès'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Compte'),
      ],
    );
  }
}