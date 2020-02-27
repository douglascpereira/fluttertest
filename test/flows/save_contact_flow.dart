import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../matchers/matchers.dart';
import '../mocks/mocks.dart';
import 'actions.dart';

void main() {
  MockContactDao mockContactDao;

  setUp(() async {
    mockContactDao = MockContactDao();
  });

  testWidgets('Should save a contact', (tester) async {
    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao,
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    await clickOnTheTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactList = find.byType(ContactsList);
    expect(contactList, findsOneWidget);

    verify(mockContactDao.findAll()).called(1);

    await clickOnTheFABNew(tester);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    await fillTextFieldWithTextLabel(tester, 'Alex', 'Full name');

    await fillTextFieldWithTextLabel(tester, '1000', 'Account number');

    await clickOntheRaisedButtonWithText(tester, 'Create');
    await tester.pumpAndSettle();

    verify(mockContactDao.save(Contact(0, 'Alex', 1000)));

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);

    //verify(mockContactDao.findAll());
  });
}

Future clickOntheRaisedButtonWithText(WidgetTester tester, String label) async {
  final createButton = find.widgetWithText(RaisedButton, label);
  expect(createButton, findsOneWidget);
  await tester.tap(createButton);
}

Future fillTextFieldWithTextLabel(WidgetTester tester, String text, String labelText) async {
  final nameTextField = find
      .byWidgetPredicate((widget) => textFieldByLabelTextMatcher(widget, labelText));
  expect(nameTextField, findsOneWidget);
  await tester.enterText(nameTextField, text);
}

Future clickOnTheFABNew(WidgetTester tester) async {
  final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
  expect(fabNewContact, findsOneWidget);
  await tester.tap(fabNewContact);
}
