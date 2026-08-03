import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:taalleer/update_service.dart';

void main() {
  group('compareVersions', () {
    test('gelijke versies geven 0', () {
      expect(compareVersions('1.9.0', '1.9.0'), 0);
    });

    test('nieuwer geeft > 0, ouder geeft < 0', () {
      expect(compareVersions('1.9.0', '1.8.0'), greaterThan(0));
      expect(compareVersions('1.8.0', '1.9.0'), lessThan(0));
      expect(compareVersions('2.0.0', '1.9.9'), greaterThan(0));
    });

    test('ontbrekende delen tellen als 0', () {
      expect(compareVersions('0.2', '0.1.9'), greaterThan(0));
      expect(compareVersions('1.0', '1.0.0'), 0);
    });

    test('negeert een voorloop-"v"', () {
      expect(compareVersions('v1.9.0', '1.9.0'), 0);
      expect(compareVersions('v1.9.0', 'v1.8.0'), greaterThan(0));
    });

    test('negeert een "+build"-toevoeging', () {
      expect(compareVersions('1.9.0+9', '1.9.0+1'), 0);
      expect(compareVersions('1.9.0+9', '1.8.0+50'), greaterThan(0));
    });
  });

  group('UpdateService.checkForUpdate', () {
    test('geeft updateAvailable als de laatste release nieuwer is', () async {
      final service = UpdateService(
        client: MockClient(
          (request) async => http.Response(
            '{"tag_name":"v1.9.0","html_url":"https://example.com/release"}',
            200,
          ),
        ),
      );

      final result = await service.checkForUpdate('1.8.0');

      expect(result.status, UpdateStatus.updateAvailable);
      expect(result.latestVersion, '1.9.0');
      expect(result.releaseUrl, 'https://example.com/release');
    });

    test('geeft upToDate als de laatste release gelijk of ouder is', () async {
      final service = UpdateService(
        client: MockClient(
          (request) async =>
              http.Response('{"tag_name":"v1.9.0","html_url":"x"}', 200),
        ),
      );

      final result = await service.checkForUpdate('1.9.0');

      expect(result.status, UpdateStatus.upToDate);
    });

    test('geeft checkFailed bij een niet-200 statuscode', () async {
      final service = UpdateService(
        client: MockClient((request) async => http.Response('nope', 404)),
      );

      final result = await service.checkForUpdate('1.9.0');

      expect(result.status, UpdateStatus.checkFailed);
    });

    test('geeft checkFailed als tag_name ontbreekt', () async {
      final service = UpdateService(
        client: MockClient((request) async => http.Response('{}', 200)),
      );

      final result = await service.checkForUpdate('1.9.0');

      expect(result.status, UpdateStatus.checkFailed);
    });

    test('geeft checkFailed bij een netwerkfout', () async {
      final service = UpdateService(
        client: MockClient((request) async => throw Exception('geen netwerk')),
      );

      final result = await service.checkForUpdate('1.9.0');

      expect(result.status, UpdateStatus.checkFailed);
    });

    test(
      'GET gaat naar de releases/latest-endpoint van Hidde-Balestra/taalleer',
      () async {
        Uri? requestedUri;
        final service = UpdateService(
          client: MockClient((request) async {
            requestedUri = request.url;
            return http.Response('{"tag_name":"v1.9.0","html_url":"x"}', 200);
          }),
        );

        await service.checkForUpdate('1.9.0');

        expect(
          requestedUri.toString(),
          'https://api.github.com/repos/Hidde-Balestra/taalleer/releases/latest',
        );
      },
    );
  });
}
