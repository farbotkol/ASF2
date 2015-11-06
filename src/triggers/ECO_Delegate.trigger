/*
	Purpose: - Trigger on the Delegate__c object

	Created By: Aaron Pettitt (NTT Data)

	Revision Log: 
		v1.0 - (AP 10/30/2015) -- created 
*/
trigger ECO_Delegate on Delegate__c (before insert) {
	
	//populate the Delegator_User__c field from the Delegator__c contact info
	List<Id> contactIds = new List<Id>();
	for(Delegate__c delegate : trigger.new){
		contactIds.add(delegate.Delegator__c);
	}

	Map<Id, Contact> contactsMap = new Map<Id, Contact>([Select Id, pse__Salesforce_User__c from Contact where Id In : contactIds]);

	for(Delegate__c delegate : trigger.new){
		delegate.Delegator_User__c = contactsMap.get(delegate.Delegator__c).pse__Salesforce_User__c;
	}

}