import 'package:flutter/material.dart';
import 'package:zainpay/theme/zainpay_theme.dart';

/// Payment method types
enum PaymentMethodType {
  /// Card payment
  card,
  
  /// Bank transfer
  bankTransfer,
  
  /// USSD payment
  ussd,
  
  /// QR code payment
  qrCode,
}

/// A card widget for displaying a payment method
class PaymentMethodCard extends StatelessWidget {
  /// Payment method type
  final PaymentMethodType type;
  
  /// Function to call when the card is tapped
  final VoidCallback onTap;
  
  /// Whether the payment method is selected
  final bool isSelected;

  /// Creates a new payment method card
  const PaymentMethodCard({
    Key? key,
    required this.type,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get payment method details
    final PaymentMethodDetails details = _getPaymentMethodDetails(type);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? ZainpayTheme.secondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? ZainpayTheme.primaryColor : ZainpayTheme.dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Payment method icon
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: ZainpayTheme.secondaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                details.icon,
                size: 20,
                color: ZainpayTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            // Payment method details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details.title,
                    style: ZainpayTheme.titleMedium,
                  ),
                  if (details.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      details.subtitle!,
                      style: ZainpayTheme.bodySmall.copyWith(
                        color: ZainpayTheme.textLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Chevron icon
            Icon(
              Icons.chevron_right,
              size: 20,
              color: ZainpayTheme.textLight,
            ),
          ],
        ),
      ),
    );
  }

  /// Gets payment method details based on type
  PaymentMethodDetails _getPaymentMethodDetails(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.card:
        return PaymentMethodDetails(
          icon: Icons.credit_card,
          title: 'Pay with Card',
          subtitle: 'Visa, Mastercard, Verve',
        );
      case PaymentMethodType.bankTransfer:
        return PaymentMethodDetails(
          icon: Icons.account_balance,
          title: 'Pay with Bank Transfer',
          subtitle: 'Make a transfer to a virtual account',
        );
      case PaymentMethodType.ussd:
        return PaymentMethodDetails(
          icon: Icons.dialpad,
          title: 'Pay with USSD',
          subtitle: 'Dial a code to pay',
        );
      case PaymentMethodType.qrCode:
        return PaymentMethodDetails(
          icon: Icons.qr_code,
          title: 'Pay with QR Code',
          subtitle: 'Scan a QR code to pay',
        );
    }
  }
}

/// Payment method details
class PaymentMethodDetails {
  /// Icon to display
  final IconData icon;
  
  /// Title to display
  final String title;
  
  /// Subtitle to display (optional)
  final String? subtitle;

  /// Creates new payment method details
  const PaymentMethodDetails({
    required this.icon,
    required this.title,
    this.subtitle,
  });
}
