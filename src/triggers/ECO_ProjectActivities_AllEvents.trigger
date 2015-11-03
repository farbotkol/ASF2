trigger ECO_ProjectActivities_AllEvents on ProjectActivities__c (before update, before insert) {
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
        
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }   
}