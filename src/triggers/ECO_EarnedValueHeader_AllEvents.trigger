trigger ECO_EarnedValueHeader_AllEvents on EarnedValueHeader__c (before insert, before update) {
    
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
        
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }   
}