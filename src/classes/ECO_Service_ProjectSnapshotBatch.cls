global class  ECO_Service_ProjectSnapshotBatch implements Database.Batchable<sObject> {
    
    String query;
    public List<Id> projectIdList {get; set;}
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //query ='SELECT Id FROM pse__Proj__c';
        query = 'SELECT Id FROM pse__Proj__c WHERE Id IN : projectIdList';
        return Database.getQueryLocator(query);
    }

	global void execute(Database.BatchableContext BC, List<pse__Proj__c> scope) {
	//global static void execute2(List<pse__Proj__c> scope) {
		// batch size = 1 -> GenerateProjectSnapshotsByDateRange flow
		DateTime startDateTime;
		DateTime endDateTime;	
		Date startDate;
		Date endDate;
        List<Id> projectIds = new List<Id>();
        for (pse__Proj__c ps : scope) {
        	projectIds.add(ps.Id);
        }
        
        ECO_Service_ProjectSnapshots pSnapshots = new ECO_Service_ProjectSnapshots(projectIds);
         
        if (endDateTime == null) {
        	endDate = Date.today();
        }
        
        if (startDateTime == null) { 
        	startDate = endDate.addDays(-14);
        }
        
        for (Date snapshotDate = startDate; snapshotDate <= endDate; snapshotDate.addDays(1)) {
        	DateTime dt = DateTime.newInstance(snapshotDate, Time.newInstance(0,0,0,0));
        	pSnapshots.createProjectSnapshots(dt);
        }
	}
    
    global void finish(Database.BatchableContext BC) {
    
    }
}