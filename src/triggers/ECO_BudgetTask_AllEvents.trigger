trigger ECO_BudgetTask_AllEvents on BudgetTask__c (after delete, after insert, after undelete, 
after update, before insert, before update) {
	if (trigger.isAfter) {
		if (trigger.isInsert) {
			ECO_BudgetTaskTriggers.rollUpBudgetTaskValues(trigger.oldMap, trigger.newMap);
			ECO_BudgetTaskTriggers.calculateBottomTaskFlag(trigger.new, trigger.old);
		} else if (trigger.isUpdate) {
			ECO_BudgetTaskTriggers.rollUpBudgetTaskValues(trigger.oldMap, trigger.newMap);
			ECO_BudgetTaskTriggers.calculateBottomTaskFlag(trigger.new, trigger.old);
		} else if (trigger.isDelete) {
			ECO_BudgetTaskTriggers.rollUpBudgetTaskValues(trigger.oldMap, trigger.newMap);
			ECO_BudgetTaskTriggers.calculateBottomTaskFlag(trigger.new, trigger.old);
		} else if (trigger.isUndelete) {
			ECO_BudgetTaskTriggers.rollUpBudgetTaskValues(trigger.oldMap, trigger.newMap);
			ECO_BudgetTaskTriggers.calculateBottomTaskFlag(trigger.new, trigger.old);
		}
	} else if (trigger.isBefore) {
		if (trigger.isInsert) {
            ECO_BudgetTaskTriggers.setCurrency(trigger.new);
			ECO_BudgetTaskTriggers.calculateDepth(trigger.new);
		} else if (trigger.isUpdate) {
			ECO_BudgetTaskTriggers.calculateDepth(trigger.new);
		} else if (trigger.isUndelete) {
			ECO_BudgetTaskTriggers.calculateDepth(trigger.new);
		}
	}
}