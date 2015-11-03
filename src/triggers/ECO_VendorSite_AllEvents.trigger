trigger ECO_VendorSite_AllEvents on VendorSite__c (before insert, before update) {

    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
        
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }   

}