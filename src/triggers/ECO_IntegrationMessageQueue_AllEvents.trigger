trigger ECO_IntegrationMessageQueue_AllEvents on IntegrationMessageQueue__c (after insert, after update) {
	if (trigger.isAfter) {
		if (trigger.isInsert) {
			ECO_IntegrationMessageQueueTriggers.updateProjectNumber(trigger.new);
		} else if (trigger.isUpdate) {
			ECO_IntegrationMessageQueueTriggers.updateProjectNumber(trigger.new);
			ECO_IntegrationMessageQueueTriggers.updatePMOwnerFromKeymembers(trigger.new);
		}
	}
}