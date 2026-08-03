import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum UpdateStatus { upToDate, updateAvailable, checkFailed }

class UpdateCheckResult {
  final UpdateStatus status;
  final String? latestVersion;
  final String? releaseUrl;

  const UpdateCheckResult({
    required this.status,
    this.latestVersion,
    this.releaseUrl,
  });
}

/// Vergelijkt twee "X.Y.Z"-versiestrings (een voorloop-"v" en een
/// "+build"-toevoeging worden genegeerd). Geeft >0 als [a] nieuwer is dan
/// [b], <0 als ouder, 0 als gelijk. Ontbrekende/niet-numerieke delen tellen
/// als 0, dus "0.2" wint van "0.1.9".
int compareVersions(String a, String b) {
  int partAt(String version, int index) {
    final withoutV = version.startsWith('v') ? version.substring(1) : version;
    final parts = withoutV.split('+').first.split('.');
    if (index >= parts.length) return 0;
    return int.tryParse(parts[index]) ?? 0;
  }

  for (var i = 0; i < 3; i++) {
    final cmp = partAt(a, i).compareTo(partAt(b, i));
    if (cmp != 0) return cmp;
  }
  return 0;
}

/// Controleert GitHub Releases op een nieuwere versie dan de huidig
/// draaiende. Als instantie (niet via static calls) zodat dit in
/// widget-tests vervangen kan worden door een fake `http.Client`.
class UpdateService {
  static const _owner = 'Hidde-Balestra';
  static const _repo = 'taalleer';

  final http.Client _client;

  UpdateService({http.Client? client}) : _client = client ?? http.Client();

  Future<UpdateCheckResult> checkForUpdate(String currentVersion) async {
    try {
      final response = await _client
          .get(
            Uri.parse(
              'https://api.github.com/repos/$_owner/$_repo/releases/latest',
            ),
            headers: const {'Accept': 'application/vnd.github+json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return const UpdateCheckResult(status: UpdateStatus.checkFailed);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = json['tag_name'] as String?;
      final htmlUrl = json['html_url'] as String?;
      if (tagName == null) {
        return const UpdateCheckResult(status: UpdateStatus.checkFailed);
      }

      final latestVersion = tagName.startsWith('v')
          ? tagName.substring(1)
          : tagName;
      final isNewer = compareVersions(latestVersion, currentVersion) > 0;
      return UpdateCheckResult(
        status: isNewer
            ? UpdateStatus.updateAvailable
            : UpdateStatus.upToDate,
        latestVersion: latestVersion,
        releaseUrl: htmlUrl,
      );
    } catch (_) {
      return const UpdateCheckResult(status: UpdateStatus.checkFailed);
    }
  }

  Future<void> openReleasePage(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
