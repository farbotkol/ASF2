trigger ECO_Induction_AllEvents on Induction__c (before update, before insert) {
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
        
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }   
}