trigger ECO_CostDistLine_AllEvents on CostDistLine__c (before insert, before update, after delete, after insert, after update, after undelete) {
	if (trigger.isAfter) {
		if (trigger.isInsert) {
			ECO_CostDistributionLineTriggers.rollUpCosts(trigger.old, trigger.new);
		} else if (trigger.isUpdate) {
			ECO_CostDistributionLineTriggers.rollUpCosts(trigger.old, trigger.new);
		} else if (trigger.isDelete) {
			ECO_CostDistributionLineTriggers.rollUpCosts(trigger.old, trigger.new);
		} else if (trigger.isUndelete) {
			ECO_CostDistributionLineTriggers.rollUpCosts(trigger.old, trigger.new);
		}
	}
	
	if (Trigger.isBefore && !Trigger.isDelete){
		ECOCostDistributionLineTriggers.calculateFiscalMonths(trigger.new);   
	} 
}