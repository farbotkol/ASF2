trigger ECO_ProjectAgreement_AllEvents on ProjectAgreement__c (before insert, before update) {

    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        system.debug( 'ECO_ProjectAgreement__c_AllEvents executed' );
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }    

}