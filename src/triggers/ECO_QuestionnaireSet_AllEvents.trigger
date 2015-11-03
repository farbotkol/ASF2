trigger ECO_QuestionnaireSet_AllEvents on QuestionnaireSet__c (after insert, after update, before insert, before update) {

    if (trigger.isAfter) {
        if (trigger.isUpdate) {
            ECO_RiskMarketAssessmentTriggerHandler.handleRiskMarketAssessmentAfterUpdate(trigger.oldMap, trigger.newMap);       
        }
    }
    
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        system.debug( 'ECO_QuestionnaireSet_AllEvents executed' );
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }  
    
     // ****** DELEGATION TRIGGER LOGIC
    /**if(trigger.isAfter && trigger.isInsert){
        ECO_Service_Delegation.recordDelegation(trigger.new);
    }
        
    if(trigger.isBefore && trigger.isInsert){
        ECO_Service_Delegation.evaluateDelegation(trigger.new, null);
    }

    if(trigger.isBefore && trigger.isUpdate){
        ECO_Service_Delegation.evaluateDelegation(trigger.new, trigger.oldMap);
    }**/
    //******* END OF THE DELEGATION TRIGGER LOGIC       
}