@isTest
public class CalculatorTests {
    
    @isTest
    static void testDivideByZero() {
        // We set a flag to track if the error was successfully caught
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            // We intentionally pass 0 as the denominator to force the error
            Decimal result = Calculator.divide(10, 0);
            
        } catch (Calculator.CalculatorException e) {
            // If the code jumps here, it means the error was successfully thrown!
            exceptionThrown = true;
            
            // We verify the exact error message matches what the developer wrote
            System.assertEquals('You still can\'t divide by zero', e.getMessage(), 'Error message does not match');
        }
        Test.stopTest();
        
        // Final assertion to prove the exception actually happened
        System.assert(exceptionThrown, 'A CalculatorException should have been thrown for dividing by zero');
    }
}