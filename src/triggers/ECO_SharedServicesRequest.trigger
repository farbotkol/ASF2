trigger ECO_SharedServicesRequest on SharedServicesRequest__c (before update, after update) {
    
    if(trigger.isUpdate && trigger.isBefore){
        //ECO_SharedServicesRequestTrigger.HandleValidation(trigger.new);
        ECO_SharedServicesRequestTrigger.HandleGeneration(trigger.new);
    }

    if(trigger.isUpdate && trigger.isAfter){
    	ECO_SharedServicesRequestTrigger.UpdateAccountDB(trigger.new, trigger.oldMap);
    }

}