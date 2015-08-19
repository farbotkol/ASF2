public without sharing class ECO_POLineItemTriggers {


	public void createDistributions(List<POLineItem__c> poLineItems){
		List<Distribution__c> distributions = new List<Distribution__c>();

	
		Date todayDate = Date.today();

		for(POLineItem__c poLineItem : poLineItems){
			if(!poLineItem.isArchived__c){
				Distribution__c distribution = new Distribution__c();
				distribution.POLineItem__c = poLineItem.Id;
				distribution.ExpenditureDate__c = todayDate;			
				distributions.add(distribution);
			}
			
		}

		if(!distributions.isEmpty()){
			insert distributions;
		}
	}
}