// lib/modules/checkout/widgets/payment_method_picker.dart

import 'package:flutter/material.dart';

class PaymentMethodPicker extends StatefulWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const PaymentMethodPicker({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  State<PaymentMethodPicker> createState() => _PaymentMethodPickerState();
}

class _PaymentMethodPickerState extends State<PaymentMethodPicker> {
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: 'CARD',
      name: 'Credit Card',
      icon: Icons.credit_card,
      color: Colors.blue,
    ),
    PaymentMethod(
      id: 'QRCODE',
      name: 'QR Code',
      icon: Icons.qr_code,
      color: Colors.purple,
    ),
    PaymentMethod(
      id: 'CASH',
      name: 'Cash',
      icon: Icons.money,
      color: Colors.green,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._paymentMethods.map(_buildPaymentOption),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(PaymentMethod method) {
    final selected = widget.selectedMethod == method.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected ? method.color.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected ? method.color : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        leading: Icon(method.icon, color: selected ? method.color : Colors.grey),
        title: Text(method.name),
        trailing:
        selected ? Icon(Icons.check, color: method.color) : const SizedBox(),
        onTap: () => widget.onMethodSelected(method.id),
      ),
    );
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

