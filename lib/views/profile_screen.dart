import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: theme.textTheme.headlineMedium),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: user == null
          ? Center(
              child: Text(
                "No authenticated context present.",
                style: theme.textTheme.bodyLarge,
              ),
            )
          : SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.primary, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: theme.cardColor,
                      backgroundImage: user.image != null ? NetworkImage(user.image!) : null,
                      child: user.image == null ? Icon(Icons.person, size: 60, color: theme.dividerColor) : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${user.firstName ?? ''} ${user.lastName ?? ''}',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '@${user.username ?? 'anonymous'}',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.6)),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: AppSpacing.borderLg,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                          leading: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: AppSpacing.borderMd,
                            ),
                            child: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
                          ),
                          title: Text('Email Address', style: theme.textTheme.labelMedium),
                          subtitle: Text(
                            user.email ?? 'Not provided',
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        Divider(height: 1, color: theme.dividerColor.withOpacity(0.5)),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                          leading: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: AppSpacing.borderMd,
                            ),
                            child: Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.primary),
                          ),
                          title: Text('My Orders', style: theme.textTheme.titleMedium),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order history coming soon!')));
                          },
                        ),
                        Divider(height: 1, color: theme.dividerColor.withOpacity(0.5)),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                          leading: Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: AppSpacing.borderMd,
                            ),
                            child: Icon(Icons.settings_outlined, color: theme.colorScheme.primary),
                          ),
                          title: Text('Settings', style: theme.textTheme.titleMedium),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings coming soon!')));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderLg),
                        side: BorderSide(color: theme.colorScheme.error),
                        foregroundColor: theme.colorScheme.error,
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      onPressed: () {
                        authVm.currentUser = null;
                        authVm.auth = null;
                        context.go('/login');
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}