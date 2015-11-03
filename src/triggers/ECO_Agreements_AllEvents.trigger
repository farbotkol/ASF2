trigger ECO_Agreements_AllEvents on Agreement__c (before update, after update, before insert, after insert, after delete) {
    
    if(trigger.isBefore && trigger.isUpdate)
        ECO_AgreementTriggerHandler.handleAgreementBeforeUpdate(trigger.oldMap, trigger.newMap);
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert))
    {
        //AECOMAgrmntDelegetionActions.AgreementRecords(trigger.new);
        ECO_AgreementTriggerHandler.calculateTaskOrderValueForMSA(trigger.new);        
        if(trigger.isUpdate)
            ECO_AgreementTriggerHandler.handleSegmentationApproval(trigger.oldMap, trigger.newMap); 
           // AECOMAgrmntDelegetionActions.UpdateAgreementRecords(trigger.oldMap, trigger.newMap);          
    }
    if(trigger.isAfter && trigger.isDelete)
        ECO_AgreementTriggerHandler.calculateTaskOrderValueForMSA(trigger.old);


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