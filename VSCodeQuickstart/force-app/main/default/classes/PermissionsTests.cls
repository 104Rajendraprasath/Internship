@IsTest
private class PermissionsTests {
  @TestSetup
  static void testSetup() {
    // GIVEN
    Account acct = TestFactory.getAccount('No view For You!', true);
    Private_Object__c privateObj = new Private_Object__c(Account__c = acct.id, Notes__c = 'foo');
    insert privateObj;
  }
  @IsTest
  static void testNegativePermissionSet() {
    // GIVEN
    User userNew = TestFactory.generateUser('Standard User');
    System.runAs(userNew) {
      // WHEN
      Test.startTest();
        Private_Object__c[] privateObj = [SELECT Id, Account__c, Notes__c FROM Private_Object__c];
      Test.stopTest();
      // THEN
      Assert.areEqual(
        0,
        privateObj.size(),
        'A user without the permission set shouldn\'t see any records');
    }
  }
  @IsTest
  static void testPositivePermissionSet() {
    // GIVEN
    User userNew = TestFactory.generateUser('Standard User');
      PermissionSet permSet = [
      SELECT Id 
      FROM PermissionSet 
      WHERE Name = 'Private_Object_Access'
      LIMIT 1
    ];
     // 3. Assign the Permission Set to our new User
    insert new PermissionSetAssignment(
      AssigneeId = userNew.Id,
      PermissionSetId = permSet.Id
    );
     System.runAs(userNew) {
      Test.startTest();
      
      // Try to query the private object. (It was created in the @TestSetup method)
      Private_Object__c[] privateObj = [
          SELECT Id, Account__c, Notes__c 
          FROM Private_Object__c
      ];
      
      Test.stopTest();
      
      // THEN
      // Assert that the user CAN see the record (Size should be 1, not 0)
      Assert.areEqual(
        1,
        privateObj.size(),
        'A user with the permission set SHOULD see the record'
      );
    }
  }

}