@IsTest
private class AccountDeletionTriggerTests {
  @IsTest
  static void testDeleteAccountWithOneOpportunity() {
    // GIVEN
    // Create one account with one opportunity by calling utility method
    Account acct = TestFactory.getAccount('ACME', true);
    List<Opportunity> opps = TestFactory.generateOppsForAccount(acct.id, 1000.00, 1);
    insert opps;
    // WHEN
    Test.startTest();
    Database.DeleteResult result = Database.delete(acct, false);
    Test.stopTest();
    // THEN
    // In this case the deletion should have been stopped by the trigger,
    // so verify that we got back an error.
    Assert.isFalse(result.isSuccess());
    Assert.isTrue(result.getErrors().size() > 0);
    Assert.areEqual(
      'Cannot delete account with related opportunities.',
      result.getErrors()[0].getMessage());
  }
  
  @IsTest
  static void testDeleteAccountWithNoOpportunities() {
    // GIVEN
    // Create one account with no opportunities by calling a utility method
    Account acct = TestFactory.getAccount('ACME', true);
    // WHEN
    Test.startTest();
      Database.DeleteResult result = Database.delete(acct, false);
    Test.stopTest();
    // THEN
    // Verify that the deletion was successful
    Assert.isTrue(result.isSuccess());
  }
  @IsTest
  static void testDeleteBulkAccountsWithOneOpportunity() {
    // GIVEN
    // Create accounts with one opportunity each by calling a utility method
    Account[] accts = TestFactory.generateAccountsWithOpps(200,1);
    // WHEN
    Test.startTest();
      Database.DeleteResult[] results = Database.delete(accts, false);
    Test.stopTest();
    // THEN
    // In this case the deletion should have been stopped by the trigger,
    // so check that we got back an error.
    for(Database.DeleteResult dr : results) {
      Assert.isFalse(dr.isSuccess());
      Assert.isTrue(dr.getErrors().size() > 0);
      Assert.areEqual(
        'Cannot delete account with related opportunities.',
        dr.getErrors()[0].getMessage());
    }
  }
  
  @IsTest
  static void testDeleteBulkAccountsWithNoOpportunities() {
    // GIVEN
    // Create accounts with no opportunities by calling a utility method
    Account[] accts = TestFactory.generateAccountsWithOpps(200,0);
    // WHEN
    Test.startTest();
      Database.DeleteResult[] results = Database.delete(accts, false);
    Test.stopTest();
    // THEN
    // For each record, verify that the deletion was successful
    for(Database.DeleteResult dr : results) {
      System.assert(dr.isSuccess());
    }
  }
}