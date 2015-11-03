trigger ECO_BudgetSetupQuestionnaire_AllEvents on BudgetSetupQuestionnaire__c (before update, before insert) {

    ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );

}