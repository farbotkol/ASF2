trigger ECO_Risk_AllEvents on Risk__c (before update) {

	if(trigger.isBefore && trigger.isUpdate)
		ECO_RiskTriggers.handleRiskBeforeUpdate(trigger.oldMap, trigger.new);
}