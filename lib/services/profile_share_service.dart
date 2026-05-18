import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileShareService {
  ProfileShareService._();

  static final ProfileShareService instance = ProfileShareService._();

  String profileLinkFor(String userId) {
    // Generate a simple dynamic link placeholder. In production hook to real dynamic links.
    return 'https://hogarya.app/u/$userId';
  }

  Future<void> share(String userId) async {
    final link = profileLinkFor(userId);
    await SharePlus.instance.share(ShareParams(text: 'Mira este perfil en HogarYa: $link', title: 'HogarYa'));
  }

  Future<void> copyLink(String userId) async {
    final link = profileLinkFor(userId);
    await Clipboard.setData(ClipboardData(text: link));
  }

  Future<void> openWhatsApp(String userId) async {
    final link = profileLinkFor(userId);
    final uri = Uri.parse('https://wa.me/?text=${Uri.encodeComponent(link)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> openTelegram(String userId) async {
    final link = profileLinkFor(userId);
    final uri = Uri.parse('https://t.me/share/url?url=${Uri.encodeComponent(link)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> openFacebook(String userId) async {
    final link = profileLinkFor(userId);
    final uri = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(link)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
