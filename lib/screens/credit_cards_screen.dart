import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditCardsScreen extends StatefulWidget {
  const CreditCardsScreen({Key? key}) : super(key: key);

  @override
  State<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  @override
  void initState() {
    super.initState();
    _loadCardData();
  }

  Future<void> _loadCardData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cardNumber = prefs.getString('cardNumber') ?? '';
      expiryDate = prefs.getString('expiryDate') ?? '';
      cardHolderName = prefs.getString('cardHolderName') ?? '';
      cvvCode = prefs.getString('cvvCode') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cards')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber.isNotEmpty ? cardNumber : '0000 0000 0000 0000',
              expiryDate: expiryDate.isNotEmpty ? expiryDate : '00/00',
              cardHolderName: cardHolderName.isNotEmpty ? cardHolderName : 'Your Name',
              cvvCode: cvvCode.isNotEmpty ? cvvCode : '000',
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (CreditCardBrand brand) {},
            ),
            const SizedBox(height: 24),
            CreditCardForm(
              formKey: _formKey,
              onCreditCardModelChange: (CreditCardModel data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                  isCvvFocused = data.isCvvFocused;
                });
              },
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              obscureCvv: false,
              obscureNumber: false,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('cardNumber', cardNumber);
                await prefs.setString('expiryDate', expiryDate);
                await prefs.setString('cardHolderName', cardHolderName);
                await prefs.setString('cvvCode', cvvCode);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Card saved')),
                );
              },
              child: const Text('Save Card'),
            ),
          ],
        ),
      ),
    );
  }
}
