trigger ECO_Project_AllEvents on pse__Proj__c (before update, before insert, after insert, after update) {

    if(trigger.isBefore && trigger.isInsert){
        ECO_ProjectTriggers.setCAMEmail(trigger.new);
    }

    if (trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        ECO_ProjectTriggers.permissionGanttViewEditToOwner(trigger.oldMap, trigger.new, trigger.isInsert);
    }

    if(trigger.isBefore && trigger.isUpdate){
        EcoDisableProjectOwnerTrigger__c mc = EcoDisableProjectOwnerTrigger__c.getOrgDefaults();

        if(!mc.DisableProjectOwnerTrigger__c){
            ECO_ProjectTriggers.setOwner(trigger.new);          
        }
        ECO_ProjectTriggers.indetifyChangeManagerRelatedUpdates(trigger.oldMap, trigger.new);
    }
    
    // Gets executed before and after
    if(trigger.isBefore && trigger.isUpdate)
    {    
        system.debug( 'Calling createResilienceDirectorTeamMember');
        
        ECO_ProjectTriggers.createResilienceDirectorTeamMember( trigger.oldMap, trigger.newMap, trigger.new );
    }   
    
    if( trigger.isBefore && ( trigger.isUpdate || trigger.isInsert ) ){       
           
        if( trigger.isUpdate )
        {
	        ECO_Service_RecordAccess.getProjectRecordAccess( trigger.new );
        
            ECO_ProjectTriggers.handleProjectCloseTo_OtherStatus( trigger.oldMap, trigger.newMap, trigger.new );
            
            ECO_ProjectTriggers.setExpenditureFlagOnProjectReOpen( trigger.new );
        }            
    }    

    if (trigger.isAfter) {
        if (trigger.isInsert) {
            ECO_ProjectTriggers.maintainEscalationAlerts(trigger.oldMap, trigger.newMap);
        } else if (trigger.isUpdate) {
            ECO_ProjectTriggers.maintainEscalationAlerts(trigger.oldMap, trigger.newMap);
            ECO_ProjectTriggers.handleDefaultingTaskOwningCustomer(trigger.oldMap, trigger.newMap);
            ECO_ProjectTriggers.handleProjectRestart(trigger.oldMap, trigger.newMap);
            ECO_ProjectTriggers.handleFundingLevelFlagChanges(trigger.oldMap, trigger.newMap);
        }
    }
    
    
    

}