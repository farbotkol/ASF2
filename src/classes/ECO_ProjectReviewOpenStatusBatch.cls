global class ECO_ProjectReviewOpenStatusBatch implements Database.Batchable<sObject>{

	private String query = 'select Id, Name, pse__Project_Manager__r.User__c, Project_Manager_User__c from pse__Proj__c where isClosed__c = false';
	
    global Database.QueryLocator start(Database.BatchableContext projectHealthCheckBatchContext)
    {   
    	System.Debug(LoggingLevel.Info, 'Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext projectHealthCheckBatchContext, List<pse__Proj__c> projects)
    {  	
    	System.Debug(LoggingLevel.Info, 'Projects Results Size' + projects.size());
    	map<Id, pse__Proj__c> projectMap = new map<Id, pse__Proj__c>();
    	for(pse__Proj__c project:projects)
    	{
    		projectMap.put(project.Id, project);	
    	}
    	
    	list<ProjectReview__c> openProjectReviews = [select Id, IsOpen__c, Project__c from ProjectReview__c where ReviewFrequency__c = :ECO_Constants.ProjectReview_BatchReviewFrequency and 
    													IsOpen__c = true and Project__c in :projects];
    	
    	set<Id> projectsWithOpenReview = new set<Id>();
    	for(ProjectReview__c review:openProjectReviews)
    	{
    		projectsWithOpenReview.add(review.Project__c);
    	}
    	
   		list<PortalMessage__c> alerts = new list<PortalMessage__c>();

		Id alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);

		pse__Proj__c alertProject;
		for(Id projectId:projectsWithOpenReview)
		{
			alertProject = projectMap.get(projectId);
   			// TAL - To Author:  Please use the leading comma pattern (like I did below)... it hurts way less to manipulate in the future
   			alerts.add(new PortalMessage__c(RecordTypeId = alertRecordTypeId
   											, User__c = alertProject.Project_Manager_User__c 
   											, StartDate__c = Date.today()
   											, EndDate__c = Date.today().addDays(7)
   											, LongDescriptionMaxLength__c = ECO_Constants.PortalMessage_OpenProjectReviewMessage
   											, Subject__c = alertProject.Name
   											, LinkToRecord__c = '/' + alertProject.Id
   											));     				
   		}													

		// TAL - Always scope conditionals!!
		// Use IsEmpty instead of size() > 0 (faster, especially in batch)
		if(!alerts.isEmpty()) {
			insert alerts;
		}
    }	
    
    global void finish(Database.BatchableContext projectHealthCheckBatchContext)
    {   	
    	
        system.debug('Batch completed');
    }    
}