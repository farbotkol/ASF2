trigger ECO_CommunicationPlan_AllEvents on CommunicationPlan__c (before insert, before update) {
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        system.debug( 'CommunicationPlan_AllEvent executed' );
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }  
}