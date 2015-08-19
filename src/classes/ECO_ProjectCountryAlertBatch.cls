global class ECO_ProjectCountryAlertBatch implements Database.Batchable<sObject> {
	
	String query = 'SELECT ID, Project__r.EcoSystemReferenceNumber__c, Project__r.name, Project__r.ownerid, Last_Country_Risk__c, Safety_Rating__c, CountryRisk__r.name FROM ProjectCountry_Risk__c WHERE Change_in_Risk__c > 0.5';
	
	global ECO_ProjectCountryAlertBatch() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		
   		list<PortalMessage__c>  alertsToInsert = new list<PortalMessage__c>();
   		list<ProjectCountry_Risk__c> projectRiskToInsert = new list<ProjectCountry_Risk__c>();
   		ECO_ProjectCountryRiskBatchHelper helper = new ECO_ProjectCountryRiskBatchHelper();

		for(sobject s : scope){
			ProjectCountry_Risk__c item = (ProjectCountry_Risk__c)s;

			alertsToInsert.add(helper.createNewAlert(item.Project__r, date.today(), 'COUNTRY: ' + item.CountryRisk__r.name + ' RISK HAS CHANGED FROM ' + string.valueof(item.Last_Country_Risk__c) + ' to ' + string.valueof(item.Safety_Rating__c))); 

			item.Last_Country_Risk__c = item.Safety_Rating__c;

			projectRiskToInsert.add(item);
		}

		insert alertsToInsert;
		upsert projectRiskToInsert;

	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
}