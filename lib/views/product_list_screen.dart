import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/product_viewmodel.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import 'widgets/cart_badge.dart';
import 'widgets/common_widgets.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductViewModel>().loadInitial());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final vm = context.read<ProductViewModel>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!vm.isLoading && (vm.skip + vm.limit < vm.total)) {
        vm.loadProducts(pageSkip: vm.skip + vm.limit);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final productVm = context.watch<ProductViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Discover', style: theme.textTheme.headlineMedium),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          const CartBadge(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search operational goods...',
              hintStyle: WidgetStateProperty.all(theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color?.withOpacity(0.5))),
              leading: Icon(Icons.search, color: theme.colorScheme.primary),
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(theme.colorScheme.surface),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(color: theme.dividerColor),
                  borderRadius: AppSpacing.borderLg,
                ),
              ),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      productVm.loadProducts();
                    },
                  )
              ],
              onSubmitted: (query) => productVm.search(query),
            ),
          ),

          // Categories List
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              itemCount: productVm.categories.length + 1,
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final catName = isAll ? "All" : productVm.categories[index - 1];
                final isSelected = _selectedCategory == catName;

                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(catName),
                    selected: isSelected,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderLg,
                      side: BorderSide(color: isSelected ? Colors.transparent : theme.dividerColor),
                    ),
                    showCheckmark: false,
                    onSelected: (_) {
                      setState(() => _selectedCategory = catName);
                      if (isAll) {
                        productVm.loadProducts();
                      } else {
                        productVm.loadByCategory(catName);
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Grid View Product Showcase
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => productVm.loadProducts(),
              child: productVm.products.isEmpty && productVm.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.md),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.60,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: productVm.products.length,
                itemBuilder: (context, index) {
                  final product = productVm.products[index];
                  final hasDiscount = product.discountPercentage != null && product.discountPercentage! > 0;

                  // Calculating dynamic discount representation mechanics
                  final double originalPrice = product.price?.toDouble() ?? 0.0;
                  final double computationalPrice = hasDiscount
                      ? originalPrice * (1 - (product.discountPercentage! / 100))
                      : originalPrice;

                  return Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: AppSpacing.borderMd,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: AppSpacing.borderMd,
                      child: InkWell(
                        onTap: () => context.push('/products/product/${product.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    product.thumbnail ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 50)),
                                  ),
                                  if (hasDiscount)
                                    Positioned(
                                      top: AppSpacing.sm,
                                      left: AppSpacing.sm,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.warningAmber,
                                          borderRadius: AppSpacing.borderSm,
                                        ),
                                        child: Text(
                                          '-${product.discountPercentage?.toStringAsFixed(0)}%',
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        CurrencyFormatter.format(computationalPrice),
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: AppColors.priceGreen,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (hasDiscount) ...[
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          CurrencyFormatter.format(originalPrice),
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 32,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        side: const BorderSide(color: AppColors.primary, width: 1.2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: AppSpacing.borderSm,
                                        ),
                                      ),
                                      onPressed: () => context.push('/products/product/${product.id}'),
                                      child: Text(
                                        "View Details",
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}