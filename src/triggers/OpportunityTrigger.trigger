trigger OpportunityTrigger on Opportunity (before insert, before update, before delete,
	  after insert, after update, after delete, after undelete) {

	if (Trigger.isBefore && Trigger.isInsert) OpportunityTriggerHandler.handleBeforeInsert(Trigger.new);
	else if (Trigger.isBefore && Trigger.isUpdate) OpportunityTriggerHandler.handleBeforeUpdate(Trigger.newMap,Trigger.oldMap);
	else if (Trigger.isBefore && Trigger.isDelete) OpportunityTriggerHandler.handleBeforeDelete(Trigger.newMap,Trigger.oldMap);
	else if (Trigger.isAfter && Trigger.isInsert) OpportunityTriggerHandler.handleAfterInsert(Trigger.new);
	else if (Trigger.isAfter && Trigger.isUpdate) OpportunityTriggerHandler.handleAfterUpdate(Trigger.newMap,Trigger.oldMap);
	else if (Trigger.isAfter && Trigger.isDelete) OpportunityTriggerHandler.handleAfterDelete(Trigger.newMap,Trigger.oldMap);
	else if (Trigger.isAfter && Trigger.isUndelete) OpportunityTriggerHandler.handleAfterUndelete(Trigger.new);
}