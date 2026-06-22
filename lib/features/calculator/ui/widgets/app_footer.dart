import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    await launchUrl(uri, webOnlyWindowName: '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1050),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF001B70),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          /// LOGO + NOMBRE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 65,
                height: 65,
                padding: const EdgeInsets.all(8),

                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.asset(
                    'assets/tanis-logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Grupo TANIS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Altas Soluciones para la Industria",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// CONTACTO
          const Text(
            "correo: tanis.dvc@ttanis.com",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          /// REDES
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 12,

            children: [
              _socialButton(
                icon: FontAwesomeIcons.facebookF,
                url: 'https://www.facebook.com/grupottanis',
              ),

              _socialButton(
                icon: FontAwesomeIcons.linkedinIn,
                url: 'https://www.linkedin.com/company/grupo-ttanis',
              ),

              _socialButton(
                icon: FontAwesomeIcons.globe,
                url: 'https://www.ttanis.com',
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(color: Colors.white24),

          const Text(
            "© 2026 Grupo Tanis - Todos los derechos reservados",
            style: TextStyle(color: Colors.white54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _socialButton({required IconData icon, required String url}) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: () async {
          await openUrl(url);
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),

          width: 52,
          height: 52,

          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),

            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),

          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
