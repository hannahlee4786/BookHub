import 'package:flutter_test/flutter_test.dart';
import 'package:book_hub_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BookHubApp());
    expect(find.text('Book Finder'), findsOneWidget);
  });
}