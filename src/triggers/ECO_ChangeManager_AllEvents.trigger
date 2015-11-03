trigger ECO_ChangeManager_AllEvents on ChangeManager__c (after update, before update, before insert, after insert) {
    
    if(trigger.isBefore && trigger.isUpdate && ECO_ChangeManagerTriggerHandler.EXECUTE_TRIGGER)
        ECO_ChangeManagerTriggerHandler.handleChangeManagerBeforeUpdate(trigger.oldMap, trigger.new);
    
    if(trigger.isAfter && trigger.isUpdate && ECO_ChangeManagerTriggerHandler.EXECUTE_TRIGGER)
        ECO_ChangeManagerTriggerHandler.handleChangeManagerUpdate(trigger.oldMap, trigger.new);
        
    if( trigger.isBefore && trigger.isUpdate && ECO_ChangeManagerTriggerHandler.EXECUTE_TRIGGER ){
        system.debug( 'ECO_QuestionnaireSet_AllEvents executed' );
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }  
    
    // ******* DELEGATION TRIGGER LOGIC
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        ECO_Service_Delegation.insertDelegations(trigger.new);
    }
        
    if(trigger.isBefore && trigger.isInsert){

        ECO_Service_Delegation.evaluateDelegation(trigger.new, null);
    }

    if(trigger.isBefore && trigger.isUpdate){
        ECO_Service_Delegation.evaluateDelegation(trigger.new, trigger.oldMap);
    }
    //******* END OF THE DELEGATION TRIGGER LOGIC     

}