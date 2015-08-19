global class ECO_ProjectUnpaidBillingBatch implements Database.Batchable<sObject>{

	private String query = 'select Id, Name, OracleProjectNumber__c, pse__Project_Manager__c, pse__Project_Manager__r.Name, CMProjectClosureIsApproved__c from pse__Proj__c where pse__Stage__c != \'Closed\'';
	
    global Database.QueryLocator start(Database.BatchableContext projectClosureBatchContext)
    {   
    	System.Debug(LoggingLevel.Info, 'Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext projectClosureBatchContext, List<pse__Proj__c> projects)
    {  	
    	map<Id, Decimal> projectRevenueMap = new map<Id, Decimal>();
    	map<Id, Decimal> projectBillingMap = new map<Id, Decimal>();
    	map<Id, pse__Proj__c> projectMap = new map<Id, pse__Proj__c>();
    	
    	for(pse__Proj__c project:projects)
    	{
    		projectRevenueMap.put(project.Id, 0);
    		projectBillingMap.put(project.Id, 0);	
    		projectMap.put(project.Id, project);	
    	}
    	
    	Date asOfDate = Date.today().addDays(-90);
		list<AggregateResult> revenue = [select ProjectNumber__c Project, sum(Amount__c) Amount from Revenue__c where ProjectNumber__c in :projects and GLDate__c < :asOfDate group by ProjectNumber__c];
		list<AggregateResult> billing = [select ProjectNumber__c Project, sum(InvoiceAmount__c) from Billing__c where ProjectNumber__c in :projects group by ProjectNumber__c];
    
   		for(AggregateResult ar:revenue)
   			projectRevenueMap.put((Id)ar.get('Project'), (Decimal)ar.get('Amount'));
   			
   		for(AggregateResult ar:billing)
   			projectBillingMap.put((Id)ar.get('Project'), (Decimal)ar.get('Amount'));		
   			
   					
		Id alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);
		list<PortalMessage__c> alerts = new list<PortalMessage__c>();
		for(pse__Proj__c project:projectMap.values())
		{
			if((projectRevenueMap.get(project.Id) - projectBillingMap.get(project.Id)) > 0)
			{
   				alerts.add(new PortalMessage__c(RecordTypeId = alertRecordTypeId
   											, User__c = project.Project_Manager_User__c
   											, StartDate__c = Date.today()
   											, EndDate__c = Date.today().addDays(1)
   											, LongDescriptionMaxLength__c = 'This project has reached 90 days unpaid.'
   											, Subject__c = project.Name
   											, LinkToRecord__c = '/' + project.Id
   											));     	
			}			
   		}													

		if(!alerts.isEmpty()) {
			insert alerts;
		}
   		
    
    }	
    
    global void finish(Database.BatchableContext projectClosureBatchContext)
    {   	   	
        system.debug('Batch completed');
    }    
}