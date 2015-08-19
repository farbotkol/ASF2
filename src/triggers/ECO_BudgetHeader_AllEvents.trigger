trigger ECO_BudgetHeader_AllEvents on BudgetHeader__c (after update) {
	if (trigger.isAfter) {
		if (trigger.isUpdate) {
			ECO_BudgetHeaderTriggers.cascadeApprovalStatus(trigger.newMap, trigger.oldMap);
			ECO_BudgetHeaderTriggers.rollUpValuesToProject(trigger.new, trigger.old);
		} else if (trigger.isInsert) {
			ECO_BudgetHeaderTriggers.rollUpValuesToProject(trigger.new, trigger.old);
		} else if (trigger.isDelete) {
			ECO_BudgetHeaderTriggers.rollUpValuesToProject(trigger.new, trigger.old);
		} else if (trigger.isUndelete) {
			ECO_BudgetHeaderTriggers.rollUpValuesToProject(trigger.new, trigger.old);
		}
	}
}