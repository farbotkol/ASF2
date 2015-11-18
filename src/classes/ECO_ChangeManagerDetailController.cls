public class ECO_ChangeManagerDetailController {
    
    public ChangeManager__c changeManager {get;set;}
    public ApexPages.StandardController changeManagerStandardController {get;set;}
    public pse__Proj__c project {get; set;}
    String recordTypeId; 
    public String recordTypeName {get; set;}
    public Boolean isApproved {get; set;}
    public String mode {get; set;}
    public list<VendorSite__c> listOfVendorSites {get;set;}
    private list<String> changeManagerSubmittedIds {get; set;}
    private Boolean isSubmitted {get; set;}
    public String projectMsg {get; set;}
    public String taskMsg {get; set;}
    public String keyMemberMsg {get; set;}
    public String customersMsg {get; set;}
    public String projectSynchMessages {get; set;}
    public Boolean needOracleLogin {get; set;}
    private static ECO_ProjectSummaryController projectSummaryController;
    //public list<ECO_ProjectSummaryController.nonSyncItem> 
    public list<ECO_ProjectSummaryController.nonSyncItem> invalidTasks {get;set;}
    public list<ECO_ProjectSummaryController.nonSyncItem> invalidCustomers {get;set;}
   	public list<ECO_ProjectSummaryController.nonSyncItem> invalidKeyMembers {get;set;}
    public String OracleUserName {get; set;}
    public String OraclePassword {get; set;}
    public String authenticationResult {get; set;}
    public Boolean pollMessageQueue {get; set;}
    public Boolean showPollingMsg {get; set;}
    public String pollingMessageQueueMsg {get; set;}
    public String pollingMessageQueueMsgBottom {get; set;}
    public String changeManagerAgreementValidationMessages {get; set;}
    
    //    	public Id recordId {get;set;}
    //		public String recordName {get;set;}
    //		public String validationErrorMessage{get;set;}

    public Integer numSuccessfulSyncs {get; private set;}
    public Integer numFailedAttemptedSyncs {get; private set;}
    public Boolean hasSyncHistory {get; private set;}
    public Boolean hasRequestFailures {get; private set;}
    public List<syncHistoryHelper> syncHistory {get; private set;}
    public List<syncHistoryHelper> requestFailures {get; private set;}


    public ECO_ChangeManagerDetailController(ApexPages.StandardController controller)
    {
        //changeManager = (ChangeManager__c)controller.getRecord();
        //changeManager = getChangeChangeManager();

        invalidTasks = new list<ECO_ProjectSummaryController.nonSyncItem>();
        invalidCustomers = new list<ECO_ProjectSummaryController.nonSyncItem>(); 
        invalidKeyMembers = new list<ECO_ProjectSummaryController.nonSyncItem>();
        changeManagerSubmittedIds = new list<String>();

        mode = ApexPages.currentPage().getParameters().get('Mode');
        if(mode == null)    
            mode = '';
        changeManager = (ChangeManager__c)controller.getRecord();
        changeManagerStandardController = controller;

        needOracleLogin = false;

        if(changeManager.OracleApprovalSyncStatus__c == 'Approved')
        {
            showPollingMsg = true;
            pollMessageQueue = true;
            pollingMessageQueueMsg = 'Checking if project has been processed in <span id="pollingTimer">10</span> seconds...';
            pollingMessageQueueMsgBottom = 'Checking if project has been processed in <span id="pollingTimerBottom">10</span> seconds...';  
        }      
    }    

    public void init()
    {
        //if(changeManager.ApprovalStatus__c == 'Sync Approved')
        //{
        //    project = [select Id, Name, EcoSystemReferenceNumber__c, OracleProjectnumber__c  from pse__Proj__c where Id = :changeManager.Project__c limit 1];            

        //    isSubmitted = true;
        //    synchronizeProject(project.Id);
        //}               

        recordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
        mode = ApexPages.currentPage().getParameters().get('Mode'); 
        numSuccessfulSyncs = 0;
        numFailedAttemptedSyncs = 0;
        hasSyncHistory = false;
        hasRequestFailures = false;

        
        if(recordTypeId != '' && recordTypeId != null && mode != 'View' && changeManager.ApprovalStatus__c != 'Sync Approved')
        {
            mode = 'New';
            upsert changeManager;
        }
        
        if(mode == 'View')
            mode = '';
            
        changeManager = getChangeChangeManager();
        
        if((changeManager.IsExecutionApprovalChange__c || changeManager.IsExternalChange__c || changeManager.IsInternalChange__c) 
                  && (changeManager.OracleApprovalSyncStatus__c == 'Submitted' || changeManager.OracleApprovalSyncStatus__c == 'Failed'))
            needOracleLogin = true;    

        project = [select Id, Name, EcoSystemReferenceNumber__c, OracleProjectnumber__c  from pse__Proj__c where Id = :changeManager.Project__c limit 1];            

        if(changeManager.IsExecutionApprovalChange__c )
            populateInitialBudgetsForExecution(); 
       
        if(changeManager.ApprovalStatus__c != 'Submitted' && changeManager.ApprovalStatus__c != 'Approved')
        {
            changeManager.ProjectApprover__c = ECO_Service_ProjectTeam.getActiveProjectApproverId(changeManager.Project__c); //populateProjectApprover();
            changeManager.ProjectAccountantApprover__c = ECO_Service_ProjectTeam.populateProjectAccountant(changeManager.Project__c);
            changeManager.FinanceApprover__c = ECO_Service_ProjectTeam.populateProjectFinanceLead(changeManager.Project__c);  
            update changeManager;
        }
     
                
        if(changeManager.OutgoingPM__c == null)
            changeManager.OutgoingPM__c = changeManager.ProjectManagerId__c;

        project = [select Id, Name, EcoSystemReferenceNumber__c, OracleProjectnumber__c  from pse__Proj__c where Id = :changeManager.Project__c limit 1];            
        ApexPages.currentPage().getParameters().put('projectId', changeManager.Project__c);
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
            changeManagerSubmittedIds = ECO_Service_ChangeManager.getChangeManagerSubmittedIds(project.Id); 
        }
            
        ECO_ProjectSummaryController projectSummaryController2 = new ECO_ProjectSummaryController();
    
        projectSynchMessages = '';
        projectSynchMessages += projectSummaryController2.projectMsg;
        
        projectSynchMessages += projectSummaryController2.taskMsg;
        invalidTasks = projectSummaryController2.invalidTasks;
        projectSynchMessages += projectSummaryController2.keyMemberMsg;
        invalidKeyMembers = projectSummaryController2.invalidKeyMembers;
 
        projectSynchMessages += projectSummaryController2.customersMsg; 
        invalidCustomers = projectSummaryController2.invalidCustomers; 

        if(changeManager.IntExtContractManagement__c)
            projectSynchMessages += validateAgreements();

        if(projectSynchMessages != '' && projectSynchMessages != null)
            projectSynchMessages = '<ol>' + projectSynchMessages + '</ol>';

        generateSyncHistory();
    }
    


    public PageReference authenticateCredentials()
    {
        String username = ApexPages.currentPage().getParameters().get('username');
        String password = ApexPages.currentPage().getParameters().get('password');
        //authenticationResult = 'SUCCESS';
        //CHUNGDL/DEV12ORACLE
        authenticationResult = ECO_Service_Authentication.TestProxy('https://ecodev.aecom.com/OA_HTML/jsp/fnd/PicDisconnSF.jsp', 'PICAction=CreateSHAKey&UserId=' + username + '&Password=' + password);

        return null;
    }
    
    public void checkIfSyncHasBeenProcessed()
    {
        pollMessageQueue = true;
        IntegrationMessageQueue__c msgQueueResult = ECO_Service_ProjectSync.getMessageQueue(changeManager.LatestMessageQueueId__c);
        if(msgQueueResult == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The message queue record with Id =' + changeManager.LatestMessageQueueId__c + ' could not be found!'));
            pollMessageQueue = false;
            return;
        }

        if(msgQueueResult.Status__c.equalsIgnoreCase('Success') || msgQueueResult.Status__c.equalsIgnoreCase('Error'))
        {
            if(msgQueueResult.Status__c.equalsIgnoreCase('Success')){
                pollingMessageQueueMsg = 'The project was successfully processed!';
            }
            else
            {
                pollingMessageQueueMsg = 'An error occurred while processing the project!<br/>' + msgQueueResult.ErrorMessage__c;
                changeManager.OracleApprovalSyncError__c = msgQueueResult.ErrorMessage__c;
                update changeManager;
            } 
            pollMessageQueue = false;           
        }
        else
        {
            pollingMessageQueueMsg = 'Checking if project sync has been processed in <span id="pollingTimer">10</span> seconds...';
        }
    }    

    public PageReference returnToProjectChanges()
    {
        PageReference pageRef = new PageReference('/apex/ECO_ProjectChangeManager?Id=' + changeManager.Project__c);
        return pageRef;
    }
    
    public PageReference closeAuthenticationWindow()
    {
        PageReference editChangeManager = new PageReference('/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id);        
        editChangeManager.getParameters().put('mode', mode);
        editChangeManager.getParameters().put('retURL', '/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id); 
        return editChangeManager;          
    }

    public PageReference initEdit()
    {
    	PageReference editChangeManager = new PageReference('/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id);        
        //editAgreement.getParameters().put('nooverride', '1');
        editChangeManager.getParameters().put('mode', 'Edit');
        editChangeManager.getParameters().put('retURL', '/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id); 
        return editChangeManager; 
    }
    
    public PageReference returnToChangeManager()
    {
        PageReference editChangeManager = new PageReference('/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id);        
        editChangeManager.getParameters().put('mode', '');
        editChangeManager.getParameters().put('retURL', '/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id); 
        return editChangeManager;   	
    }
    
    //public PageReference synchronizeProject()
    //{
    //    PageReference pageRef = new PageReference('/apex/ECO_ProjectSummary');
    //    pageRef.getParameters().put('projectId', changeManager.Project__c);
    //    return pageRef;
    //}

    public PageReference SubmitForApproval()
    {
        //oProjectReview.Status__c = 'Submitted';
        if(changeManager.IsExecutionApprovalChange__c)
                populateSelectedBudgetsForSynch();

        update changeManager;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
        req1.setComments('Submitted for Approval');
        req1.setObjectId(changeManager.Id);
        Approval.ProcessResult result = Approval.process(req1); 

        if(result.isSuccess())
        {
            return new PageReference('/' + changeManager.Id);
            //return null;
            //return new PageReference('/apex/ECO_ProjectPerformanceReviews?Id=' + oProjectReview.Id + '&RecordTypeId=' + oProjectReview.RecordTypeId + '&ProjectId=' + oProjectReview.Project__c);
        }
        return null;
    }


    public PageReference viewProjectClosureRequest()
    {
    	PageReference closureRequest = new PageReference('/apex/ECO_CloseoutProjectApprovalPhase?Id='+changeManager.Project__c);        
        closureRequest.getParameters().put('nooverride', '1');
        return closureRequest;
    } 

    private String validateAgreements()
    {
        list<Agreement__c> agreements = getChangedAgreements();
        if(agreements == null)
            return '';

        for(Agreement__c agreement:agreements)
        {
            if(agreement.TotalApprovedRevenueLimit__c == null && agreement.RecordType.Name == 'Prime')
                return '<li>Total Approved Revenue Limit needs to be populated for Agreements before you can submit this change for Approval</li>';
        }
        return '';
    }

    public void RefreshChangeManager()
    {
        changeManager = getChangeChangeManager();
    }

    public boolean getShowApprovalProcessList()
    {
        List<ProcessInstance> processInstanceList = [SELECT Id
                                                    FROM ProcessInstance 
                                                    WHERE TargetObjectId = :changeManager.Id];

        if(processInstanceList.isEmpty())
            return false;

        return true;
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
    
    public PageReference createNewChangeManager()
    {
        PageReference returnPR;
        
        recordTypeId = ApexPages.currentPage().getParameters().get('RecordType'); 
        return null;
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
        list<pse__Project_Task__c> tasks = ECO_Service_ChangeManager.getChangedTasks(project.Id, changeManagerSubmittedIds, isSubmitted );
        
        if(tasks.isEmpty())
            return null;    
        return tasks;
    }
    
    public list<ProjectTeamMember__c> getChangedKeyMembers()
    {
        list<ProjectTeamMember__c> teamMembers = ECO_Service_ChangeManager.getChangedKeyMembers(project.Id, changeManagerSubmittedIds, isSubmitted );
                                                                                                
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
        list<Project_Site__c> projectSites = ECO_Service_ChangeManager.getChangedCustomers(project.Id, changeManagerSubmittedIds, isSubmitted );
                                                
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
        list<pse__Proj__c> projects = ECO_Service_ChangeManager.getChangedSafetyHealthEnv(project.Id);
        
        if(projects.isEmpty())
        	return null;

		return projects;     
    }
    
    public list<pse__Proj__c> getChangedResilience()
    {
        list<pse__Proj__c> projects = ECO_Service_ChangeManager.getChangedResilience(project.Id);
        
        if(projects.isEmpty())
        	return null;

		return projects;   
    }   
    
    public list<Risk__c> getChangedRiskManagement()
    {
//    	list<Risk__c> risks = [select Id, Name, CurrentStatus__c, ChangeManagerIsNew__c, RiskOwner__c, RiskCategory__c, LikelihoodofOccurrence__c, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate 
//    							from Risk__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true
//    							and Id not in :projectChangeManagerSubmittedIds];
        list<Risk__c> risks = ECO_Service_ChangeManager.getChangedRiskManagement(project.Id, changeManagerSubmittedIds, isSubmitted );
        
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
 
        list<Agreement__c> agreements = ECO_Service_ChangeManager.getChangedAgreements(project.Id, changeManagerSubmittedIds, isSubmitted );
        
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
		list<Funding__c> fundings = ECO_Service_ChangeManager.getChangedFunding(project.Id, changeManagerSubmittedIds, isSubmitted );
        
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

		list<Packages__c> scopes = ECO_Service_ChangeManager.getChangedScope(project.Id, changeManagerSubmittedIds, isSubmitted );

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

		list<pse__Proj__c> projects = ECO_Service_ChangeManager.getChangedProjectClosure(changeManager.Project__c);
    
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
    
    public class BudgetHeaderWrapper
    {
        public boolean isSelected {get; set;}
        public BudgetHeader__c budgetHeader {get; set;}

        public BudgetHeaderWrapper(boolean selected, BudgetHeader__c budgetHeader)
        {
            this.isSelected = selected;
            this.budgetHeader = budgetHeader;
        }
    }

    public list<BudgetHeaderWrapper> initialBudgetsForExecution {get; set;}

    public void populateInitialBudgetsForExecution()
    {
        initialBudgetsForExecution = new list<BudgetHeaderWrapper>();
        //list<BudgetHeaderWrapper> budgetHeaders = new list<BudgetHeaderWrapper>();

        if(changeManager.BudgetIdsSelectedForExecution__c == null)
            changeManager.BudgetIdsSelectedForExecution__c = '';
            
        for(BudgetHeader__c budget:[select Id, Name, BudgetName__c, TotalCost__c, TotalRevenue__c, LastModifiedById, LastModifiedDate from BudgetHeader__c where Project__c = :changeManager.Project__c])
        {
            if(changeManager.BudgetIdsSelectedForExecution__c == null || changeManager.BudgetIdsSelectedForExecution__c == '')
                initialBudgetsForExecution.add(new BudgetHeaderWrapper(true, budget)); 
            else
            {   
                if(changeManager.BudgetIdsSelectedForExecution__c.contains(budget.Id))
                    initialBudgetsForExecution.add(new BudgetHeaderWrapper(true, budget));                
                else
                    initialBudgetsForExecution.add(new BudgetHeaderWrapper(false, budget));
            }
        }
        //if(!budgetHeaders.isEmpty())
        //    return budgetHeaders;

        //return null;
    }

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
    	//									and ChangeManagerIsChanged__c = true and Id not in :projectChangeManagerFortedIds];
		list<VendorSite__c> subsAndVendors = ECO_Service_ChangeManager.getChangedResources(changeManager.Project__c, changeManagerSubmittedIds, isSubmitted);
		
		if(subsAndVendors.isEmpty())
			return null;
		return subsAndVendors;
    }
    
    public list<Deliverable__c> getChangedDeliverables()
    {
//    	list<Deliverable__c> deliverables = [select Id, Name, ChangeManagerIsNew__c, DeliverableType__c, DeliverableOwner__c, DueDate__c, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate from Deliverable__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true];

		list<Deliverable__c> deliverables = ECO_Service_ChangeManager.getChangedDeliverables(changeManager.Project__c, changeManagerSubmittedIds, isSubmitted);

		if(deliverables.isEmpty())
			return null;
		return deliverables;
    }
    
    public list<pse__Proj__c> getChangedDocumentManagement()
    {
//       list<pse__Proj__c> projects = [select Id, Name, CreatedDate, ChangeManagerDocManageUpdatedBy__c, ChangeManagerDocManageUpdatedDate__c, CreatedById, LastModifiedById, LastModifiedDate from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedDocManage__c = true];

        list<pse__Proj__c> projects = ECO_Service_ChangeManager.getChangedDocumentManagement(changeManager.Project__c);

        if(projects.isEmpty())
        	return null;

		return projects;       	 	
    }
    
    public list<Stakeholder__c> getChangedStakeholders()
    {
        //list<Stakeholder__c> stakeholders = [select Id, Name, ChangeManagerIsNew__c, AECOMContact__c, ContactName__c, ContactPhone__c, Interest__c, Organization__c, StakeholderType__c, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate from Stakeholder__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true];
    	list<Stakeholder__c> stakeholders = ECO_Service_ChangeManager.getChangedStakeholders(changeManager.Project__c, changeManagerSubmittedIds, isSubmitted);
    	
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

    private void populateSelectedBudgetsForSynch()
    {
        //changeManager.BudgetIdsSelectedForExecution__c = '';
        String selectedIds = '';
        for(BudgetHeaderWrapper wrapper:initialBudgetsForExecution)
        {
            if(wrapper.isSelected && selectedIds == '')
                selectedIds = wrapper.budgetHeader.Id;
            else if(wrapper.isSelected && changeManager.BudgetIdsSelectedForExecution__c != '' ) 
                selectedIds += ',' + wrapper.budgetHeader.Id;   
        }
        changeManager.BudgetIdsSelectedForExecution__c = selectedIds;
    }

    public PageReference SynchronizeProject()
    {
        changeManager.LatestMessageQueueId__c = ECO_Service_ProjectSync.createMessageQueueForRequest(changeManager.Project__c, ECO_Service_ProjectSync.JOBNAME_PROJECT_SYNC);
        changeManager.OracleApprovalSyncStatus__c = 'Approved';
        update changeManager;


        if(changeManager.IntExtProjectClosure__c || changeManager.IntExtProjectOnHold__c)
            ECO_Service_ChangeManager.synchronizeProject2(changeManager.LatestMessageQueueId__c, changeManager.Project__c);
        else
            ECO_Service_ChangeManager.synchronizeProject(changeManager.LatestMessageQueueId__c, changeManager.Project__c);

        PageReference changeManagerPageRef = new PageReference('/apex/ECO_ChangeManagerDetail?Id='+changeManager.Id);        
        changeManagerPageRef.getParameters().put('mode', '');
        changeManagerPageRef.setRedirect(true);
        return changeManagerPageRef;  
    }
    
    public PageReference saveChangeManager()
    {
        //String results = ECO_Utils_sObject.saveResultReturnErrors(changeManager);
        try
        {
            if(changeManager.IsExecutionApprovalChange__c)
                populateSelectedBudgetsForSynch();

            System.Debug('BKBKBKBKBKBK before' + changeManager.IntExtRiskManagementComments__c);
            upsert changeManager;
            System.Debug('BKBKBKBKBKBK after' + changeManager.IntExtRiskManagementComments__c);
        }
        catch(Exception e)
        {
            //throw(e);
            //ApexPages.addMessages(new Apex.pageMessage('Risk Register ' + changeManager.IntExtRiskManagementComments__c));
            //mode = 'Edit';
            System.Debug('BKBKBKBKBKBK' + e + changeManager.IntExtRiskManagementComments__c);
            //changeManager = (ChangeManager__c)changeManagerStandardController.getRecord();
            return null;            
        }

   		mode = '';

        if(changeManager.IsPMHandoverChange__c)
            return new PageReference('/' + changeManager.Id);

   		return new PageReference('/' + changeManager.Id);
    }
    
    public PageReference takeProjectSnapshot()
    {
    	ECO_Service_ProjectSnapshots snapshotService = new ECO_Service_ProjectSnapshots(changeManager.Project__c);
    	ProjectSnapshot__c snapshot = snapshotService.getProjectSnapshot();
    	snapshot.ChangeManager__c = changeManager.Id;
        snapshot.Project__c = changeManager.Project__c;

        insert snapshot;
    	
    	return null;
    }

    @TestVisible
    private void generateSyncHistory(){
        Set<String> successStatus = new Set<String>{ ECO_Service_ProjectSync.STATUS_SUCCESS };
        List<IntegrationMessageQueue__c> tmpSyncHistory = ECO_Service_ProjectSync.getProjectSyncHistory(changeManager.Project__c, ECO_Service_ProjectSync.JOBNAME_PROJECT_SYNC, successStatus); 
        syncHistory = new List<syncHistoryHelper>();
        for(IntegrationMessageQueue__c tmpRec : tmpSyncHistory)
        {
            syncHistoryHelper syncHelper = new syncHistoryHelper();
            syncHelper.syncLocalDateTime = tmpRec.LastModifiedDate.format();
            syncHelper.msgQueue = tmpRec;
            syncHistory.add(syncHelper);
        }   
        if(!syncHistory.isEmpty())
        {
            hasSyncHistory = true;
        }

        Set<String> otherStatuses = new Set<String> {ECO_Service_ProjectSync.STATUS_ERROR, ECO_Service_ProjectSync.STATUS_INITIATED, ECO_Service_ProjectSync.STATUS_ATTEMPTED, ECO_Service_ProjectSync.STATUS_SENT };
        List<IntegrationMessageQueue__c> tmpRequestFailures = ECO_Service_ProjectSync.getProjectSyncHistory(changeManager.Project__c, ECO_Service_ProjectSync.JOBNAME_PROJECT_SYNC, otherStatuses); 
        requestFailures = new List<syncHistoryHelper>();
        for(IntegrationMessageQueue__c tmpRec : tmpRequestFailures)
        {
            syncHistoryHelper syncHelper = new syncHistoryHelper();
            syncHelper.syncLocalDateTime = tmpRec.LastModifiedDate.format();
            syncHelper.msgQueue = tmpRec;
            requestFailures.add(syncHelper);
        }   
        if(!requestFailures.isEmpty())
        {
            hasRequestFailures = true;
        }

        numSuccessfulSyncs = syncHistory.size();
        numFailedAttemptedSyncs = requestFailures.size();
    }    

    public class syncHistoryHelper 
    {
        public String syncLocalDateTime {get;set;}
        public IntegrationMessageQueue__c msgQueue {get;set;}
    }  

    public class SinglePageBlockChangeItem
    {
        public String ActionName {get;set;}
        public pse__Proj__c Project {get; set;}
    }

}