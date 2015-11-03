trigger ECO_Risk_AllEvents on Risk__c (before update, after update, after insert) {

    if(trigger.isBefore && trigger.isUpdate)
        ECO_RiskTriggers.handleRiskBeforeUpdate(trigger.oldMap, trigger.new);
    
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
        
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    } 
}