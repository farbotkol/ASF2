trigger ECO_Agreements_AllEvents on Agreement__c (before update, after update, after insert, after delete) {
	
	if(trigger.isBefore && trigger.isUpdate)
		ECO_AgreementTriggerHandler.handleAgreementBeforeUpdate(trigger.oldMap, trigger.newMap);
	if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert))
	{
		ECO_AgreementTriggerHandler.calculateTaskOrderValueForMSA(trigger.new);
		if(trigger.isUpdate)
			ECO_AgreementTriggerHandler.handleSegmentationApproval(trigger.oldMap, trigger.newMap);
	}
	if(trigger.isAfter && trigger.isDelete)
		ECO_AgreementTriggerHandler.calculateTaskOrderValueForMSA(trigger.old);
		

}