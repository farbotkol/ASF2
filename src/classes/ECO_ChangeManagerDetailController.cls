public class ECO_ChangeManagerDetailController {
    
    public ChangeManager__c changeManager {get;set;}
    public pse__Proj__c project {get; set;}
    String recordTypeId; 
    public String recordTypeName {get; set;}
    public Boolean isApproved {get; set;}
    public String mode {get; set;}
    public list<VendorSite__c> listOfVendorSites {get;set;}
    private list<String> changeManagerSubmittedIds {get; set;}
    private Boolean isSubmitted {get; set;}
    
    public class SinglePageBlockChangeItem
	{
		public String ActionName {get;set;}
		public pse__Proj__c Project {get; set;}
	}
    
    public ECO_ChangeManagerDetailController(ApexPages.StandardController controller)
    {
    	mode = ApexPages.currentPage().getParameters().get('Mode');
    	if(mode == null)	
    		mode = '';
        changeManager = (ChangeManager__c)controller.getRecord();
        //
    }
    
    public PageReference initEdit()
    {
    	PageReference editAgreement = new PageReference('/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id);        
        //editAgreement.getParameters().put('nooverride', '1');
        editAgreement.getParameters().put('mode', 'Edit');
        editAgreement.getParameters().put('retURL', '/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id); 
        return editAgreement; 
    }
    
    public PageReference returnToChangeManager()
    {
        mode = '';
        return null;    	
    }
    
    public PageReference viewProjectClosureRequest()
    {
    	PageReference closureRequest = new PageReference('/apex/ECO_CloseoutProjectApprovalPhase?Id='+changeManager.Project__c);        
        closureRequest.getParameters().put('nooverride', '1');
        return closureRequest;
    }
    
    public void init()
    {
    	recordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
        mode = ApexPages.currentPage().getParameters().get('Mode'); 
        
        if(recordTypeId != '' && recordTypeId != null && mode != 'View')
        {
        	mode = 'New';
        	upsert changeManager;
        }
        
        if(mode == 'View')
        	mode = '';
    		
        changeManager = getChangeChangeManager();
               
    	if(changeManager.ProjectApprover__c == null)
    	{
    		changeManager.ProjectApprover__c = populateProjectApprover();
    		update changeManager;
    	}
 
     	if(changeManager.ProjectAccountantApprover__c == null)
     	{
    		changeManager.ProjectAccountantApprover__c = populateProjectAccountant();
    		update changeManager;
     	}
    		
    	if(changeManager.FinanceApprover__c == null)
    	{
    		changeManager.FinanceApprover__c = populateProjectFinanceLead();  
    		update changeManager;
    	}  		   		       

        project = [select Id, Name, EcoSystemReferenceNumber__c, OracleProjectnumber__c  from pse__Proj__c where Id = :changeManager.Project__c limit 1];            
        listOfVendorSites = [select Id, Name, AccountName__c, Site__r.Account__c from VendorSite__c where Project__c = :changeManager.Project__c];           
    	if(changeManager.ApprovalStatus__c == 'Submitted')
    	{
    		isSubmitted = true;
    		if(changeManager.SubmittedIdsForApproval__c != null)
    			changeManagerSubmittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
    		else
    			changeManagerSubmittedIds = new list<String>();
    	}	
    	else
    	{
    		isSubmitted = false;
    		changeManagerSubmittedIds = ECO_ChangeManager_Service.getChangeManagerSubmittedIds(project.Id);	
    	}
    }    
    
    private ChangeManager__c getChangeChangeManager()
    {
    	ECO_Utils_Meta.SelectAll soUtil = new ECO_Utils_Meta.SelectAll();
		soUtil.GetFields('ChangeManager__c');
		String queryString = soUtil.SOQL;
		queryString = querystring.replace('FROM ChangeManager__c', ',project__r.Name, project__r.OracleProjectNumber__c, RecordType.Id, Project__r.ChangeManagerClientsRequirements__c, Project__r.ChangeManagerAECOMRequirements__c,  RecordType.Name FROM ChangeManager__c');
		queryString += ' WHERE Id = \''+ changeManager.Id +'\'';
		
		list<ChangeManager__c> changeManagers = Database.query(queryString);
		changeManager = changeManagers[0];
    	
    	return changeManager;
    }
    
    private Id populateProjectApprover()
    {
    	list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'Project Approver' and Project__c = :changeManager.Project__c and Active__c = true];
		if(!teamMembers.isEmpty())
		{
			return teamMembers[0].Contact__r.pse__Salesforce_User__c;
		}
    	return null;
    }
    
    private Id populateProjectAccountant()
    {
    	list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'Project Accountant' and Project__c = :changeManager.Project__c and Active__c = true];
		if(!teamMembers.isEmpty())
		{
			return teamMembers[0].Contact__r.pse__Salesforce_User__c;
		}
    	return null;
    }
    
    private Id populateProjectFinanceLead()
    {
    	list<ProjectTeamMember__c> teamMembers = [select Id, User__c, Contact__r.pse__Salesforce_User__c from ProjectTeamMember__c where ProjectRole__r.Name = 'Finance Lead' and Project__c = :changeManager.Project__c and Active__c = true];
		if(!teamMembers.isEmpty())
		{
			return teamMembers[0].Contact__r.pse__Salesforce_User__c;
		}
    	return null;
    }
    
    public PageReference createNewChangeManager()
    {
        PageReference returnPR;
        
        recordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
        return null;
    }
    
    public ECO_ChangeManagerDetailController()
    {
        
    }
    
    public list<pse__Proj__c> getChangedProject()
    {
        list<pse__Proj__c> projects = [select Id, Name, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate from pse__Proj__c 
                                        where Id = :project.Id 
                                        and ChangeManagerIsChanged__c = true];
        
        if(projects.isEmpty())
            return null;
        return projects;
    }
    
    public list<pse__Project_Task__c> getChangedTasks()
    {
        list<pse__Project_Task__c> tasks = ECO_ChangeManager_Service.getChangedTasks(project.Id, changeManagerSubmittedIds, isSubmitted );
        
        if(tasks.isEmpty())
            return null;    
        return tasks;
    }
    
    public list<ProjectTeamMember__c> getChangedKeyMembers()
    {
        list<ProjectTeamMember__c> teamMembers = ECO_ChangeManager_Service.getChangedKeyMembers(project.Id, changeManagerSubmittedIds, isSubmitted );
                                                                                                
        if(teamMembers.isEmpty())                     
            return null;
        return teamMembers;
    }   
    
    public list<Project_Site__c> getChangedCustomers()
    {
//        list<Project_Site__c> projectSites = [select Id, Name, ChangeManagerIsNew__c, Account_Name__c, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate 
//                                              from Project_Site__c where project__c = :project.Id
//                                              and ChangeManagerIsChanged__c = true and ChangeManagerApprovedForSynch__c = false
//                                              and Id not in :projectChangeManagerSubmittedIds];
        list<Project_Site__c> projectSites = ECO_ChangeManager_Service.getChangedCustomers(project.Id, changeManagerSubmittedIds, isSubmitted );
                                                
        if(projectSites.isEmpty())                        
            return null;
        return projectSites;

    }   
    
    public list<ECO_Service_ProjectSync.OR_Classification> getChangedClassifications()
    {
    	ECO_Utils_Meta.SelectAll soUtil = new ECO_Utils_Meta.SelectAll();
		soUtil.GetFields('pse__Proj__c');
		String queryString = soUtil.SOQL;
		//queryString = querystring.replace('FROM ChangeManager__c', ',project__r.Name, project__r.OracleProjectNumber__c, RecordType.Id, Project__r.ChangeManagerClientsRequirements__c, Project__r.ChangeManagerAECOMRequirements__c,  RecordType.Name FROM ChangeManager__c');
		queryString += ' WHERE Id = \''+ changeManager.Project__c +'\'';
		queryString += ' and ChangeManagerIsChangedClass__c = true';
		list<pse__Proj__c> projects = Database.query(queryString);
    	
        //list<pse__Proj__c> projects = [select Id, Name, OracleProjectnumber__c, OracleProjectId__c, ContractTypes__c,
        //                               clACLOfficeLocation__c, clAECOMBusinessLineSegment__c,
        //                                CreatedDate, CreatedById, LastModifiedById, LastModifiedDate from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedClass__c = true];
        
        if(projects.isEmpty())
        	return null;

		return ECO_Service_ProjectSync.getOracleClassificationCollection(projects[0], ECO_Utils_sObject.getFieldSetMembers('ECO_OracleClassificationFields', 'pse__Proj__c'));
    }  
        
    public list<pse__Proj__c> getChangedSafetyHealthEnv()
    {        
        list<pse__Proj__c> projects = ECO_ChangeManager_Service.getChangedSafetyHealthEnv(project.Id);
        
        if(projects.isEmpty())
        	return null;

		return projects;     
    }
    
    public list<pse__Proj__c> getChangedResilience()
    {
        list<pse__Proj__c> projects = ECO_ChangeManager_Service.getChangedResilience(project.Id);
        
        if(projects.isEmpty())
        	return null;

		return projects;   
    }   
    
    public list<Risk__c> getChangedRiskManagement()
    {
//    	list<Risk__c> risks = [select Id, Name, CurrentStatus__c, ChangeManagerIsNew__c, RiskOwner__c, RiskCategory__c, LikelihoodofOccurrence__c, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate 
//    							from Risk__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true
//    							and Id not in :projectChangeManagerSubmittedIds];
        list<Risk__c> risks = ECO_ChangeManager_Service.getChangedRiskManagement(project.Id, changeManagerSubmittedIds, isSubmitted );
        
		if(risks.isEmpty())
			return null;
		return risks;
    }
    
    public list<Agreement__c> getChangedAgreements()
    {
/*        list<Agreement__c> agreements = [select Id, Name, ChangeManagerIsNew__c, TotalContractValue__c, RecordType.Name, AgreementType__c, LastModifiedById, LastModifiedDate, CreatedDate, CreatedById 
                                            from Agreement__c where project__c = :project.Id
                                                    and ChangeManagerIsChanged__c = true
                                                    and Id not in :projectChangeManagerSubmittedIds];*/
 
        list<Agreement__c> agreements = ECO_ChangeManager_Service.getChangedAgreements(project.Id, changeManagerSubmittedIds, isSubmitted );
        
        if(agreements.isEmpty())
            return null;
        return agreements;   
    }
    
    
    
    public list<Funding__c> getChangedContractManagementFunding()
    {
        /*list<Funding__c> fundings = [select Id, Name, ChangeManagerIsNew__c, Agreement__r.Name, DateAllocatedDate__c, AllocatedAmount__c, LastModifiedById, LastModifiedDate,
        							CreatedDate, CreatedById
                                            from Funding__c where project__c = :project.Id
                                                    and ChangeManagerIsChanged__c = true
                                                    and Id not in :projectChangeManagerSubmittedIds];*/
		list<Funding__c> fundings = ECO_ChangeManager_Service.getChangedFunding(project.Id, changeManagerSubmittedIds, isSubmitted );
        
        if(fundings.isEmpty())
            return null;
        return fundings;        
    }
    
    public list<Packages__c> getChangedScope()
    {
        /*list<Packages__c> scopes = [select Id, Name, Status__c, ChangeManagerIsNew__c, LastModifiedById, LastModifiedDate, CreatedDate, CreatedById
                                            from Packages__c where Scope__c = :project.Id
                                                    and ChangeManagerIsChanged__c = true
                                                    and Id not in :projectChangeManagerSubmittedIds];*/

		list<Packages__c> scopes = ECO_ChangeManager_Service.getChangedScope(project.Id, changeManagerSubmittedIds, isSubmitted );

        if(scopes.isEmpty())
            return null;
        return scopes;
    }
                
    public BudgetHeader__c getChangedBudget()
    {
        list<BudgetHeader__c> budgets = [select Id, Name, BudgetName__c, TotalContingencyAmount__c, TotalCost__c, TotalRevenue__c, Status__c, Project__c, CreatedDate, CreatedById,
                                        LastModifiedDate, LastModifiedById from BudgetHeader__c where Id = :changeManager.BudgetHeader__c];
        if(budgets.isEmpty())
            return null;
        return budgets[0];
    }   
    
    public list<pse__Proj__c> getChangedProjectClosure()
    {
    	//list<pse__Proj__c> projects = [select Id, Name, CMProjectClosureIsChanged__c, RequestedProjectStatus__c, ClosureDate__c, ScheduledOnHoldDate__c, ProjectClosureNotes__c, OnHoldReason__c, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate, ChangeManagerProjectStatusUpdatedBy__c, ChangeManagerProjectStatusUpdatedDate__c from pse__Proj__c where Id = :project.Id];

		list<pse__Proj__c> projects = ECO_ChangeManager_Service.getChangedProjectClosure(changeManager.Project__c);
    
    	if(projects.isEmpty())
    		return null;
    	return projects;
    }
    
    /*public pse__Proj__c getChangedProjectOnHold()
    {
    	list<pse__Proj__c> projects = [select Id, Name, CMProjectClosureIsChanged__c, RequestedProjectStatus__c, ClosureDate__c, ScheduledOnHoldDate__c, ProjectClosureNotes__c, OnHoldReason__c, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate from pse__Proj__c where Id = :project.Id and CMProjectOnHoldIsChanged__c = true];
    
    	if(projects.size() == 0)
    		return null;
    	return projects[0];
    }    */
    
    public Decimal getChangedBudgetContingency()
    {
        list<BudgetHeader__c> budgets = [select Id, TotalContingencyAmount__c, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate from BudgetHeader__c where Id = :changeManager.BudgetHeader__c];
        if(budgets.isEmpty())
            return null;
        return budgets[0].TotalContingencyAmount__c;            
    }
    
    public list<VendorSite__c> getChangedResources()
    {
    	//list<VendorSite__c> subsAndVendors = [select Id, Name, ChangeManagerIsNew__c, AccountName__c, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate 
    	//									from VendorSite__c where Project__c = :changeManager.Project__c 
    	//									and ChangeManagerIsChanged__c = true and Id not in :projectChangeManagerSubmittedIds];
		list<VendorSite__c> subsAndVendors = ECO_ChangeManager_Service.getChangedResources(changeManager.Project__c, changeManagerSubmittedIds, isSubmitted);
		
		if(subsAndVendors.isEmpty())
			return null;
		return subsAndVendors;
    }
    
    public list<Deliverable__c> getChangedDeliverables()
    {
//    	list<Deliverable__c> deliverables = [select Id, Name, ChangeManagerIsNew__c, DeliverableType__c, DeliverableOwner__c, DueDate__c, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate from Deliverable__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true];

		list<Deliverable__c> deliverables = ECO_ChangeManager_Service.getChangedDeliverables(changeManager.Project__c, changeManagerSubmittedIds, isSubmitted);

		if(deliverables.isEmpty())
			return null;
		return deliverables;
    }
    
    public list<pse__Proj__c> getChangedDocumentManagement()
    {
//       list<pse__Proj__c> projects = [select Id, Name, CreatedDate, ChangeManagerDocManageUpdatedBy__c, ChangeManagerDocManageUpdatedDate__c, CreatedById, LastModifiedById, LastModifiedDate from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedDocManage__c = true];

        list<pse__Proj__c> projects = ECO_ChangeManager_Service.getChangedDocumentManagement(changeManager.Project__c);

        if(projects.isEmpty())
        	return null;

		return projects;       	 	
    }
    
    public list<Stakeholder__c> getChangedStakeholders()
    {
        //list<Stakeholder__c> stakeholders = [select Id, Name, ChangeManagerIsNew__c, AECOMContact__c, ContactName__c, ContactPhone__c, Interest__c, Organization__c, StakeholderType__c, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate from Stakeholder__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true];
    	list<Stakeholder__c> stakeholders = ECO_ChangeManager_Service.getChangedStakeholders(changeManager.Project__c, changeManagerSubmittedIds, isSubmitted);
    	
    	if(stakeholders.isEmpty())
    		return null;
    	return stakeholders;
    }
    
    
    public PageReference returnToProject()
    {
        return new PageReference('/' + changeManager.Project__c);
    }
    
    public list<SelectOption> getYesNoOptions()
    {
        list<SelectOption> options = new list<SelectOption>();
        options.add(new SelectOption('Yes', 'Yes'));
        options.add(new SelectOption('No', 'No'));
    
        return options;
    }
        
    public PageReference editChangeManager()
    {
        mode = 'Edit';
        return null; 
    }
    
    public PageReference saveChangeManager()
    {
        update changeManager;

   		mode = '';
   		return null;
    }
    
    public PageReference takeProjectSnapshot()
    {
    	ECO_Service_ProjectSnapshots snapshotService = new ECO_Service_ProjectSnapshots(changeManager.Project__c);
    	ProjectSnapshot__c snapshot = snapshotService.getProjectSnapshot();
    	snapshot.ChangeManager__c = changeManager.Id;
    	
    	return null;
    }
}