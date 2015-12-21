trigger ECO_ProjectTask_AllEvents on pse__Project_Task__c (before insert, before update, after insert, after update, before delete) {
    system.debug('ProjectTask Trigger.new: ' + Trigger.new);
    
if(trigger.isUpdate && ECO_ProjectTaskTriggers.hasUpdateRan) {

} else {

    if(trigger.isUpdate) {
        ECO_ProjectTaskTriggers.hasUpdateRan = true;
    }
    if (trigger.isBefore) {
        if ((trigger.isInsert) || (trigger.isUpdate)) {
            //ECO_ProjectTaskTriggers.copyCarryingOutToTask(trigger.new);

            ECO_ProjectTaskTriggers.applyLookups(trigger.new);
            ECO_ProjectTaskTriggers.calculateFiscalMonths(trigger.new); 
        }
    }

    if (trigger.isAfter) {
        ECO_ProjectTaskTriggers.recalculateProjectDates(trigger.new);
    }
     
     ECO_ProjectTaskTriggers.legacyCalcsFromTriggerBody(trigger.isBefore
                                                        , trigger.IsInsert
                                                        , trigger.IsUpdate
                                                        , trigger.IsDelete
                                                        , trigger.IsAfter
                                                        , trigger.new
                                                        , trigger.old
                                                        , trigger.oldMap);
     
    if (trigger.isAfter) {
        if ((trigger.isInsert) || (trigger.isUpdate)) {
            ECO_ProjectTaskTriggers.recalculateBudgets(trigger.new);

            ECO_ProjectTaskTriggers.calculateEarnedValueSnaps(trigger.new);
            

            //ECO_ProjectTaskTriggers.getScheduleName(trigger.new);
        }
    }
    
    if(trigger.IsBefore && trigger.IsInsert){
        ECO_ProjectTaskTriggers.handleDefaultingTaskOwningCustomer(trigger.new);
    }

    if(trigger.IsBefore && trigger.IsDelete)
        ECO_ProjectTaskTriggers.handleRemovingAssociatedFunding(trigger.old);

    if(trigger.IsAfter && trigger.IsInsert){
        ECO_ProjectTaskTriggers.replicateNewProjectTask(trigger.new);
    }
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){
        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
        
        //Added By Eric Starts Here
        if(trigger.isUpdate)
        {
            ECO_ProjectTaskTriggerHelper.OnBeforeUpdate(trigger.New,trigger.Oldmap);
        }
        else if(trigger.isInsert)
        {
            ECO_ProjectTaskTriggerHelper.OnBeforeInsert(trigger.New);
        }
        //Added By Eric Ends Here
    }    
}
}