public with sharing class EquipmentMaintenanceCtrl {
    @AuraEnabled(cacheable=true)
    public static List<Maintenance_Log__c> getMaintenanceLogs(Id equipmentId) {
        return[
            SELECT Id, Name, Service_Date__c, Technician__c, Issue_Description__c, Cost__c
            FROM Maintenance_Log__c
            WHERE Equipment__c = :equipmentId
            ORDER BY Service_Date__c DESC
        ];
    }
}