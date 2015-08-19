global class ECO_ProjectClosureBatch implements Database.Batchable<sObject>{

	private String query = 'select Id, Name, OracleProjectNumber__c, pse__Project_Manager__r.Name, CMProjectClosureIsApproved__c from pse__Proj__c where CMProjectClosureIsApproved__c = true and ClosureDate__c <= TODAY';
	
    global Database.QueryLocator start(Database.BatchableContext projectClosureBatchContext)
    {   
    	System.Debug(LoggingLevel.Info, 'Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext projectClosureBatchContext, List<pse__Proj__c> projects)
    {  	
		list<Messaging.SingleEmailMessage> emailList = new list <Messaging.SingleEmailMessage>();
		for(pse__Proj__c project:projects)  
		{
			String textBody = '';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
            email.setToAddresses(new String[] {ECO_Constants.ProjectCloseoutGenericITEmail});   
            email.setSubject('ACTION: Request to Archive Network Project Folder for ' + project.OracleProjectNumber__c);
            textBody +='The subject project is closed.  Please archive the network project folder and send notification to the Project Manager when completed.\n\n';
            textBody +='ProjectNumber:    ' + project.OracleProjectNumber__c + '\n' ;
            textBody +='Project Name:     ' + project.Name + '\n';
            textBody +='Project Manager:  ' + project.pse__Project_Manager__r.Name;          
            email.setPlainTextBody(textBody);                         
            email.setSaveAsActivity(false);
            emailList.add(email);
		} 	
			
		EcoDisableProjectTeamClosureEmail__c settings = EcoDisableProjectTeamClosureEmail__c.getOrgDefaults();
		if(emailList.size() > 0 && settings.EcoDisableProjectTeamClosureEmail__c == false)
		{
			//Messaging.sendEmail(emailList);					
		}
    }	
    
    global void finish(Database.BatchableContext projectClosureBatchContext)
    {   	   	
        system.debug('Batch completed');
    }    
}