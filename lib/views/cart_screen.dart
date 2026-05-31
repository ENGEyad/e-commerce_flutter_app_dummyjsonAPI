import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import 'widgets/common_widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = context.read<AuthViewModel>().currentUser?.id ?? 1;
      context.read<CartViewModel>().loadUserCarts(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartVm = context.watch<CartViewModel>();
    final cart = cartVm.selectedCart;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart', style: theme.textTheme.headlineMedium),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LoadingOverlay(
        isLoading: cartVm.isLoading,
        child: cart == null || cart.products.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 100, color: theme.dividerColor),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      "Your cart is empty",
                      style: theme.textTheme.titleLarge?.copyWith(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      itemCount: cart.products.length,
                      itemBuilder: (context, index) {
                        final item = cart.products[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: AppSpacing.borderMd,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: AppSpacing.borderSm,
                                  child: Image.network(
                                    item.thumbnail ?? '',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 80,
                                      height: 80,
                                      color: theme.dividerColor,
                                      child: const Icon(Icons.shopping_bag),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        CurrencyFormatter.format(item.price?.toDouble() ?? 0.0),
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: AppColors.priceGreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                                      onPressed: () {
                                        cartVm.removeFromCart(item.id);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item removed from cart.")));
                                      },
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: theme.scaffoldBackgroundColor,
                                        borderRadius: AppSpacing.borderLg,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove, size: 16),
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(8),
                                            onPressed: () {
                                              cartVm.updateQuantity(item.id, item.quantity - 1);
                                            },
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style: theme.textTheme.labelLarge,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add, size: 16),
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(8),
                                            onPressed: () {
                                              cartVm.updateQuantity(item.id, item.quantity + 1);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: AppSpacing.screenPadding,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSpacing.radiusXl),
                        topRight: Radius.circular(AppSpacing.radiusXl),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total", style: theme.textTheme.titleLarge),
                              Text(
                                CurrencyFormatter.format(cart.total?.toDouble() ?? 0.0),
                                style: theme.textTheme.displaySmall?.copyWith(
                                  color: AppColors.priceGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Checkout", style: theme.textTheme.titleLarge),
                                    content: Text("Checkout feature coming soon.", style: theme.textTheme.bodyMedium),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text("Got it"),
                                      )
                                    ],
                                  ),
                                );
                              },
                              child: const Text("Proceed to Checkout"),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}