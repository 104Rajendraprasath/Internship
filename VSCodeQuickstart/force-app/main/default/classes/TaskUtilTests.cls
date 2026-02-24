@IsTest
public with sharing class TaskUtilTests {
    @IsTest
    static void testGetTaskPriorityHigh() {
        //GIVEN
        String leadState = 'CA';
        //WHEN
        Test.startTest();
        String taskPriority = TaskUtil.getTaskPriority(leadState);
        Test.stopTest();
        //THEN
        System.Assert.areEqual('High', taskPriority, 'Task priority is not expected.');
}
     @IsTest
     static void testGetTaskPriorityNormal() {
        //GIVEN
        String leadState = 'NY';
        //WHEN
        Test.startTest();
        String taskPriority = TaskUtil.getTaskPriority(leadState);
        Test.stopTest();
        //THEN
        System.Assert.areEqual('Normal', taskPriority, 'Task priority is not expected.');

}
}