import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:announcements_domain/announcements_domain.dart';
import 'package:announcements_presentation/announcements_presentation.dart';

class _Repository implements AnnouncementsRepository {
  @override
  Future<List<AnnouncementsItem>> listItems(
          {bool forceRefresh = false}) async =>
      const [AnnouncementsItem(id: '1', title: 'Loaded item')];
  @override
  Future<void> clearCache() async {}
}

void main() {
  testWidgets('UI loads items through BLoC and use case', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: AnnouncementsPage(
      createBloc: () => AnnouncementsBloc(
        ListAnnouncementsItems(_Repository()),
        ClearAnnouncementsCache(_Repository()),
      ),
    )));
    await tester.pumpAndSettle();
    expect(find.text('Loaded item'), findsOneWidget);
  });
}
