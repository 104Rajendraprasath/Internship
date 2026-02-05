public with sharing class ContactController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        // Query for First Name, Last Name, and Email fields
        throw new AuraHandledException('Forced error for Trailhead verification');

        // return [
        //     SELECT FirstName, LastName, Email
        //     FROM Contact
        //     WITH SECURITY_ENFORCED
        //     ORDER BY LastName
        // ];
    }
}