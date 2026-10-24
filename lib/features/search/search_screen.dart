import 'package:flutter/material.dart';

import '../../app/router.dart';
import '../../app/theme/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearch() {
    Navigator.pushNamed(
      context,
      AppRoutes.nearbyAtms,
      arguments: _searchController.text.trim(),
    );
  }

  void _goTo(String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Tem Kumbo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Localize ATM’s próximos',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Ajuda'),
                onTap: () => _goTo(AppRoutes.help),
              ),
              ListTile(
                leading: const Icon(Icons.support_agent),
                title: const Text('Suporte'),
                onTap: () => _goTo(AppRoutes.support),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Configuração'),
                onTap: () => _goTo(AppRoutes.settings),
              ),
              ListTile(
                leading: const Icon(Icons.contact_mail_outlined),
                title: const Text('Contacto'),
                onTap: () => _goTo(AppRoutes.contact),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Pesquisar',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _onSearch,
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'ajuda':
                  Navigator.pushNamed(context, AppRoutes.help);
                  break;
                case 'suporte':
                  Navigator.pushNamed(context, AppRoutes.support);
                  break;
                case 'configuracao':
                  Navigator.pushNamed(context, AppRoutes.settings);
                  break;
                case 'contacto':
                  Navigator.pushNamed(context, AppRoutes.contact);
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'ajuda',
                child: Text('Ajuda'),
              ),
              PopupMenuItem(
                value: 'suporte',
                child: Text('Suporte'),
              ),
              PopupMenuItem(
                value: 'configuracao',
                child: Text('Configuração'),
              ),
              PopupMenuItem(
                value: 'contacto',
                child: Text('Contacto'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: Container(
                      margin: const EdgeInsets.only(right: 2),
                      child: InkWell(
                        onTap: _onSearch,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    hintText: 'Insira a zona a localizar ATM\'s',
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 14,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFB0BEC5),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFB0BEC5),
                        width: 1.4,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 165,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'PESQUISAR',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}