trigger ECO_Project_AllEvents on pse__Proj__c (before update, after insert, after update) {

	if(trigger.isBefore && trigger.isUpdate){
		EcoDisableProjectOwnerTrigger__c mc = EcoDisableProjectOwnerTrigger__c.getOrgDefaults();

		if(!mc.DisableProjectOwnerTrigger__c){
			ECO_ProjectTriggers.setOwner(trigger.new);			
		}
		ECO_ProjectTriggers.indetifyChangeManagerRelatedUpdates(trigger.oldMap, trigger.new);
	}

	if (trigger.isAfter) {
		if (trigger.isInsert) {
			ECO_ProjectTriggers.maintainEscalationAlerts(trigger.oldMap, trigger.newMap);
		} else if (trigger.isUpdate) {
			ECO_ProjectTriggers.maintainEscalationAlerts(trigger.oldMap, trigger.newMap);
			ECO_ProjectTriggers.handleDefaultingTaskOwningCustomer(trigger.oldMap, trigger.newMap);
			ECO_ProjectTriggers.handleProjectRestart(trigger.oldMap, trigger.newMap);
		}
	}
}