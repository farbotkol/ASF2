global class ECO_ProjectCommunicationPlanBatch implements Database.Batchable<sObject>{

	private String query = 'select Id, Name, TaskLastGenerated__c, Audience__c, Activity__c, How__c, Project__c from CommunicationPlan__c where NewTaskNeedsToBeCreated__c = true and ProjectIsActive__c = true';
	
    global Database.QueryLocator start(Database.BatchableContext projectHealthCheckBatchContext)
    {   
    	System.Debug(LoggingLevel.Info, 'Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext projectHealthCheckBatchContext, List<CommunicationPlan__c> communicationPlans)
    {  	
    	list<Task> tasks = new list<Task>();
		for(CommunicationPlan__c plan:communicationPlans)  
		{
			Task newTask = new Task(Description = 'Audience: ' + plan.Audience__c + '\n' + 'How: ' + plan.How__c,
                                    Priority = 'Normal', 
                                    Subject = 'Comm Plan - ' + plan.Activity__c, 
                                    IsReminderSet = false, 
                                    ReminderDateTime = System.now()+1, 
                                    WhatId = plan.Project__c    );             
             tasks.add(newTask);
             plan.TaskLastGenerated__c = DateTime.Now();		
		} 			
		insert tasks;
		update communicationPlans;
    }	
    
    global void finish(Database.BatchableContext projectHealthCheckBatchContext)
    {   	
    	
        system.debug('Batch completed');
    }    
}