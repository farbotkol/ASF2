trigger ECO_VendorSub_AllEvents on VendorSub__c (before insert) {
    
  if(trigger.isBefore && trigger.isUpdate)
    ECO_VendorSubTriggerHandler.handleBeforeInsert(trigger.new);   
    
}