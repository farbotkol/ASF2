public with sharing class ECO_RiskTriggers {

	public static void handleRiskBeforeUpdate(map<Id, Risk__c> oldRiskMap, list<Risk__c> updatedRisk)
	{
		for(Risk__c risk:updatedRisk)
		{
			if(!oldRiskMap.get(risk.Id).ChangeManagerIsChanged__c)
				risk.ChangeManagerIsChanged__c = true;
		}	
	}
}