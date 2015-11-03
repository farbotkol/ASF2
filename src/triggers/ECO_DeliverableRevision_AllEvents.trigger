trigger ECO_DeliverableRevision_AllEvents on DeliverableRevision__c ( before insert, before update ) {

    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        system.debug( 'ECO_DeliverableRevision_AllEvents executed' );
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    } 
    
}