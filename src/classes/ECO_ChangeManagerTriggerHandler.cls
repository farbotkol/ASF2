public class ECO_ChangeManagerTriggerHandler {

	private static String idUpdateString = '';
	private static list<String> submittedForApprovalIds;
	
	public static void handleChangeManagerBeforeUpdate(map<Id, ChangeManager__c> oldMap, list<ChangeManager__c> updatedChangeManagers)
	{
		list<ChangeManager__c> changeManagersToCaptureUpdatedIds = new list<ChangeManager__c>();

		for(ChangeManager__c changeManager:updatedChangeManagers)
		{
			if(!changeManager.IsPMHandoverChange__c && changeManager.ApprovalStatus__c == 'Submitted' && oldMap.get(changeManager.Id).ApprovalStatus__c != 'Sumbitted')
				changeManagersToCaptureUpdatedIds.add(changeManager);
		}	
				
		for(ChangeManager__c changeManager:changeManagersToCaptureUpdatedIds)
		{
			submittedForApprovalIds = ECO_ChangeManager_Service.getChangeManagerSubmittedIds(changeManager.Project__c);
			handleApprovedIdsBudgetChangeManagerSubmitted(changeManager);
			handleApprovedIdsAgreementFundingChangeManagerSubmitted(changeManager);
			handleApprovedIdsCustomersChangeManagerSubmitted(changeManager);
			handleApprovedIdsKeyMembersChangeManagerSubmitted(changeManager);
			handleApprovedIdsSubsVendorsChangeManagerSubmitted(changeManager);
			handleApprovedIdsRisksChangeManagerSubmitted(changeManager);
			handleApprovedIdsDeliverableChangeManagerSubmitted(changeManager);
			handleApprovedIdsStakeholderCommChangeManagerSubmitted(changeManager);	
			handleApprovedIdsScopeChangeManagerSubmitted(changeManager);		
			handleApprovedIdsProjectTasksChangeManagerSubmitted(changeManager);
			
			if(idUpdateString != '')
			{
				changeManager.SubmittedIdsForApproval__c = idUpdateString;
				idUpdateString = '';
			}
			system.debug('Brent' + idUpdateString);
		}	
	}
	
	
	public static void handleChangeManagerUpdate(map<Id, ChangeManager__c> oldMap, list<ChangeManager__c> updatedChangeManagers)
	{
		list<ChangeManager__c> changeManagersToProcess = new list<ChangeManager__c>();
		
		for(ChangeManager__c changeManager:updatedChangeManagers)	
		{
			if(!changeManager.IsPMHandoverChange__c && changeManager.ApprovalStatus__c == 'Approved' && oldMap.get(changeManager.Id).ApprovalStatus__c != 'Approved')
				changeManagersToProcess.add(changeManager);
		}

		for(ChangeManager__c changeManager:changeManagersToProcess)
		{		
			handleBudgetChangeManagerApproval(changeManager);
			handleAgreementsFundingChangeManagerApproval(changeManager);
			handleCustomersChangeManagerApproval(changeManager);
			handleKeyMembersChangeManagerApproval(changeManager);
			handleProjectTasksChangeManagerApproval(changeManager);
			handleScopeChangeManagerApproval(changeManager);
			handleProjectSafetyChangeManagerApproval(changeManager);	
			handleChangeManagerProjectClosureApproval(changeManager);	
			handleProjectClassChangeManagerApproval(changeManager);
			handleProjectDocumentChangeManagerApproval(changeManager);
			handleProjectSafetyChangeManagerApproval(changeManager);
			handleProjectResilenceChangeManagerApproval(changeManager);
			handleDeliverableChangeManagerApproval(changeManager);
			handleProjectRisksChangeManagerApproval(changeManager);
			handleProjectSubsVendorsChangeManagerApproval(changeManager);
			handleProjectStakeholderCommChangeManagerApproval(changeManager);					
		}		
	}
	
	public static void handleApprovedIdsBudgetChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtBudget__c)
		{
			for(BudgetHeader__c bh:[select Id from BudgetHeader__c where Project__c = :changeManager.Project__c])
			{
				if(idUpdateString == '')
					idUpdateString = bh.Id;
				else
					idUpdateString += ',' + bh.Id;
			}			
		}
	}
	
	public static void handleBudgetChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtBudget__c)
		{
			RecordType recrodType = [select Id, Name from RecordType where Id = :changeManager.RecordTypeId];
			BudgetHeader__c budgetHeader = [select Id, RecordType.Name, ChangeManagerIsChanged__c, ChangeManagerApprovedForSynch__c, Status__c from BudgetHeader__c where Id = :changeManager.BudgetHeader__c];
			if(changeManager.IsExternalChange__c)
			{
				budgetHeader.Status__c = 'Approved';
				budgetHeader.ChangeManagerIsChanged__c = false;
				budgetHeader.ChangeManagerApprovedForSynch__c = true;
				//find intenral change to auto approve
				list<ChangeManager__c> internalChangeManager = [select Id, ApprovalStatus__c, IntExtBudgetComments__c from ChangeManager__c 
															where BudgetHeader__c = :changeManager.BudgetHeader__c and
															IsInternalChange__c = true and ApprovalStatus__c != 'Approved'];
				if(internalChangeManager.size() > 0)
				{
					internalChangeManager[0].ApprovalStatus__c = 'Auto Approved';
					internalChangeManager[0].IntExtBudgetComments__c = 'Auto Approved from External Change Manager';
					update internalChangeManager[0];
				}			
			}
			else
			{
				budgetHeader.Status__c = 'Forecast';	
			}
			update budgetHeader;						
		}
	}

	private static void handleApprovedIdsAgreementFundingChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtContractManagement__c)
		{
			for(Agreement__c agreement:ECO_ChangeManager_Service.getChangedAgreements(changeManager.Project__c, submittedForApprovalIds, false))
			{
				if(idUpdateString == '')
					idUpdateString = agreement.Id;
				else
					idUpdateString += ',' + agreement.Id;	
			}
			
			for(Funding__c funding:ECO_ChangeManager_Service.getChangedFunding(changeManager.Project__c, submittedForApprovalIds, false))
			{
				if(idUpdateString == '')
					idUpdateString = funding.Id;
				else
					idUpdateString += ',' + funding.Id;				
			}			
		}
	}

	private static void handleAgreementsFundingChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtContractManagement__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');

			list<Agreement__c> agreements = ECO_ChangeManager_Service.getChangedAgreements(changeManager.Project__c, submittedIds, true);
			list<Funding__c> fundings = ECO_ChangeManager_Service.getChangedFunding(changeManager.Project__c, submittedIds, true);
										
			for(Agreement__c agreement:agreements)
			{
				agreement.ChangeManagerIsChanged__c = false;
				agreement.ChangeManagerApprovedForSynch__c = true;	
				agreement.ChangeManagerIsNew__c  = false;				
			}	
			
			for(Funding__c funding:fundings)
			{
				funding.ChangeManagerIsChanged__c = false;
				funding.ChangeManagerApprovedForSynch__c = true;	
				funding.ChangeManagerIsNew__c = false;			
			}	
			
			if(!agreements.isEmpty())
				update agreements;
				
			if(!fundings.isEmpty())
				update fundings;
		}	
	}
	
	private static void handleApprovedIdsCustomersChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtCustomers__c)
		{
			//for(Project_Site__c projectSite:[select Id from Project_Site__c 
			//     where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true])
			for(Project_Site__c projectSite:ECO_ChangeManager_Service.getChangedCustomers(changeManager.Project__c, submittedForApprovalIds, false))
			{
				if(idUpdateString == '')
					idUpdateString = projectSite.Id;
				else
					idUpdateString += ',' + projectSite.Id;	
			}
		}		
	}
	
	private static void handleCustomersChangeManagerApproval(ChangeManager__c changeManager)
	{

		if(changeManager.IntExtCustomers__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
			list<Project_Site__c> projectSites = [select Id, ChangeManagerIsChanged__c, ChangeManagerApprovedForSynch__c 
			                                      from Project_Site__c where Project__c = :changeManager.Project__c 
			                                      and ChangeManagerIsChanged__c = true and Id in :submittedIds];
			for(Project_Site__c projectSite:projectSites)
			{
				projectSite.ChangeManagerApprovedForSynch__c = true;	
				projectSite.ChangeManagerIsNew__c = false;							
			}
			update projectSites;
		}
	}
	
	private static void handleApprovedIdsKeyMembersChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtKeyMembers__c)
		{			
			for(ProjectTeamMember__c teamMember:[select Id from ProjectTeamMember__c 
												where Project__c = :changeManager.Project__c and 
												ChangeManagerIsChanged__c = true])														
			{
				if(idUpdateString == '')
					idUpdateString = teamMember.Id;
				else
					idUpdateString += ',' + teamMember.Id;	
			}
		}		
	}
	
	private static void handleKeyMembersChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtKeyMembers__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
			
			list<ProjectTeamMember__c> teamMembers = [select Id, ChangeManagerIsChanged__c, ChangeManagerApprovedForSynch__c 
													from ProjectTeamMember__c where Project__c = :changeManager.Project__c 
													and ChangeManagerIsChanged__c = true 
													and Id in :submittedIds];
			for(ProjectTeamMember__c teamMember:teamMembers)
			{
				teamMember.ChangeManagerApprovedForSynch__c = true;
				teamMember.ChangeManagerIsNew__c = false;	
			}
			update teamMembers;						
		}
		
	}

	private static void handleApprovedIdsProjectTasksChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtProjectTasks__c)
		{
			for(pse__Project_Task__c task:[select Id from pse__Project_Task__c where pse__Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = task.Id;
				else
					idUpdateString += ',' + task.Id;	
			}
		}		
	}

	private static void handleProjectTasksChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtProjectTasks__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
			
			list<pse__Project_Task__c> projectTasks = [select Id, ChangeManagerIsChanged__c, ChangeManagerApprovedForSynch__c 
													  from pse__Project_Task__c where pse__Project__c = :changeManager.Project__c 
													  and ChangeManagerIsChanged__c = true and Id in :submittedIds];
			for(pse__Project_Task__c projectTask:projectTasks)
			{
				projectTask.ChangeManagerApprovedForSynch__c = true;
				projectTask.ChangeManagerIsNew__c = false;								
			}
			update projectTasks;				
		}
	}	

	private static void handleApprovedIdsScopeChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtScope__c)
		{
			for(Packages__c scope:[select Id from Packages__c where Scope__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = scope.Id;
				else
					idUpdateString += ',' + scope.Id;	
			}
		}		
	}
		
	private static void handleScopeChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtScope__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
						
			list<Packages__c> scopePackages = [select Id, ChangeManagerIsChanged__c from Packages__c 
												where Scope__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true
												and Id in :submittedIds];	
			for(Packages__c scopePackage:scopePackages)
			{
				scopePackage.ChangeManagerIsChanged__c = false;
				scopePackage.ChangeManagerIsNew__c = false;
			}
			update scopePackages;
		}		
	}

	private static void handleApprovedIdsDeliverableChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtDeliverables__c)
		{
			for(Deliverable__c deliverable:[select Id from Deliverable__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = deliverable.Id;
				else
					idUpdateString += ',' + deliverable.Id;	
			}
		}		
	}
		
	private static void handleDeliverableChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtDeliverables__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
			
			list<Deliverable__c> deliverables = [select Id, ChangeManagerIsChanged__c, ChangeManagerIsNew__c 
												 from Deliverable__c where Project__c = :changeManager.Project__c 
												 and ChangeManagerIsChanged__c = true and Id in :submittedIds];	
			for(Deliverable__c deliverable:deliverables)
			{
				deliverable.ChangeManagerIsChanged__c = false;
				deliverable.ChangeManagerIsNew__c = false;
			}
			update deliverables;
		}		
	}
	
	private static void handleApprovedIdsResilenceChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtSecurity__c)
		{
			for(pse__Proj__c project:[select Id from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedResilence__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = project.Id;
				else
					idUpdateString += ',' + project.Id;	
			}
		}		
	}
		
	private static void handleProjectResilenceChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtSecurity__c)
		{
			list<pse__Proj__c> projects = [select Id, ChangeManagerIsChangedResilence__c from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedResilence__c = true];	
			for(pse__Proj__c project:projects)
			{
				project.ChangeManagerIsChangedResilence__c = false;
				project.ChangeManagerApprovedForSynch__c  = true;
			}
			update projects;
		}		
	}
	
	private static void handleApprovedIdsClassChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtClassifications__c)
		{
			for(pse__Proj__c project:[select Id from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedClass__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = project.Id;
				else
					idUpdateString += ',' + project.Id;	
			}
		}		
	}
		
	private static void handleProjectClassChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtClassifications__c)
		{
			list<pse__Proj__c> projects = [select Id, ChangeManagerIsChangedClass__c from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedClass__c = true];	
			for(pse__Proj__c project:projects)
			{
				project.ChangeManagerIsChangedClass__c = false;
				project.ChangeManagerApprovedForSynch__c  = true;
			}
			update projects;
		}		
	}	
	
	private static void handleApprovedIdsDocumentChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtDocumentManagement__c)
		{
			for(pse__Proj__c project:[select Id from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedDocManage__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = project.Id;
				else
					idUpdateString += ',' + project.Id;	
			}
		}		
	}
		
	private static void handleProjectDocumentChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtDocumentManagement__c)
		{
			list<pse__Proj__c> projects = [select Id, ChangeManagerIsChangedResilence__c from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedDocManage__c = true];	
			for(pse__Proj__c project:projects)
			{
				project.ChangeManagerIsChangedDocManage__c = false;
				project.ChangeManagerApprovedForSynch__c  = true;
			}
			update projects;
		}		
	}

	private static void handleApprovedIdsSafetyChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtSafetyHealthEnv__c)
		{
			for(pse__Proj__c project:[select Id from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedSHE__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = project.Id;
				else
					idUpdateString += ',' + project.Id;	
			}
		}		
	}
		
	private static void handleProjectSafetyChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtSafetyHealthEnv__c)
		{
			list<pse__Proj__c> projects = [select Id, ChangeManagerIsChangedSHE__c from pse__Proj__c where Id = :changeManager.Project__c and ChangeManagerIsChangedSHE__c = true];	
			for(pse__Proj__c project:projects)
			{
				project.ChangeManagerIsChangedSHE__c = false;
				project.ChangeManagerApprovedForSynch__c  = true;
			}
			update projects;
		}		
	}


	private static void handleApprovedIdsSubsVendorsChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtResources__c)
		{
			for(VendorSite__c vendor:[select Id from VendorSite__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = vendor.Id;
				else
					idUpdateString += ',' + vendor.Id;	
			}
		}		
	}
		
	private static void handleProjectSubsVendorsChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtResources__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
			list<VendorSite__c> vendors = [select Id, ChangeManagerIsChanged__c from VendorSite__c 
			                              where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true
			                              and Id in :submittedIds];	
			for(VendorSite__c vendor:vendors)
			{
				vendor.ChangeManagerIsChanged__c = false;
				vendor.ChangeManagerIsNew__c = false;
			}
			update vendors;
		}		
	}

	private static void handleApprovedIdsStakeholderCommChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtStakeholdersComm__c)
		{
			for(Stakeholder__c stakeholder:[select Id from Stakeholder__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = stakeHolder.Id;
				else
					idUpdateString += ',' + stakeHolder.Id;	
			}
		}		
	}//    	list<Risk__c> risks = [select Id, Name, RiskCategory__c, LikelihoodofOccurrence__c, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate from Risk__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true];
	
		
	private static void handleProjectStakeholderCommChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtStakeholdersComm__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
			
			list<Stakeholder__c> stakeholders = [select Id, ChangeManagerIsChanged__c from Stakeholder__c 
											where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true
											and Id in :submittedIds];	
			for(Stakeholder__c stakeholder:stakeholders)
			{
				stakeholder.ChangeManagerIsChanged__c = false;
				stakeholder.ChangeManagerIsNew__c = false;
			}
			update stakeholders;
		}		
	}
	
	private static void handleApprovedIdsRisksChangeManagerSubmitted(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtRiskManagement__c)
		{
			for(Risk__c risk:[select Id from Risk__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true])
			{
				if(idUpdateString == '')
					idUpdateString = risk.Id;
				else
					idUpdateString += ',' + risk.Id;	
			}
		}		
	}//    	list<Risk__c> risks = [select Id, Name, RiskCategory__c, LikelihoodofOccurrence__c, CreatedDate, CreatedById, LastModifiedById, LastModifiedDate from Risk__c where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true];
	
		
	private static void handleProjectRisksChangeManagerApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtRiskManagement__c)
		{
			list<String> submittedIds = changeManager.SubmittedIdsForApproval__c.split(',');
			
			list<Risk__c> risks = [select Id, ChangeManagerIsChanged__c from Risk__c 
			                       where Project__c = :changeManager.Project__c and ChangeManagerIsChanged__c = true
			                       and Id in :submittedIds];	
			for(Risk__c risk:risks)
			{
				risk.ChangeManagerIsChanged__c = false;
				risk.ChangeManagerIsNew__c = false;
			}
			update risks;
		}		
	}	

	private static void handleChangeManagerProjectClosureApproval(ChangeManager__c changeManager)
	{
		if(changeManager.IntExtProjectClosure__c || changeManager.IntExtProjectOnHold__c)
		{		
			pse__Proj__c project = [select Id, pse__Stage__c, CMProjectClosureIsApproved__c, ScheduledOnHoldDate__c, CMProjectClosureIsChanged__c, RequestedProjectStatus__c, ClosureDate__c from pse__Proj__c where Id = :changeManager.Project__c];

			if(project.RequestedProjectStatus__c == 'Closed')
			{
				Id alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);		
				
				project.CMProjectClosureIsChanged__c = false;
				project.CMProjectClosureIsApproved__c = false;
				project.pse__Stage__c = 'Closed';
	
				list<PortalMessage__c> alerts = new list<PortalMessage__c>();
				for(ProjectTeamMember__c projectTeamMember:[Select Id, ProjectRole__c, ProjectRole__r.Name, ProjectRole__r.Type__c, Contact__c, contact__r.pse__Salesforce_User__c, contact__r.pse__Is_Resource_Active__c, Project__c, StartDate__c, EndDate__c, Active__c 
														From ProjectTeamMember__c Where Active__c = true and Project__c = :changeManager.Project__c])			
				{
					alerts.add(new PortalMessage__c(RecordTypeId = alertRecordTypeId
   												, User__c = projectTeamMember.contact__r.pse__Salesforce_User__c 
   												, StartDate__c = Date.today()
   												, EndDate__c = Date.today().addDays(1)
   												, LongDescriptionMaxLength__c = 'This Project has been Approved for closure on ' + project.ClosureDate__c
   												, Subject__c = project.Name
   												, LinkToRecord__c = '/' + project.Id
   												));
				}	
				if(alerts.size() >0 )
					insert alerts;

				list<Messaging.SingleEmailMessage> emailList = new list<Messaging.SingleEmailMessage>();
				Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  
            	email.setToAddresses(new String[] {ECO_Constants.ProjectCloseoutGenericITEmail});   
                email.setSubject('ACTION: Request to Archive Network Project Folder for ' + project.OracleProjectNumber__c);
                String textBody = '';
                textBody +='The subject project is closed.  Please archive the network project folder and send notification to the Project Manager when completed.\n\n';
                email.setPlainTextBody('Closure date has been set to ' + project.ClosureDate__c.format());
                email.setSaveAsActivity(false);
                emailList.add(email);        		
				
                EcoDisableProjectTeamClosureEmail__c settings = EcoDisableProjectTeamClosureEmail__c.getOrgDefaults();

                if(emailList.size() > 0 && settings.EcoDisableProjectTeamClosureEmail__c == false) {
                    Messaging.sendEmail(emailList);
                }	
			}		
			else if(project.RequestedProjectStatus__c == 'On Hold')
			{
				project.CMProjectOnHoldIsChanged__c = false;				
				if(project.ScheduledOnHoldDate__c <= Date.today())
					project.pse__Stage__c = 'On Hold';	
				else
					project.CMProjectOnHoldIsApproved__c = true;
			}
				
			update project;		
		}
	}
}