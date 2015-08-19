global class ECO_ProjectClosureRecommendationBatch implements Database.Batchable<sObject>{

	private String query = 'select Id, Name, OracleProjectNumber__c, pse__Project_Manager__c, pse__Project_Manager__r.Name, CMProjectClosureIsApproved__c, Project_Manager_User__c from pse__Proj__c where pse__Stage__c != \'Closed\' and pse__End_Date__c <= TODAY';
	
    global Database.QueryLocator start(Database.BatchableContext projectClosureBatchContext)
    {   
    	System.Debug(LoggingLevel.Info, 'Query ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext projectClosureBatchContext, List<pse__Proj__c> projects)
    {  	
    	map<Id, Boolean> projectFinanceMap = new map<Id, Boolean>();
    	map<Id, pse__Proj__c> projectMap = new map<Id, pse__Proj__c>();
    	map<Id, Decimal> projectAgreementTotalsMap = new map<Id, Decimal>();
    	map<Id, Decimal> projectBillingTotalsMap = new map<Id, Decimal>();
    	map<Id, Decimal> projectUnPaidTotalsMap = new map<Id, Decimal>();
    	
    	for(pse__Proj__c project:projects)
    	{
    		projectFinanceMap.put(project.Id, false);	
    		projectMap.put(project.Id, project);
    		projectBillingTotalsMap.put(project.Id, 0);
    		projectUnPaidTotalsMap.put(project.Id, 0);
    		projectAgreementTotalsMap.put(project.Id, 0);	
    	}
    	
    	Date asOfDate = Date.today().addDays(-90);
		//recent revenue    
   		for(AggregateResult ar:[select ProjectNumber__c Project from Revenue__c where ProjectNumber__c in :projects and GLDate__c > :asOfDate group by ProjectNumber__c])
   			projectFinanceMap.put((Id)ar.get('Project'), true);
   		
   		//recent billings	
   		for(AggregateResult ar:[select ProjectNumber__c Project, sum(InvoiceAmount__c) total  from Billing__c where ProjectNumber__c in :projects and InvoiceDate__c > :asOfDate group by ProjectNumber__c])
   		{
   			projectFinanceMap.put((Id)ar.get('Project'), true);	
   		}	
   		
   		//billings total
   		for(AggregateResult ar:[select ProjectNumber__c Project, sum(InvoiceAmount__c) total, sum(BalanceDue__c) totalUnpaid  from Billing__c where ProjectNumber__c in :projects group by ProjectNumber__c])
   		{
   			if(ar.get('total') != null)
   				projectBillingTotalsMap.put((Id)ar.get('Project'), (Decimal)ar.get('total'));
   			
   			if(ar.get('totalUnpaid') != null)
   				projectUnPaidTotalsMap.put((Id)ar.get('Project'), (Decimal)ar.get('totalUnpaid'));
   		}   		
   		
   		//recent costs	
   		for(AggregateResult ar:[select ExpenditureItem__r.Project__c Project from CostDistLine__c where ExpenditureItem__r.Project__c in :projects and GLDate__c > :asOfDate group by ExpenditureItem__r.Project__c])
   			projectFinanceMap.put((Id)ar.get('Project'), true);	
   			
   		map<Id, list<Id>> projectAgreementIdsMap = new map<Id, list<Id>>();
   		set<Id> agreementIds = new set<Id>();
   		for(ProjectAgreement__c projectAgreement:[select Id, Project__c, Agreement__c from ProjectAgreement__c where Project__c in :projects])
   		{
   			if(projectAgreementIdsMap.get(projectAgreement.Project__c) == null)
   				projectAgreementIdsMap.put(projectAgreement.Project__c, new list<Id>());
   			projectAgreementIdsMap.get(projectAgreement.Project__c).add(projectAgreement.Agreement__c);
   			agreementIds.add(projectAgreement.Agreement__c);
   		}
   		   			   		
		Decimal projectTotal;
   		map<Id, Agreement__c> agreementMap = new map<Id, Agreement__c>([select Id, Amount__c from Agreement__c where Id in :agreementIds]);		
 		for(pse__Proj__c project:projectMap.values())
 		{
 			projectTotal = projectAgreementTotalsMap.get(project.Id);
 			if(projectAgreementIdsMap.get(project.Id) != null)
 			{
 				for(Id agreementId:projectAgreementIdsMap.get(project.Id))
 				{
 					projectTotal += agreementMap.get(agreementId).Amount__c; 
 				}
 				projectAgreementTotalsMap.put(project.Id, projectTotal);
 			}
 		}
 		  		   			   			
		Id alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);
		list<PortalMessage__c> alerts = new list<PortalMessage__c>();
		for(pse__Proj__c project:projectMap.values())
		{
			System.Debug('----Brent-----' + projectFinanceMap.get(project.Id));
			System.Debug('----Brent-----' + projectAgreementTotalsMap.get(project.Id));		
			System.Debug('----Brent-----' + projectBillingTotalsMap.get(project.Id));			
				
			if((!projectFinanceMap.get(project.Id)) && (projectAgreementTotalsMap.get(project.Id) == projectBillingTotalsMap.get(project.Id) && projectUnPaidTotalsMap.get(project.Id)  <= 0))
			{
   				alerts.add(new PortalMessage__c(RecordTypeId = alertRecordTypeId
   											, User__c = project.Project_Manager_User__c
   											, StartDate__c = Date.today()
   											, EndDate__c = Date.today().addDays(1)
   											, LongDescriptionMaxLength__c = 'Please considering closing this project.'
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