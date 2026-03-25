import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/drivers_provider.dart';
import '../../services/location_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/driver_card.dart';
import '../driver_detail/driver_detail_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriversProvider>().refreshLocation(context.read<LocationService>());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const [
          _HomeListTab(),
          ProfileScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 26),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, size: 26),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _HomeListTab extends StatelessWidget {
  const _HomeListTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final drivers = context.watch<DriversProvider>();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar.large(
          floating: false,
          pinned: true,
          backgroundColor: AppColors.background,
          expandedHeight: 132,
          title: Text(
            'Bonjour, ${auth.user?.displayName ?? 'bienvenue'}',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Row(
                  children: [
                    const Icon(Icons.near_me_rounded, color: AppColors.secondary, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: drivers.locating
                          ? Text(
                              'Localisation en cours…',
                              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                            )
                          : Text(
                              drivers.lastPosition != null
                                  ? 'Position : ${context.read<LocationService>().formatShort(drivers.lastPosition)}'
                                  : 'Activez la localisation pour les futurs résultats à proximité',
                              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverToBoxAdapter(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Rechercher une zone ou un chauffeur…',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.2)),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Chauffeurs proches',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverToBoxAdapter(child: _ComingSoonCard(theme: theme)),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  'Aperçu (démo)',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Exemples',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          sliver: SliverList.separated(
            itemBuilder: (context, i) {
              final d = drivers.nearbyPreviewDrivers[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: DriverCard(
                  driver: d,
                  onTap: () {
                    Navigator.pushNamed(context, DriverDetailScreen.routeName, arguments: d);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: drivers.nearbyPreviewDrivers.length,
          ),
        ),
      ],
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.secondary.withValues(alpha: 0.12),
            AppColors.primary.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.two_wheeler_rounded, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bientôt : vrais chauffeurs à proximité',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'La liste en temps réel arrive avec la phase 3. En attendant, profitez de l’aperçu ci-dessous pour voir à quoi ressemblera MotoH.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
