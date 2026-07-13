enum StockStatus { inStock, lowStock, outOfStock }

class ProductPrice {
  final String label;
  final double amount;
  ProductPrice({required this.label, required this.amount});
}

class ProductVariant {
  final String type;
  final List<String> options;
  ProductVariant({required this.type, required this.options});
}

class Product {
  final String id;
  final String name;
  final String description;
  final String category;
  final String sku;
  final String? skuAlias;
  final double price;
  final double costPrice;
  int currentStock;
  final int reorderThreshold;
  final String unit;
  final bool hasSecondaryUnit;
  final List<ProductPrice> multiplePrices;
  final List<ProductVariant> variants;
  final String? imagePath; // local asset path
  final String imageEmoji; // fallback
  final List<String> tags;
  DateTime lastUpdated;
  final bool isFeatured;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.sku,
    this.skuAlias,
    required this.price,
    required this.costPrice,
    required this.currentStock,
    required this.reorderThreshold,
    required this.unit,
    this.hasSecondaryUnit = false,
    this.multiplePrices = const [],
    this.variants = const [],
    this.imagePath,
    required this.imageEmoji,
    this.tags = const [],
    required this.lastUpdated,
    this.isFeatured = false,
  });

  StockStatus get stockStatus {
    if (currentStock == 0) return StockStatus.outOfStock;
    if (currentStock <= reorderThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  double get stockRatio {
    final max = reorderThreshold * 2.5;
    return (currentStock / max).clamp(0.0, 1.0);
  }

  double get margin =>
      price > 0 ? ((price - costPrice) / price) * 100 : 0;

  double get profit => price - costPrice;

  Product copyWith({
    String? name,
    String? description,
    String? category,
    String? sku,
    String? skuAlias,
    double? price,
    double? costPrice,
    int? currentStock,
    int? reorderThreshold,
    String? unit,
    bool? hasSecondaryUnit,
    List<ProductPrice>? multiplePrices,
    List<ProductVariant>? variants,
    String? imagePath,
    String? imageEmoji,
    List<String>? tags,
    DateTime? lastUpdated,
    bool? isFeatured,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      skuAlias: skuAlias ?? this.skuAlias,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      currentStock: currentStock ?? this.currentStock,
      reorderThreshold: reorderThreshold ?? this.reorderThreshold,
      unit: unit ?? this.unit,
      hasSecondaryUnit: hasSecondaryUnit ?? this.hasSecondaryUnit,
      multiplePrices: multiplePrices ?? this.multiplePrices,
      variants: variants ?? this.variants,
      imagePath: imagePath ?? this.imagePath,
      imageEmoji: imageEmoji ?? this.imageEmoji,
      tags: tags ?? this.tags,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}

// ─────────────────────────────────────────────────────────
// Mock Product Catalogue
// ─────────────────────────────────────────────────────────
List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'iPhone 15 Pro',
    description:
        'Apple\'s flagship smartphone featuring a titanium design, A17 Pro chip, and a 48MP triple-camera system. Supports USB-C and offers up to 29 hours of video playback.',
    category: 'Electronics',
    sku: 'ELC-001',
    price: 850000,
    costPrice: 680000,
    currentStock: 12,
    reorderThreshold: 5,
    unit: 'pcs',
    imagePath: 'assets/images/prod_smartphone.png',
    imageEmoji: '📱',
    tags: ['Apple', 'Flagship', 'Smartphone'],
    lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
    isFeatured: true,
  ),
  Product(
    id: '2',
    name: 'Samsung Galaxy Tab S9',
    description:
        'Premium Android tablet with a 11" Dynamic AMOLED display, Snapdragon 8 Gen 2 processor, and IP68 water resistance. Perfect for productivity and entertainment.',
    category: 'Electronics',
    sku: 'ELC-002',
    price: 420000,
    costPrice: 310000,
    currentStock: 3,
    reorderThreshold: 5,
    unit: 'pcs',
    imagePath: 'assets/images/prod_tablet.png',
    imageEmoji: '💻',
    tags: ['Samsung', 'Tablet', 'Android'],
    lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
    isFeatured: true,
  ),
  Product(
    id: '3',
    name: 'Pro Wireless Earbuds',
    description:
        'Premium true wireless earbuds with active noise cancellation, 30-hour total battery life, and crystal-clear audio. Includes wireless charging case and IPX5 rating.',
    category: 'Electronics',
    sku: 'ELC-003',
    price: 85000,
    costPrice: 55000,
    currentStock: 0,
    reorderThreshold: 10,
    unit: 'pcs',
    imagePath: 'assets/images/prod_earbuds.png',
    imageEmoji: '🎧',
    tags: ['Audio', 'ANC', 'Wireless'],
    lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
    isFeatured: false,
  ),
  Product(
    id: '4',
    name: 'Organic Coffee Beans',
    description:
        'Single-origin Arabica coffee beans sourced from Cameroon\'s highlands. Medium roast with notes of caramel, citrus, and dark chocolate. Freshly roasted and vacuum sealed.',
    category: 'Food & Drinks',
    sku: 'FD-001',
    price: 12000,
    costPrice: 7500,
    currentStock: 45,
    reorderThreshold: 15,
    unit: 'kg',
    imagePath: 'assets/images/prod_coffee.png',
    imageEmoji: '☕',
    tags: ['Organic', 'Arabica', 'Local'],
    lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
    isFeatured: true,
  ),
  Product(
    id: '5',
    name: 'Mineral Water 500ml',
    description:
        'Naturally sourced mineral water from certified springs. Rich in essential minerals including calcium and magnesium. Available in cases of 24 bottles.',
    category: 'Food & Drinks',
    sku: 'FD-002',
    price: 500,
    costPrice: 250,
    currentStock: 200,
    reorderThreshold: 50,
    unit: 'bottles',
    imagePath: 'assets/images/prod_water.png',
    imageEmoji: '💧',
    tags: ['Mineral', 'Hydration', 'Natural'],
    lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
    isFeatured: false,
  ),
  Product(
    id: '6',
    name: 'Men\'s Premium Polo',
    description:
        'Crafted from 100% Egyptian cotton piqué fabric with a classic ribbed collar. Slim-fit silhouette available in 8 colors. Machine washable and wrinkle-resistant.',
    category: 'Clothing',
    sku: 'CLO-001',
    price: 18000,
    costPrice: 10000,
    currentStock: 8,
    reorderThreshold: 10,
    unit: 'pcs',
    imagePath: 'assets/images/prod_polo_shirt.png',
    imageEmoji: '👕',
    tags: ['Cotton', 'Slim Fit', 'Premium'],
    lastUpdated: DateTime.now().subtract(const Duration(hours: 8)),
    isFeatured: false,
  ),
  Product(
    id: '7',
    name: 'Ergonomic Office Chair',
    description:
        'Professional-grade mesh ergonomic chair with lumbar support, adjustable armrests, and 360° swivel base. Supports up to 150kg. Reduces back strain during long work sessions.',
    category: 'Home & Office',
    sku: 'HO-001',
    price: 125000,
    costPrice: 85000,
    currentStock: 4,
    reorderThreshold: 3,
    unit: 'pcs',
    imagePath: 'assets/images/prod_office_chair.png',
    imageEmoji: '🪑',
    tags: ['Ergonomic', 'Mesh', 'Adjustable'],
    lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
    isFeatured: true,
  ),
  Product(
    id: '8',
    name: 'USB-C Hub 7-in-1',
    description:
        'Expand your laptop\'s connectivity with 4K HDMI, 3x USB-A 3.0, SD card slot, microSD, and 100W USB-C PD passthrough. Aluminum shell with compact plug-and-play design.',
    category: 'Electronics',
    sku: 'ELC-004',
    price: 35000,
    costPrice: 22000,
    currentStock: 22,
    reorderThreshold: 8,
    unit: 'pcs',
    imagePath: null,
    imageEmoji: '🔌',
    tags: ['USB-C', 'HDMI', 'Adapter'],
    lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
    isFeatured: false,
  ),
];
