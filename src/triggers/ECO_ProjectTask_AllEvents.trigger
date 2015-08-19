trigger ECO_ProjectTask_AllEvents on pse__Project_Task__c (before insert, before update, after insert, after update, before delete) {
    if (trigger.isBefore) {
        if ((trigger.isInsert) || (trigger.isUpdate)) {
            //ECO_ProjectTaskTriggers.copyCarryingOutToTask(trigger.new);

            ECO_ProjectTaskTriggers.applyLookups(trigger.new);
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

            ECO_ProjectTaskTriggers.calculateEarnedValueSnaps(trigger.new);
            

            //ECO_ProjectTaskTriggers.getScheduleName(trigger.new);
        }
    }
    
    if(trigger.IsBefore && trigger.IsInsert){
        ECO_ProjectTaskTriggers.handleDefaultingTaskOwningCustomer(trigger.new);
    }

    if(trigger.IsAfter && trigger.IsInsert){
        ECO_ProjectTaskTriggers.replicateNewProjectTask(trigger.new);
    }
}