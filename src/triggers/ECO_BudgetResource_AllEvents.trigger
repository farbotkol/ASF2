trigger ECO_BudgetResource_AllEvents on BudgetResource__c (before insert, before update, after insert, after update) {
    if (trigger.isBefore) {
        if (trigger.isInsert) {
            ECO_BudgetResourceTriggers.defaultCostRevenueValuesOnHeader(trigger.new);
            ECO_BudgetResourceTriggers.setCurrency(trigger.new);
            ECO_BudgetResourceTriggers.calculateMultiplier(trigger.new);

// commented out by Graham - can't have this failing silently
/*
            try {
                ECO_BudgetResourceTriggers.calculateMultiplier(trigger.new);
            } catch (Exception ex) {
                System.debug(LoggingLevel.ERROR, 'failed to apply multiplier');
                System.debug(LoggingLevel.ERROR, ex);
            }
*/            
        }
    }
    
    if (trigger.isAfter){
        ECO_BudgetResourceTriggers.setDefaultValues(trigger.newMap);
    }
    
    /*
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
        
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
    } 
    */  
    
}