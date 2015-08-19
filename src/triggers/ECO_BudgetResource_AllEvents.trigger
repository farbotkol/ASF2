trigger ECO_BudgetResource_AllEvents on BudgetResource__c (before insert) {
	if (trigger.isBefore) {
		if (trigger.isInsert) {
			ECO_BudgetResourceTriggers.defaultCostRevenueValuesOnHeader(trigger.new);
		}
	}
}