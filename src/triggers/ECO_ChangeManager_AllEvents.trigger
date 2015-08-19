trigger ECO_ChangeManager_AllEvents on ChangeManager__c (after update, before update) {
	
	if(trigger.isBefore && trigger.isUpdate)
		ECO_ChangeManagerTriggerHandler.handleChangeManagerBeforeUpdate(trigger.oldMap, trigger.new);
	
	if(trigger.isAfter)
		ECO_ChangeManagerTriggerHandler.handleChangeManagerUpdate(trigger.oldMap, trigger.new);

}