trigger ECO_VendorSub_AllEvents on VendorSub__c (before insert, before update) {
    
  if(trigger.isBefore && trigger.isUpdate)
    ECO_VendorSubTriggerHandler.handleBeforeInsert(trigger.new);  
    
  if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
  }        
    
}