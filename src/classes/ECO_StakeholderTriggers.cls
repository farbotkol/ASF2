public class ECO_StakeholderTriggers {

	public static void handleStakeholderBeforeUpdate(map<Id, Stakeholder__c> oldStakeholderMap, list<Stakeholder__c> updatedStakeholders)
	{
		for(Stakeholder__c stakeholder:updatedStakeholders)
		{
			if(!oldStakeholderMap.get(stakeholder.Id).ChangeManagerIsChanged__c)
				stakeholder.ChangeManagerIsChanged__c = true;
		}	
	}

}