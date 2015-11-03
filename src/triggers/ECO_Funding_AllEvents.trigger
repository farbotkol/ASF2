trigger ECO_Funding_AllEvents on Funding__c (before insert, before update) {

    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        system.debug( 'ECO_QuestionnaireSet_AllEvents executed' );
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    } 
}