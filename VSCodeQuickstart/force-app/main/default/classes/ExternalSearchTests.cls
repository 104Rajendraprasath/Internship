@IsTest
private class ExternalSearchTests {
  @IsTest
  static void testPositiveMocking() {
    // GIVEN
    HTTPMockFactory mock = new HTTPMockFactory(
      200,
      'OK',
      'I found it!',
      new Map<String, String>()
    );
    Test.setMock(HttpCalloutMock.class, mock);
    // WHEN
    Test.startTest();
      String result = ExternalSearch.googleIt('epic search');
    Test.stopTest();
    // THEN
    Assert.areEqual('I found it!', result, 'Expected to receive mock response');
  }
  @IsTest
  static void testNegativeMocking() {
    // GIVEN
    // Create a fake HTTP response that simulates a Server Error (Status 500)
    HTTPMockFactory mock = new HTTPMockFactory(
      500,
      'Internal Server Error',
      'Something went wrong',
      new Map<String, String>()
    );
    // Tell Salesforce to use this fake response
    Test.setMock(HttpCalloutMock.class, mock);

    // WHEN
    Boolean exceptionThrown = false;
    
    Test.startTest();
    try {
      // This will trigger the fake 500 response
      String result = ExternalSearch.googleIt('epic search');
    } catch (ExternalSearch.ExternalSearchException e) {
      // The code should jump here because the status is not 200
      exceptionThrown = true;
      
      // Verify the error message contains the status code 500
      Assert.isTrue(e.getMessage().contains('500'), 'Error message should contain the 500 status code');
    }
    Test.stopTest();

    // THEN
    // Assert that the exception was actually thrown
    Assert.isTrue(exceptionThrown, 'An ExternalSearchException should have been thrown for a 500 response');
  }
}