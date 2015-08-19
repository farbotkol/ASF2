global class ECO_ProjectExtendClosureDateBatch implements Database.Batchable<sObject>{

	private String query = 'select Id, Name, OracleProjectNumber__c, pse__Project_Manager__r.Name, Project_Manager_User__c, CMProjectClosureIsApproved__c from pse__Proj__c where CMProjectClosureIsApproved__c = false and ClosureDate__c <= TODAY';
	
    global Database.QueryLocator start(Database.BatchableContext projectClosureBatchContext)
    {   
    	System.Debug(LoggingLevel.Info, 'Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext projectClosureBatchContext, List<pse__Proj__c> projects)
    {  	
		list<Messaging.SingleEmailMessage> emailList = new list <Messaging.SingleEmailMessage>();
		list<PortalMessage__c> alerts = new list<PortalMessage__c>();
		
		Id alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);
		
		for(pse__Proj__c project:projects)  
		{
  			alerts.add(new PortalMessage__c(RecordTypeId = alertRecordTypeId
   											, User__c = project.Project_Manager_User__c 
   											, StartDate__c = Date.today()
   											, EndDate__c = Date.today().addDays(1)
   											, LongDescriptionMaxLength__c = ECO_Constants.PortalMessage_OpenProjectReviewMessage
   											, Subject__c = project.Name
   											, LinkToRecord__c = '/' + project.Id
   											));
		} 	
		
		if(alerts.size() > 0)
			insert alerts;
    }	
    
    global void finish(Database.BatchableContext projectClosureBatchContext)
    {   	   	
        system.debug('Batch completed');
    }    
}