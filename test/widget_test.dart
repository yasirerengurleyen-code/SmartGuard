import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:smartguard/app.dart';
import 'package:smartguard/providers/alarms_provider.dart';
import 'package:smartguard/providers/history_provider.dart';
import 'package:smartguard/providers/settings_provider.dart';
import 'package:smartguard/providers/system_status_provider.dart';

void main() {
  testWidgets('SmartGuard splash shows app name', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => SystemStatusProvider()),
          ChangeNotifierProvider(create: (_) => AlarmsProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ],
        child: const SmartGuardApp(),
      ),
    );

    expect(find.text('SmartGuard'), findsOneWidget);

    // Avoid pumpAndSettle — looping UI animations never idle.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('SmartGuard'), findsWidgets);
  });
}
