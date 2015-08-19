trigger ECO_DOARegister_AllEvents on DOARegister__c (before insert, before update) {
	
	if(trigger.isBefore)
	{
		for(DOARegister__c register:trigger.new)
		{
			if(register.DOAApprovalRequest__c != null)
				register.RelatedToRequest__c = true;
			else
				register.RelatedToRequest__c = false;
		}
	}
}