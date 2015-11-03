public class ECO_Service_ChangeManager {

	public static String CHANGE_MANAGER_INTERNAL = 'Internal Change';
	public static String CHANGE_MANAGER_EXTERNAL = 'External Change';

    public static list<ChangeManager__c> getChangeManagers(List<Id> changeManagerIds)
    {
        ECO_Utils_Meta.SelectAll soUtil = new ECO_Utils_Meta.SelectAll();
        soUtil.GetFields('ChangeManager__c');
        String queryString = soUtil.SOQL;
        queryString = querystring.replace('FROM ChangeManager__c', ',project__r.Name, project__r.OracleProjectNumber__c, RecordType.Id, Project__r.ChangeManagerClientsRequirements__c, Project__r.ChangeManagerAECOMRequirements__c,  RecordType.Name FROM ChangeManager__c');
        queryString += ' WHERE Id in :changeManagerIds';
        
        list<ChangeManager__c> changeManagers = Database.query(queryString);
        return changeManagers;
    }
	
	public static Id createNewInternalChangeManagerFromBudget(Id budgetHeaderId, Id projectId)
	{
		Id recordTypeId = [select Id, Name from RecordType where name = :CHANGE_MANAGER_INTERNAL limit 1].Id;
		ChangeManager__c changeManager = new ChangeManager__c(Project__c = projectId,
															  BudgetHeader__c = budgetHeaderId,
															  IntExtBudget__c = true,
															  RecordTypeId = recordTypeId);
															  
		insert changeManager;
		
		return changeManager.Id;	
	}

	public static Id createNewExternalChangeManagerFromBudget(Id budgetHeaderId, Id projectId)
	{
		Id recordTypeId = [select Id, Name from RecordType where name = :CHANGE_MANAGER_EXTERNAL limit 1].Id;
		
		ChangeManager__c changeManager = new ChangeManager__c(Project__c = projectId,
															  BudgetHeader__c = budgetHeaderId,
															  IntExtBudget__c = true,
															  RecordTypeId = recordTypeId);
															  
		insert changeManager;
					
		return changeManager.Id;
	}

    public static list<String> getChangeManagerSubmittedIds(Id projectId)
    {
    	String submittedChangeManagerIds = '';
    	
    	for(ChangeManager__c changeManager:[select Id, SubmittedIdsForApproval__c from ChangeManager__c 
    	                                     where Project__c = :projectId and ApprovalStatus__c = 'Submitted'])
    	{
    		if(submittedChangeManagerIds != '')
    			submittedChangeManagerIds += ',' + changeManager.SubmittedIdsForApproval__c;
    		else
    			submittedChangeManagerIds = changeManager.SubmittedIdsForApproval__c;	   		
    	}   	
    	
    	if(submittedChangeManagerIds != null )
    		return submittedChangeManagerIds.split(',');
    	return new list<String>();   		
    }

	public static boolean hasUnsubmittedProjectChanges(Id projectId)
	{
		list<String> submittedIds = getChangeManagerSubmittedIds(projectId);
		if(isChangedTasks(projectId, submittedIds) || 
		   isChangedKeyMembers(projectId, submittedIds) ||
		   isChangedCustomers(projectId, submittedIds) ||
		   isChangedClassifications(projectId))
		    return true;
		return false;
	}

	public static boolean isChangedTasks(Id projectId, list<String> submittedIds)
	{
        if(getChangedTasks(projectId, submittedIds, false).isEmpty())
            return false;    
        return true;		
	}
	
	public static list<pse__Project_Task__c> getChangedTasks(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
	{ 		
        String query = 'select Id, Name, pse__Task_Number__c, ProjectTaskNumber__c, ';
        query += ' ChangeManagerIsNew__c, LastModifiedById, LastModifiedDate ';
        query += ' from pse__Project_Task__c ';
        query += ' where pse__Project__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';
        query += ' and ChangeManagerApprovedForSynch__c = false ';
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds ';
        else
        	query += ' and Id not in :submittedIds ';
        	
   		return database.query(query);   
	}
	
	public static boolean isChangedKeyMembers(Id projectId, list<String> submittedIds)
	{        
        if(getChangedKeyMembers(projectId, submittedIds, false).isEmpty())
        	return false;
        return true;                                        
	}
	
	public static list<ProjectTeamMember__c> getChangedKeyMembers(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
	{ 
        String query = 'select Id, Name, Name__c, ChangeManagerIsNew__c, Role__c, ProjectRole__c, LastModifiedById, LastModifiedDate ';
        query += ' from ProjectTeamMember__c ';
        query += ' where project__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';
        query += ' and ChangeManagerApprovedForSynch__c = false ';
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds';
        else
        	query += ' and Id not in :submittedIds';
               
       return database.query(query);                                           
	}	
	
    public static boolean isChangedCustomers(Id projectId, list<String> submittedIds)
    {                                                
        if(getChangedCustomers(projectId, submittedIds, false).isEmpty())                        
            return false;
        return true;
    } 	
    
    public static list<Project_Site__c> getChangedCustomers(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
    {      
        String query = 'select Id, ChangeManagerIsNew__c, Account_Name__c, ';
        query += ' LastModifiedById, LastModifiedDate ';
 		query += ' from Project_Site__c where project__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';
        query += ' and ChangeManagerApprovedForSynch__c = false ';
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds '; 
        else
        	query += ' and Id not in :submittedIds ';

		return database.query(query); 
    }     
    
    public static boolean isChangedClassifications(Id projectId)
    {    	
    	if(getChangedClassifications(projectId).isEmpty())
    		return false;
    	return true;
    }
    
    public static list<pse__Proj__c> getChangedClassifications(Id projectId)
    {
        String query = 'select Id, Name, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate ';
        query += ' from pse__Proj__c where Id = :projectId ';
        query += ' and ChangeManagerIsChangedClass__c = true limit 1';
        
		return database.query(query);    
    } 
    
    public static boolean isChangedSafetyHealthEnv(Id projectId)
    {
    	if(getChangedSafetyHealthEnv(projectId).isEmpty())
    		return false;
    	return true;
    }
    
    public static list<pse__Proj__c> getChangedSafetyHealthEnv(Id projectId)
    {
        String query = 'select Id, Name, ChangeManagerSafetyUpdatedDate__c, ChangeManagerSafetyUpdatedBy__c, ';
        query += ' CreatedDate, CreatedById, LastModifiedById, LastModifiedDate ';
        query += ' from pse__Proj__c where Id = :projectId ';
        query += ' and ChangeManagerIsChangedSHE__c = true limit 1';
                
		return database.query(query);      
    }
    
    public static boolean isChangedResilence(Id projectId)
    {
    	if(getChangedResilience(projectId).isEmpty())
    		return false;
    	return true;
    }
    
    public static list<pse__Proj__c> getChangedResilience(Id projectId)
    {
        String query = 'select Id, Name, ChangeManagerResilienceUpdatedBy__c, ChangeManagerResilienceUpdatedDate__c, ';
        query += ' CreatedDate, CreatedById, LastModifiedById, LastModifiedDate ';
        query += ' from pse__Proj__c ';
        query += ' where Id = :projectId ';
        query += ' and ChangeManagerIsChangedResilence__c = true limit 1';
        
		return database.query(query);   
    }     
    
    public static boolean isChangedRisk(Id projectId, list<String> submittedIds)
    {
    	if(getChangedRiskManagement(projectId, submittedIds, false).isEmpty())
    		return false;
    	return true;
    }
    
    public static list<Risk__c> getChangedRiskManagement(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
    {
        String query = 'select Id, Name, CurrentStatus__c, ChangeManagerIsNew__c, ';
        query += ' RiskOwner__c, RiskCategory__c, LikelihoodofOccurrence__c, ';
        query += ' CreatedDate, CreatedById, LastModifiedById, LastModifiedDate ';
        query += ' from Risk__c where Project__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds ';
        else
        	query += ' and Id not in :submittedIds ';
        	
  		return database.query(query); 
    }    
    
    public static boolean isChangedAgreements(Id projectId, list<String> submittedIds)
    {
    	if(getChangedAgreements(projectId, submittedIds, false).isEmpty())
    		return false;
    	return true;
    }
    
    public static list<Agreement__c> getChangedAgreements(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
    {   
    	String query =  'select Id, Name, ChangeManagerIsNew__c, TotalContractValue__c, RecordType.Name, Amount__c, ';
    	query += ' AgreementType__c, LastModifiedById, LastModifiedDate, CreatedDate, CreatedById ';
        query += ' from Agreement__c where project__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';
        query += ' and ChangeManagerApprovedForSynch__c = false ';       
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds';
        else
        	query += ' and Id not in :submittedIds';
        
        return database.query(query);           	
    } 

    public static boolean isChangedFunding(Id projectId, list<String> submittedIds)
    {
    	if(getChangedFunding(projectId, submittedIds, false).isEmpty())
    		return false;
    	return true;
    }
    
    public static list<Funding__c> getChangedFunding(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
    {
 		String query = 'select Id, Name, ChangeManagerIsNew__c, Agreement__r.Name, DateAllocatedDate__c, ';
 		query += ' AllocatedAmount__c, LastModifiedById, LastModifiedDate, ';
 		query += ' CreatedDate, CreatedById '; 
 		query += ' from Funding__c where project__c = :projectId ';
 		query += ' and ChangeManagerIsChanged__c = true ';
 		query += ' and ChangeManagerApprovedForSynch__c = false ';
 		if(showOnlySubmitted)
 			query += ' and Id in :submittedIds';
 		else
 			query += ' and Id not in :submittedIds';		       

        return database.query(query);
    }

    public static boolean isChangedScope(Id projectId, list<String> submittedIds)
    {
    	if(getChangedScope(projectId, submittedIds, false).isEmpty())
    		return false;
    	return true;
    }
    
    public static list<Packages__c> getChangedScope(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
    {
        String query = 'select Id, Name, Status__c, ChangeManagerIsNew__c, LastModifiedById, ';
        query += ' LastModifiedDate, CreatedDate, CreatedById ';
        query += ' from Packages__c where Scope__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds ';
        else
        	query += ' and Id not in :submittedIds ';
        	    	
    	return database.query(query);    	
     }

    public static boolean isChangedProjectClosure(Id projectId)
    {
    	if(getChangedProjectClosure(projectId).isEmpty())
    		return false;
    	return true;
    }        
               
    public static list<pse__Proj__c> getChangedProjectClosure(Id projectId)
    {
        String query = 'select Id, Name, CMProjectClosureIsChanged__c, RequestedProjectStatus__c, ';
        query += ' ClosureDate__c, ScheduledOnHoldDate__c, ProjectClosureNotes__c, OnHoldReason__c, ScheduledRestartDate__c, ';
        query += ' CreatedDate, CreatedById, LastModifiedById, LastModifiedDate, ';
        query += ' ChangeManagerProjectStatusUpdatedBy__c, ChangeManagerProjectStatusUpdatedDate__c ';
        query += ' from pse__Proj__c where Id = :projectId';
        query += ' and (CMProjectClosureIsChanged__c = true or CMProjectOnHoldIsChanged__c = true)';
        return database.query(query); 
    }
    
    public static boolean isChangedProjectOnHold(Id projectId)
    {
    	if(getChangedProjectOnHold(projectId).isEmpty())
    		return false;
    	return true;
    }    
    
    public static list<pse__Proj__c> getChangedProjectOnHold(Id projectId)
    {
        String query = 'select Id, Name, CMProjectClosureIsChanged__c, RequestedProjectStatus__c, ';
        query += ' ClosureDate__c, ScheduledOnHoldDate__c, ProjectClosureNotes__c, OnHoldReason__c, ';
        query += ' CreatedDate, CreatedById, LastModifiedById, LastModifiedDate ';
        query += ' from pse__Proj__c where Id = :projectId ';
        query += ' and CMProjectOnHoldIsChanged__c = true';
        
        return database.query(query); 
    }    
       
    public static boolean isChangedResources(Id projectId, list<String> submittedIds)
    {
    	if(getChangedResources(projectId, submittedIds, false).isEmpty())
    		return false;
    	return true;
    }    
    
    public static list<VendorSite__c> getChangedResources(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
    {
        String query = 'select Id, Name, ChangeManagerIsNew__c, AccountName__c, CreatedById, ';
        query += ' CreatedDate, LastModifiedById, LastModifiedDate ';
        query += ' from VendorSite__c where Project__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds ';
        else
        	query += ' and Id not in :submittedIds ';        

		return database.query(query); 		        
    }

    public static boolean isChangedDeliverables(Id projectId, list<String> submittedIds)
    {
    	if(getChangedDeliverables(projectId, submittedIds, false).isEmpty())
    		return false;
    	return true;
    }
        
    public static list<Deliverable__c> getChangedDeliverables(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
    {
        String query = 'select Id, Name, ChangeManagerIsNew__c, DeliverableType__c, ';
        query += ' DeliverableOwner__c, DueDate__c, CreatedById, CreatedDate, ';
        query += ' LastModifiedById, LastModifiedDate ';
        query += ' from Deliverable__c where Project__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds ';
        else
        	query += ' and Id not in :submittedIds ';
                
		return database.query(query);    		     
    }
    
    public static boolean isChangedDocumentManagement(Id projectId)
    {
    	if(getChangedDocumentManagement(projectId).isEmpty())
    		return false;
    	return true;
    }    
    
    public static list<pse__Proj__c> getChangedDocumentManagement(Id projectId)
    {
        String query = 'select Id, Name, ChangeManagerDocManageUpdatedBy__c, ';
        query += ' ChangeManagerDocManageUpdatedDate__c, CreatedDate, CreatedById, ';
        query += ' LastModifiedById, LastModifiedDate ';
        query += ' from pse__Proj__c where Id = :projectId ';
        query += ' and ChangeManagerIsChangedDocManage__c = true ';
        
        return database.query(query);       	 	
    }
    
    public static boolean isChangedStakeholders(Id projectId, list<String> submittedIds)
    {
    	if(getChangedStakeholders(projectId, submittedIds, false).isEmpty())
    		return false;
    	return true;
    }     
    
    public static list<Stakeholder__c> getChangedStakeholders(Id projectId, list<String> submittedIds, boolean showOnlySubmitted)
    {
        String query = 'select Id, Name, ChangeManagerIsNew__c, AECOMContact__c, ContactName__c, ';
        query += ' ContactPhone__c, Interest__c, Organization__c, StakeholderType__c, ';
        query += ' CreatedById, CreatedDate, LastModifiedById, LastModifiedDate ';
        query += ' from Stakeholder__c where Project__c = :projectId ';
        query += ' and ChangeManagerIsChanged__c = true ';        
        if(showOnlySubmitted)
        	query += ' and Id in :submittedIds';
        else
        	query += ' and Id not in :submittedIds';
        
        return database.query(query);            	
    }   

    public static void synchronizeProject(String messageQueueId, Id projectId)
    {
        //Id messageQueueId = ECO_Service_ProjectSync.createMessageQueueForRequest(projectId, ECO_Service_ProjectSync.JOBNAME_PROJECT_SYNC);
        Datetime lastSync = DateTime.newInstance(1900, 1, 1);

        ECO_Service_ProjectSync.flagProjectTasksWithSyncStatus('P', projectId, lastSync);
        ECO_Service_ProjectSync.flagKeymembersWithSyncStatus('P', projectId, lastSync);
        ECO_Service_ProjectSync.flagProjectSitesWithSyncStatus('P', projectId, lastSync);

        User user = [select Id, ShaKey__c from User where Id = :UserInfo.getUserId()];
        ECO_IntegrationEndpoints__c cs = ECO_IntegrationEndpoints__c.getInstance('Project Sync 2');
        //String url = cs.EndPointUrl__c + user.ShaKey__c + '&MESSAGE_TYPE=UPDATE_PROJECT&pTransType=N';
        //String url = cs.EndPointUrl__c + user.ShaKey__c;
        String url = cs.EndPointUrl__c + user.ShaKey__c + '&MESSAGE_TYPE=UPDATE_PROJECT';
        handleOracleCallout(projectId, url, messageQueueId);

        ECO_Service_ProjectSync.flagProjectTasksWithSyncStatus('T', projectId, lastSync);
        ECO_Service_ProjectSync.flagKeymembersWithSyncStatus('T', projectId, lastSync);
        ECO_Service_ProjectSync.flagProjectSitesWithSyncStatus('T', projectId, lastSync);
    }

    public static void synchronizeProject2(String messageQueueId, Id projectId)
    {
        //Id messageQueueId = ECO_Service_ProjectSync.createMessageQueueForRequest(projectId, ECO_Service_ProjectSync.JOBNAME_PROJECT_SYNC);
        Datetime lastSync = DateTime.newInstance(1900, 1, 1);

        //ECO_Service_ProjectSync.flagProjectTasksWithSyncStatus('P', projectId, lastSync);
        //ECO_Service_ProjectSync.flagKeymembersWithSyncStatus('P', projectId, lastSync);
        //ECO_Service_ProjectSync.flagProjectSitesWithSyncStatus('P', projectId, lastSync);

        User user = [select Id, ShaKey__c from User where Id = :UserInfo.getUserId()];
        ECO_IntegrationEndpoints__c cs = ECO_IntegrationEndpoints__c.getInstance('Project Sync 2');
        //String url = cs.EndPointUrl__c + user.ShaKey__c + '&MESSAGE_TYPE=UPDATE_PROJECT&pTransType=N';
        //String url = cs.EndPointUrl__c + user.ShaKey__c;
        String url = cs.EndPointUrl__c + user.ShaKey__c + '&MESSAGE_TYPE=UPDATE_PROJECT';
        handleOracleCallout2(projectId, url, messageQueueId);

        //ECO_Service_ProjectSync.flagProjectTasksWithSyncStatus('T', projectId, lastSync);
        //ECO_Service_ProjectSync.flagKeymembersWithSyncStatus('T', projectId, lastSync);
        //ECO_Service_ProjectSync.flagProjectSitesWithSyncStatus('T', projectId, lastSync);
    }    

    @future(callout=true)
    public static void handleOracleCallout(Id projectId, String url, Id messageQueueId)
    {   
        String resp = ECO_Service_ProjectSync.syncProjectWithOracle(projectId, url, messageQueueId);
    }

    @future(callout=true)
    public static void handleOracleCallout2(Id projectId, String url, Id messageQueueId)
    {   
        String resp = ECO_Service_ProjectSync.syncProjectOnlyWithOracle(projectId, url, messageQueueId);
    }    
}