trigger ECO_ProjectCity_AllEvents on ProjectCity__c ( before insert, before update ) {

    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
        
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }   
}