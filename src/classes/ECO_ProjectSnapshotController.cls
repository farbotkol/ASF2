public class ECO_ProjectSnapshotController {
	
	public ProjectSnapshot__c projectSnapshot {get; set;}
	
	public class BudgetChangeOrder
	{
		public String BudgetName {get; set;}
		public Decimal TotalRevenue {get; set;}
		public Decimal TotalCost {get; set;}
	}
	
	public class Agreement
	{
		public String RecordType {get; set;}
		public String Amount {get; set;}
		public String ContractType {get; set;}
	}
	
	public class ProjectTask
	{
		public String TaskName {get; set;}
		public String TaskNumber {get; set;}
		public String StartDate {get; set;}
		public String EndDate {get; set;}
		public String ActualStartDate {get; set;}
		public String ActualEndDate {get; set;}
		
		public ProjectTask()
		{
			StartDate = '';
			TaskNumber = '';
			EndDate = '';
			ActualStartDate = '';
			ActualEndDate = '';			
		}
	}
	
	public ECO_ProjectSnapshotController(ApexPages.standardController sc)
    {
        projectSnapshot = (ProjectSnapshot__c)sc.getRecord();  
    }
    
    public class FutureSpendOrg
    {
    	public list<OrgString> orgFutureSpendStrings {get; set;} 

    	
    }
    
    public class OrgString
    {
        public string orgName {get; set;}
    	public decimal month1 {get; set;}
    	public decimal month2 {get; set;}
    	public decimal month3 {get; set;}
    	public decimal month4 {get; set;}
    	public decimal month5 {get; set;}
    	public decimal month6 {get; set;}	
    }
    
    public list<OrgString> getFutureSpendByOrg()
    {
    	list<String> futureSpendOrgs = new list<String>();
    	list<OrgString> primaryFutureSpends = new list<OrgString>();
    	FutureSpendOrg primaryFutureSpend = new FutureSpendOrg();
    	OrgString orgString;
    	
    	if(projectSnapshot.PrimaryFutureSpend__c != null && projectSnapshot.PrimaryFutureSpend__c != '')         
            futureSpendOrgs = projectSnapshot.PrimaryFutureSpend__c.split(';;');
        
        for(String futureSpendOrg:futureSpendOrgs)
        {
        	if(futureSpendOrg != '')
        	{
	        	orgString = new OrgString();
	        	orgString.OrgName = futureSpendOrg.split('::')[0];
	        	orgString.month1 = Decimal.valueOf(futureSpendOrg.split('::')[1]);
	        	orgString.month2 = Decimal.valueOf(futureSpendOrg.split('::')[2]);
	        	orgString.month3 = Decimal.valueOf(futureSpendOrg.split('::')[3]);
	        	orgString.month4 = Decimal.valueOf(futureSpendOrg.split('::')[4]);
	        	orgString.month5 = Decimal.valueOf(futureSpendOrg.split('::')[5]);
	        	orgString.month6 = Decimal.valueOf(futureSpendOrg.split('::')[6]);
        	}
        	
        	//for(String s:futureSpendOrg.split('::'))
        	//{   
        	//	primaryFutureSpend.
        	//	primaryFutureSpend.orgFutureSpendStrings.add(Decimal.valueOf(s));
        	//}
        	primaryFutureSpends.add(orgString);
        }
    	    	
    	return primaryFutureSpends; 
    }
    
    public list<BudgetChangeOrder> getPendingChangeOrders()
    {
    	list<BudgetChangeOrder> changeOrders = new list<BudgetChangeOrder>();
    	list<String> changeOrderStrings = new list<String>();
        
        if(projectSnapshot.ChangeOrdersPending__c != null && projectSnapshot.ChangeOrdersPending__c != '')         
            changeOrderStrings = projectSnapshot.ChangeOrdersPending__c.split('::');
        
        BudgetChangeOrder budgetChangeOrder;
        for(String changeOrderString:changeOrderStrings)
        {
        	if(changeOrderString != '')
        	{
        		budgetChangeOrder = new BudgetChangeOrder();
        		budgetChangeOrder.BudgetName = changeOrderString.split(';;').get(0);
        		budgetChangeOrder.TotalRevenue = Decimal.valueOf(changeOrderString.split(';;').get(1));
        		budgetChangeOrder.TotalCost = Decimal.valueOf(changeOrderString.split(';;').get(2));
        		changeOrders.add(budgetChangeOrder);
        	}
        }
 	    	
    	return changeOrders;
    }
    
    public PageReference ReturnToProject()
    {
    	PageReference pageRef = new PageReference('/' + projectSnapshot.Project__r.Id);
    	return pageRef;
    }
    
    public list<String> getSecondaryOrganizations()
    {
    	list<String> secondaryOrganizations = new list<String>();
    	if(projectSnapshot.SecondaryOrganizations__c != null && projectSnapshot.SecondaryOrganizations__c != '')         
            secondaryOrganizations = projectSnapshot.SecondaryOrganizations__c.split('::');
        return secondaryOrganizations;
    }
    
	public list<Agreement> getAgreements()
    {
    	list<Agreement> agreements = new list<Agreement>();
    	list<String> agreementStrings = new list<String>();
        
        if(projectSnapshot.RelatedAgreements__c != null && projectSnapshot.RelatedAgreements__c != '')         
            agreementStrings = projectSnapshot.RelatedAgreements__c.split('::');
        
        Agreement agreement;
        for(String agreementString:agreementStrings)
        {
        	if(agreementString != '')
        	{
        		agreement = new Agreement();
        		agreement.RecordType = agreementString.split(';;').get(0);
        		agreement.ContractType = agreementString.split(';;').get(1);
        		agreement.Amount = agreementString.split(';;').get(2);
        		agreements.add(agreement);
        	}
        }
 	    	
    	return agreements;
    }    

	public list<ProjectTask> getProjectTasks()
    {
    	list<ProjectTask> tasks = new list<ProjectTask>();
    	list<String> taskStrings = new list<String>();
        
        if(projectSnapshot.ProjectTasks__c != null && projectSnapshot.ProjectTasks__c != '')         
            taskStrings = projectSnapshot.ProjectTasks__c.split('::');
        
        ProjectTask task;
        for(String taskString:taskStrings)
        {
        	if(taskString != '')
        	{
        		task = new ProjectTask();
        		task.TaskName = taskString.split(';;').get(0);
        		if(taskString.split(';;').get(1) != 'null')
        			task.TaskNumber = taskString.split(';;').get(1);
        		if(taskString.split(';;').get(2) != 'null')
        			task.StartDate = taskString.split(';;').get(2);
        		if(taskString.split(';;').get(3) != 'null')
        			task.EndDate = taskString.split(';;').get(3);
        		if(taskString.split(';;').get(4) != 'null')
        			task.ActualStartDate = taskString.split(';;').get(4);
        		if(taskString.split(';;').get(5) != 'null')
        			task.ActualEndDate = taskString.split(';;').get(5);

        		tasks.add(task);
        	}
        }
 	    	
    	return tasks;
    }    

    public list<BudgetChangeOrder> getDraftChangeOrders()
    {
    	list<BudgetChangeOrder> changeOrders = new list<BudgetChangeOrder>();
    	list<String> changeOrderStrings = new list<String>();
        
        if(projectSnapshot.ChangeOrdersDraft__c != null && projectSnapshot.ChangeOrdersDraft__c != '')         
            changeOrderStrings = projectSnapshot.ChangeOrdersDraft__c.split('::');
        
        BudgetChangeOrder budgetChangeOrder;
        for(String changeOrderString:changeOrderStrings)
        {
        	budgetChangeOrder = new BudgetChangeOrder();
        	budgetChangeOrder.BudgetName = changeOrderString.split(';;').get(0);
        	budgetChangeOrder.TotalRevenue = Decimal.valueOf(changeOrderString.split(';;').get(1));
        	budgetChangeOrder.TotalCost = Decimal.valueOf(changeOrderString.split(';;').get(2));
        	changeOrders.add(budgetChangeOrder);
        }
 	    	
    	return changeOrders;
    }    

}