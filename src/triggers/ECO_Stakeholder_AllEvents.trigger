trigger ECO_Stakeholder_AllEvents on Stakeholder__c (before update) {

	if(trigger.isBefore && trigger.isUpdate)
		ECO_StakeholderTriggers.handleStakeholderBeforeUpdate(trigger.oldMap, trigger.new);

}