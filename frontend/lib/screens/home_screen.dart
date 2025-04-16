import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isMobile
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LeftTextContent(),
                    const SizedBox(height: 30),
                    _RightImageContent(),
                    const SizedBox(height: 20),
                    const _ConnexionButton(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Center(child: _LeftTextContent()),
                    ),
                    Expanded(
                      child: _RightImageContent(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _LeftTextContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Lancez-vous dans les cryptos avec CryptoInfo",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Rejoignez les dizaines d'utilisateurs qui font confiance à notre app pour vous entraîner à acheter et vendre des cryptos.",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}

class _RightImageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        '../../assets/images/img_main_bg1.png',
        width: 350,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _ConnexionButton extends StatelessWidget {
  const _ConnexionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // À remplacer par une redirection si besoin
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        "S'inscrire",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
