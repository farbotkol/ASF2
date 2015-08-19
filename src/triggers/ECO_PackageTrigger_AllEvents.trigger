trigger ECO_PackageTrigger_AllEvents on Packages__c (after insert, after update) {
	
	if(trigger.isAfter){
		if(trigger.isInsert){
			ECO_PackageTriggerHelper.attachHealthStart(trigger.new, null);
		} else if (trigger.isUpdate) {
			ECO_PackageTriggerHelper.attachHealthStart(trigger.new, trigger.oldMap);
		}
	}
	if(trigger.isBefore)
	{
		if(trigger.isUpdate)
			ECO_PackageTriggerHelper.setChangeManagerIsChanged(trigger.oldMap, trigger.new);	
	}
			
}