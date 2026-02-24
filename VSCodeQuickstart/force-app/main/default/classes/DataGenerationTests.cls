@IsTest
private class DataGenerationTests {

@TestSetup
static void dataCreation() {
  // GIVEN
  Account acct = TestDataFactory.getAccount('Muddy Waters Inc.', true);
  Contact con = TestDataFactory.getContact(acct.id, 'Muddy', 'Waters', true);
  List<Opportunity> opps = TestDataFactory.generateOppsForAccount(acct.id, 1400.00, 1);
  insert opps;
}

  @IsTest
  static void testBruteForceAccountCreation() {
    // GIVEN
    List<Account> accts;
    // WHEN
    Account acct = new Account(name='McTesterson LLC');
    insert acct;
    Test.startTest();
      accts = [SELECT Id FROM Account];
    Test.stopTest();
    // THEN
    Assert.isTrue(accts.size() > 0, 'Was expecting to find at least one account');
  }
  @IsTest
static void testUseTestFactoryToCreateAccountsWithContacts() {
  // GIVEN
  List<Account> accts;
  List<Contact> contacts;
  TestDataFactory.generateAccountWithContacts(5);
  // WHEN
  Test.startTest();
    accts = [SELECT Id FROM Account];
    contacts = [SELECT Id FROM Contact];
  Test.stopTest();
  // THEN
  Assert.isTrue(accts.size() > 0, 'Was expecting to find at least one account');
  Assert.areEqual(6, contacts.size(), 'Was expecting to find 5 contacts');
}
@IsTest
static void testAtTestSetupMethodsRule() {
  // WHEN
  Test.startTest();
    List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity];
  Test.stopTest();
  // THEN
  Assert.areEqual(1, opps.size(), 'Expected test to find a single Opp');
}
}