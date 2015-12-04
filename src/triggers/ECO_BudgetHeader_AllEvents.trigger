trigger ECO_BudgetHeader_AllEvents on BudgetHeader__c (after update, before update, before insert) {
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
        
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
        ECO_BudgetHeaderTriggers.setCurrency(trigger.new);
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    }        
}