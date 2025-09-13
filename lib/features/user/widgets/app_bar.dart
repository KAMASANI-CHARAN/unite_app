import 'package:flutter/material.dart';
import 'package:unite/features/welcome/widgets/app_colors.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchTap;

  const HomeAppBar({super.key, this.onSearchChanged, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 4,
      title: _SearchBar(onChanged: onSearchChanged, onTap: onSearchTap),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.onPrimary),
          onPressed: onSearchTap,
          tooltip: 'Search',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const _SearchBar({this.onChanged, this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color hintColor = AppColors.primary.withAlpha((0.7 * 255).toInt());

    return SizedBox(
      height: 40,
      child: TextField(
        onChanged: onChanged,
        onTap: onTap,
        style: const TextStyle(color: AppColors.primary, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search events...',
          hintStyle: TextStyle(color: hintColor),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          filled: true,
          fillColor: AppColors.onPrimary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
