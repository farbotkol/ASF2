trigger ECO_Stakeholder_AllEvents on Stakeholder__c (before update, before insert) {

    if(trigger.isBefore && trigger.isUpdate)
        ECO_StakeholderTriggers.handleStakeholderBeforeUpdate(trigger.oldMap, trigger.new);

    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        system.debug( 'ECO_Stakeholder_AllEvents executed' );
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }  
}