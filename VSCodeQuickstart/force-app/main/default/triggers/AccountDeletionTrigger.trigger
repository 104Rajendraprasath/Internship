trigger AccountDeletionTrigger on Account (before delete) {
  // Prevent the deletion of accounts if they have related opportunities.
  for(Account acct : [SELECT Id FROM Account
    WHERE Id IN (SELECT AccountId FROM Opportunity) AND
    Id IN :Trigger.old]) {
    Trigger.oldMap.get(acct.Id).addError(
      'Cannot delete account with related opportunities.');
  }
}