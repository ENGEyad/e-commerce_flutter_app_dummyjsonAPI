import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import 'widgets/common_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ProductViewModel>().loadProductDetails(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final productVm = context.watch<ProductViewModel>();
    final cartVm = context.watch<CartViewModel>();
    final product = productVm.selectedProduct;
    final theme = Theme.of(context);

    if (productVm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator.adaptive()));
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Product particulars lost or unavailable.")),
      );
    }

    final hasDiscount = product.discountPercentage != null && product.discountPercentage > 0;
    final double originalPrice = product.price;
    final double computationalPrice = product.discountedPrice;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: AppSpacing.screenPadding,
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border(top: BorderSide(color: theme.dividerColor.withOpacity(0.5))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderMd),
                  ),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: () {
                    cartVm.addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} added to cart!'),
                        backgroundColor: AppColors.priceGreen,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interactive Image Header
            Stack(
              children: [
                Container(
                  height: 420,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppSpacing.radiusXl),
                      bottomRight: Radius.circular(AppSpacing.radiusXl),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: product.images != null && product.images.isNotEmpty
                        ? PageView.builder(
                            itemCount: product.images.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            itemBuilder: (context, index) => Image.network(
                              product.images[index],
                              fit: BoxFit.contain,
                            ),
                          )
                        : const Center(child: Icon(Icons.broken_image, size: 80)),
                  ),
                ),
                // Indicator dots
                if (product.images != null && product.images.length > 1)
                  Positioned(
                    bottom: AppSpacing.md,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentImageIndex == index ? 20 : 8,
                          decoration: BoxDecoration(
                            color: _currentImageIndex == index ? AppColors.primary : theme.dividerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                // Discount Badge overlay
                if (hasDiscount)
                  Positioned(
                    top: kToolbarHeight + 20,
                    right: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.warningAmber,
                        borderRadius: AppSpacing.borderSm,
                      ),
                      child: Text(
                        '-${product.discountPercentage.toStringAsFixed(0)}% OFF',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Categories row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: AppSpacing.borderSm,
                        ),
                        child: Text(
                          product.brand.isNotEmpty ? product.brand : "Premium Brand",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withOpacity(0.2),
                          borderRadius: AppSpacing.borderSm,
                        ),
                        child: Text(
                          product.category.toUpperCase(),
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // Title and rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.warningAmber.withOpacity(0.15),
                          borderRadius: AppSpacing.borderSm,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: AppColors.warningAmber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating}',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: AppColors.warningAmber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Price and Stock row
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CurrencyFormatter.format(computationalPrice),
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: AppColors.priceGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (hasDiscount)
                            Text(
                              CurrencyFormatter.format(originalPrice),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: product.stock > 0 ? AppColors.priceGreen.withOpacity(0.1) : theme.colorScheme.error.withOpacity(0.1),
                          borderRadius: AppSpacing.borderLg,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: product.stock > 0 ? AppColors.priceGreen : theme.colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product.stock > 0 ? "In Stock (${product.stock})" : "Out of Stock",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: product.stock > 0 ? AppColors.priceGreen : theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.xl),
                  // Description
                  Text('Description', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                  const Divider(height: AppSpacing.xl),
                  // Specifications / Details Grid
                  Text('Specifications', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: AppSpacing.borderMd,
                      border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        _buildSpecRow("Shipping", product.shippingInformation, Icons.local_shipping_outlined, theme),
                        const Divider(),
                        _buildSpecRow("Warranty", product.warrantyInformation, Icons.verified_user_outlined, theme),
                        const Divider(),
                        _buildSpecRow("Return Policy", product.returnPolicy, Icons.assignment_return_outlined, theme),
                        const Divider(),
                        _buildSpecRow(
                          "Dimensions", 
                          "${product.dimensions.width}w x ${product.dimensions.height}h x ${product.dimensions.depth}d cm", 
                          Icons.straighten_outlined, 
                          theme
                        ),
                        const Divider(),
                        _buildSpecRow("SKU", product.sku, Icons.fingerprint, theme),
                      ],
                    ),
                  ),
                  const Divider(height: AppSpacing.xl),
                  // Customer Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer Reviews', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      if (product.reviews != null)
                        Text(
                          '${product.reviews.length} reviews',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodySmall?.color),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (product.reviews == null || product.reviews.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "No reviews yet for this product.",
                          style: TextStyle(color: theme.textTheme.bodySmall?.color),
                        ),
                      ),
                    )
                  else
                    ...product.reviews.map((review) => Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: AppSpacing.borderMd,
                            border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: AppColors.primary.withOpacity(0.1),
                                    child: Text(
                                      review.reviewerName.isNotEmpty ? review.reviewerName[0].toUpperCase() : 'U',
                                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(review.reviewerName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                        Text(
                                          review.date.substring(0, 10), 
                                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (starIdx) => Icon(
                                        Icons.star,
                                        size: 14,
                                        color: starIdx < review.rating ? AppColors.warningAmber : theme.dividerColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                review.comment,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.textTheme.bodySmall?.color?.withOpacity(0.7)),
          const SizedBox(width: AppSpacing.md),
          Text(label, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}