trigger ECO_SurveySchedule_AllEvents on SurveySchedule__c (before insert, before update) {

    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    } 

}