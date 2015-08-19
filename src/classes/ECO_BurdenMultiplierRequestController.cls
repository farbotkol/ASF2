public class ECO_BurdenMultiplierRequestController {

	public ProjectBurdenMultiplierRequest__c request {get; set;}
	public pse__Proj__c project {get; set;}

    public ECO_BurdenMultiplierRequestController(ApexPages.StandardController controller)
    {
        request = (ProjectBurdenMultiplierRequest__c)controller.getRecord();
        project = [select Id, Name
        					, PrimaryEndClient__r.AccountName__c
        				    , DefaultTopTaskCustomer__c 
        				    , pse__Stage__c 
        				    , OracleProjectNumber__c 
        				    , EstimatedContractValue__c
        				    , AECOMLaborCosts__c
        				    , EstimatedStartDate__c
        				    , pse__Start_Date__c
        				    , pse__End_Date__c
        				    , EstAwardDate__c
        				    , ProposalDue__c
        				    , CapitalValue__c
        				    , SubsCost__c
        				    , ODCsCost__c
        				    , RFPIssueDate__c
        				    , NetServicesRevenue__c
        				    , ProjectDescription__c 
        				    , pse__Project_Manager__r.pse__Salesforce_User__c
        				    , EcoSystemReferenceNumber__c
        				    from pse__Proj__c where Id = :request.Project__c];
        
        //
    }
    
    public void init()
    {   	
    	if(request.ProjectManager__c == null)
    		request.ProjectManager__c = project.pse__Project_Manager__r.pse__Salesforce_User__c;
    	if(request.ProjectApprover__c == null)
    		request.ProjectApprover__c = ECO_Service_ProjectTeam.getActiveProjectApproverId(project.Id);
    	if(request.FinanceLead__c == null)
    		request.FinanceLead__c = ECO_Service_ProjectTeam.getActiveProjectFinanceLead(project.Id);	   	
    }
    
	public list<SelectOption> getYesNoOptions()
	{
	    list<SelectOption> options = new list<SelectOption>();
	    options.add(new SelectOption('Yes', 'Yes'));
	    options.add(new SelectOption('No', 'No'));
	
	    return options;
	}    
	
	public PageReference cancel()
	{
		return new PageReference('/' + request.Project__c);
	}
}