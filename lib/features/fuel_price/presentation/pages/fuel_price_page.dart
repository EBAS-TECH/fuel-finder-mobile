import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';

class PricePage extends StatefulWidget {
  const PricePage({super.key});

  @override
  State<PricePage> createState() => _PricePageState();
}

class _PricePageState extends State<PricePage> {
  final List<FuelPrice> fuelPrices = [
    FuelPrice(
      type: 'Benzene',
      price: '112.67 Br/L',
      since: 'March 2024',
      effectiveUntil: 'September 2024',
      source: 'Ministry of Mines and Petroleum',
      icon: Icons.local_gas_station,
    ),
    FuelPrice(
      type: 'Diesel',
      price: '112.67 Br/L',
      since: 'March 2024',
      effectiveUntil: 'September 2024',
      source: 'Ministry of Mines and Petroleum',
      icon: Icons.local_gas_station,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: CustomAppBar(title: "Fuel Prices", centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 24 : 16,
              vertical: 16,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLargeScreen)
                    _buildLargeLayout(theme)
                  else
                    _buildMobileLayout(theme),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: fuelPrices.map((fuel) => _buildFuelCard(fuel, theme)).toList(),
    );
  }

  Widget _buildLargeLayout(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children:
          fuelPrices.map((fuel) {
            return SizedBox(width: 400, child: _buildFuelCard(fuel, theme));
          }).toList(),
    );
  }

  Widget _buildFuelCard(FuelPrice fuel, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(fuel.icon, color: AppPallete.primaryColor, size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fuel.type,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      fuel.price,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppPallete.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 0.8),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _buildInfoItem(
                      Icons.calendar_today,
                      'Since',
                      fuel.since,
                      theme,
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 20,
                    color: Colors.grey,
                  ),
                  Flexible(
                    child: _buildInfoItem(
                      Icons.event_available,
                      'Effective until',
                      fuel.effectiveUntil,
                      theme,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(thickness: 0.8),
            const SizedBox(height: 12),
            _buildInfoItem(Icons.source, 'Source', fuel.source, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppPallete.primaryColor, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FuelPrice {
  final String type;
  final String price;
  final String since;
  final String effectiveUntil;
  final String source;
  final IconData icon;

  FuelPrice({
    required this.type,
    required this.price,
    required this.since,
    required this.effectiveUntil,
    required this.source,
    required this.icon,
  });
}

