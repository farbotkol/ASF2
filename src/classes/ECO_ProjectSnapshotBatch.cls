global class ECO_ProjectSnapshotBatch implements Database.Batchable<sObject> {
	
	String query;
	
	global ECO_ProjectSnapshotBatch() {
		query = 'select Id from pse__Proj__c';		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<pse__Proj__c> scope) {
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}