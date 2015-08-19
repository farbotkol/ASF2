global class ECO_ProjectHealthCheckBatch implements Database.Batchable<sObject>{

	private String query = 'select Id, Name, pse__Project_Manager__r.User__c, Project_Manager_User__c from pse__Proj__c where isClosed__c = false';
	
    global Database.QueryLocator start(Database.BatchableContext projectHealthCheckBatchContext)
    {   
    	System.Debug(LoggingLevel.Info, 'Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext projectHealthCheckBatchContext, List<pse__Proj__c> projects)
    {  	
    	System.Debug(LoggingLevel.Info, 'Projects Results Size' + projects.size());
    	
   		list<ECO_HealthCheckEvaluator.Response> healthResponses = new List<ECO_HealthCheckEvaluator.Response>();
   		list<PortalMessage__c> alerts = new list<PortalMessage__c>();

		//Id alertRecordTypeId = [select Id from RecordType where sObjectType = 'PortalMessage__c' and name = 'Alert' limit 1].Id;
		// TAL - There is a utility method to do this that doesn't burn a query, and is cached.
		// hard coded strings should be in the constants class as to not create a maintenance nightmare
		Id alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);

		for(pse__Proj__c project:projects)
		{
   			healthResponses = ECO_HealthCheckEvaluator.EvaluateProject(project.Id);
   			for(ECO_HealthCheckEvaluator.Response response:healthResponses)
   			{
   				if(response.evalResult)
   				{
   					// TAL - To Author:  Please use the leading comma pattern (like I did below)... it hurts way less to manipulate in the future
   					alerts.add(new PortalMessage__c(RecordTypeId = alertRecordTypeId
   													, User__c = project.Project_Manager_User__c
   													, StartDate__c = Date.today()
   													, EndDate__c = Date.today().addDays(7)
   													, LongDescriptionMaxLength__c = response.message
   													, Subject__c = project.Name
   													, LinkToRecord__c = '/' + project.Id
   												));  
   				}												
   			}
		}	
		/*		
		if(alerts.size() > 0)
			insert alerts;
		*/
		// TAL - Always scope conditionals!!
		// Use IsEmpty instead of size() > 0 (faster, especially in batch)
		if(!alerts.isEmpty()) {
			insert alerts;
		}
    }	
    
    global void finish(Database.BatchableContext projectHealthCheckBatchContext)
    {   	
    	
        system.debug('Cascade Attachment Batch completed');
    }    
}