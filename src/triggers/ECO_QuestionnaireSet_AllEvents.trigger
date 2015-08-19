trigger ECO_QuestionnaireSet_AllEvents on QuestionnaireSet__c (after insert, after update) {

    if (trigger.isAfter) {
        if (trigger.isUpdate) {
        	ECO_RiskMarketAssessmentTriggerHandler.handleRiskMarketAssessmentAfterUpdate(trigger.oldMap, trigger.newMap);     	
        }
    }

}