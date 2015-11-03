public without sharing class ECO_Service_ProjectSync{


	public final Static String STATUS_INITIATED = 'Initiated';	//Connection attempt started
	public final Static String STATUS_ATTEMPTED = 'Attempted';	//Connection attempt failed (time out, or responded with fail code)
	public final Static String STATUS_SENT = 'Sent';				//HTTP Request completed positively
	public final Static String STATUS_ERROR = 'Error';			//Service writes to Message an error
	public final Static String STATUS_SUCCESS = 'Success';		//Service writes to Message with success
	public final Static String JOBNAME_PROJECT_SYNC = 'Project Sync';
	public final Static String JOBNAME_PROJECT_NUMBER = 'Project Number';
	public final Static String JOBNAME_TASK_SYNC_NOW = 'Task Sync Now';
	public final Static String JOBNAME_TASK_SYNC_LATER = 'Task Sync Later';
	public final Static String STATUS_ABORTED = 'Aborted';


	public class EcoServiceException extends Exception {}	

	
	public static string SendProjectData(){
		ProjectMessageWrapper oProjectMessageWrapper = new ProjectMessageWrapper();

		oProjectMessageWrapper.PROJECT_HEADER = new OR_Project();
		oProjectMessageWrapper.KEYMEMBERS_COLLECTION.add(new OR_KeyMember());
		oProjectMessageWrapper.CLASSIFICATION_COLLECTION.add(new OR_Classification());
		oProjectMessageWrapper.CUSTOMERS_COLLECTION.add(new OR_ProjectCustomer());
		oProjectMessageWrapper.WBS_COLLECTION.add(new OR_Task());

		string json_ProjectMessageWrapper = JSON.serializePretty(oProjectMessageWrapper);

		return json_ProjectMessageWrapper;
	}
	
	public static string SendProjectData(Id sProjectId){
		return SendProjectData(sProjectId, null);
	}

	public static string SendProjectData(Id sProjectId, Id messageQueueId){

		ProjectMessageWrapper oProjectMessageWrapper = createProjectMessageWrapper(sProjectId, false, true);
		oProjectMessageWrapper.PROJECT_HEADER.JOB_ID = messageQueueId;

		//return json
		string json_ProjectMessageWrapper = JSON.serializePretty(oProjectMessageWrapper);

		return json_ProjectMessageWrapper;
	}

	public static ProjectMessageWrapper createProjectMessageWrapper(Id sProjectId, Boolean isProjectNumberRequest, Boolean synchRelatedObjects){
		//get project info, exception will be thrown if project can't be found
		pse__Proj__c project = GetOracleProjectRecord(sProjectId);

		//get any additional project rel info and populate DTO objects
		ProjectMessageWrapper oProjectMessageWrapper = new ProjectMessageWrapper();

		//temp code for Suresh
			Id sureshId = Id.valueOf('005e0000002Bj3L');
			Boolean isSuresh = false;
			if(UserInfo.getUserId() == sureshId){
				isSuresh = true;
			}

		if(isProjectNumberRequest){			

			

			OR_Project projectNumberRequest = new OR_Project();
			projectNumberRequest.PROJECT_NAME = project.Name;		
			projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = project.CarryingOutOrganization__r.OrgID__c;
			//temp hack until I figure out which field should be used
			if(projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID == null){
				//projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = project.ProjectOwningOrg__c;
			}
			if(projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID == null){ 
				projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = getPrimaryOrgForProject(sProjectId);
			}
			projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = ECO_Utils_String.NullCheck(projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID);
	

			projectNumberRequest.LONG_NAME = ECO_Utils_String.NullCheck(project.ProjectLongName__c);
			
			projectNumberRequest.DISTRIBUTION_RULE = ECO_Utils_String.NullCheck(project.DistributionRule__c);	


			projectNumberRequest.ORG_ID = ECO_Utils_String.NullCheck(project.CarryingOutOrganization__r.OUID__c);



			/*
			String derivedProjectTemplateId = project.TemplateId__c;
			String derivedProjectTemplateName = project.TemplateName__c;
			*/

			String derivedProjectTemplateId = project.Template_Id__c;
			String derivedProjectTemplateName = project.Template_Name__c;


			/*
			if(String.isEmpty(derivedProjectTemplateId)){
				Map<String,String> derivedTemplateInfo = getDerivedTemplateInfo(projectNumberRequest.DISTRIBUTION_RULE, projectNumberRequest.ORG_ID);
				if(!derivedTemplateInfo.isEmpty()){			
					for(String templateId : derivedTemplateInfo.keySet()){
						derivedProjectTemplateId =templateId;
						derivedProjectTemplateName = derivedTemplateInfo.get(templateId);
					}			
				}
			}
			*/			

			projectNumberRequest.TEMPLATE_ID = derivedProjectTemplateId;
			projectNumberRequest.TEMPLATE_NAME = derivedProjectTemplateName;


			projectNumberRequest.PM_PROJECT_REFERENCE = project.Id;	
			projectNumberRequest.START_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(project.pse__Start_Date__c));
			projectNumberRequest.COST_IND_RATE_SCH_ID = ECO_Utils_String.NullCheck(project.CostIndRateSCHID__c);
			//projectNumberRequest.PROJECT_STATUS = ECO_Utils_String.NullCheck(project.pse__Stage__c).toUpperCase();
			projectNumberRequest.PROJECT_STATUS = 'UNAPPROVED';
			projectNumberRequest.PROJECT_CURRENCY_CODE = ECO_Utils_String.NullCheck(project.ProjectCurrencyCode__c);	
			projectNumberRequest.PROJFUNC_CURRENCY_CODE = ECO_Utils_String.NullCheck(project.ProjectFunctionalCurrencyCode__c);	

			projectNumberRequest.PROJECT_ID = ECO_Utils_String.NullCheck(project.OracleProjectId__c);	

			oProjectMessageWrapper.PROJECT_HEADER = projectNumberRequest;


		}else{

			Boolean taskUpdates = false;
			Boolean keyMemberUpdates = false;
			Boolean customerUpdates = false;
			Boolean projectUpdates = false;

			Datetime lastProjectSyncDateTime = getLastProjectSyncDateTime(project.Id);
			Datetime queryDateTime = Datetime.newInstance(1900, 1, 1);
			if(lastProjectSyncDateTime == NULL){
				//use a temp date in the past to make querying related items easier
				lastProjectSyncDateTime = Datetime.newInstance(1900, 1, 1);
			}

			if(project.LastModifiedDate > lastProjectSyncDateTime){
				projectUpdates = true;
			}
			system.debug('lastProjectSyncDateTime=' + lastProjectSyncDateTime);

			oProjectMessageWrapper.PROJECT_HEADER = new OR_Project(project);

			///////////////// TODO - REMOVE HAREDCODED VALUE //////////////////
			//oProjectMessageWrapper.PROJECT_HEADER.ORG_ID = '147';			

			Set<String> projectClassificationFieldApiNames = ECO_Utils_sObject.getFieldSetMembers('ECO_OracleClassificationFields', 'pse__Proj__c');

			system.debug('projectClassificationFieldApiNames size ' + projectClassificationFieldApiNames.size());
			oProjectMessageWrapper.CLASSIFICATION_COLLECTION = getOracleClassificationCollection(GetOracleProjectClassificationValues(sProjectId, projectClassificationFieldApiNames), projectClassificationFieldApiNames);
					
			if(projectUpdates){
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_HEADER = 'Y';
				if(!oProjectMessageWrapper.CLASSIFICATION_COLLECTION.isEmpty()){
					oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_CLASSIFICATION = 'Y';
				}
			}else{
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_HEADER = 'N';
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_CLASSIFICATION = 'N';
			}

			if(synchRelatedObjects)
			{
				List<pse__Project_Task__c> tasks = GetOracleProjectTaskRecords(sProjectId, queryDateTime);
				oProjectMessageWrapper.WBS_COLLECTION = getOracleTaskCollection(tasks, project);	
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_WBS = 'N';
				if(!oProjectMessageWrapper.WBS_COLLECTION.isEmpty()){
					for(pse__Project_Task__c task : tasks){
						if(task.LastModifiedDate > lastProjectSyncDateTime){
							taskUpdates = true;
						}
					}
					if(taskUpdates){
						oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_WBS = 'Y';
					}				
				}
			}

			if(synchRelatedObjects)
			{
				List<ProjectTeamMember__c> keyMembers = GetOracleKeyMemberRecords(sProjectId, queryDateTime);
				oProjectMessageWrapper.KEYMEMBERS_COLLECTION = getOracleKeyMemberCollection(keyMembers);
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_KEYMEMBERS = 'N';
				if(!oProjectMessageWrapper.KEYMEMBERS_COLLECTION.isEmpty()){
					for(ProjectTeamMember__c keyMember : keyMembers){
						if(keyMember.LastModifiedDate > lastProjectSyncDateTime){
							keyMemberUpdates = true;
						}
					}
					if(keyMemberUpdates){
						oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_KEYMEMBERS = 'Y';
					}				
				}
			}


			if(synchRelatedObjects)
			{	
				List<Project_Site__c> customers = GetOracleProjectSiteRecords(sProjectId, queryDateTime);
				oProjectMessageWrapper.CUSTOMERS_COLLECTION = getOracleCustomerCollection(customers);
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_CUSTOMERS = 'N';
				if(!oProjectMessageWrapper.CUSTOMERS_COLLECTION.isEmpty()){
					for(Project_Site__c customer : customers){
						if(customer.LastModifiedDate > lastProjectSyncDateTime){
							customerUpdates = true;
						}
					}
					if(customerUpdates){
						oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_CUSTOMERS = 'Y';
					}				

					if(oProjectMessageWrapper.PROJECT_HEADER.ENABLE_TOP_TASK_CUSTOMER == 'Y'){
						for(OR_ProjectCustomer customer : oProjectMessageWrapper.CUSTOMERS_COLLECTION){
							customer.CONTRIBUTION = '';
						}
					}else if(oProjectMessageWrapper.PROJECT_HEADER.ENABLE_TOP_TASK_CUSTOMER == 'N'){
						for(OR_ProjectCustomer customer : oProjectMessageWrapper.CUSTOMERS_COLLECTION){
							customer.DEFAULT_TOP_TASK_CUSTOMER = 'N';
						}
					}		
				}
			}
		}		

		return oProjectMessageWrapper;
	}

	public static string SendProjectOnlyData(Id sProjectId, Id messageQueueId)
	{
		ProjectMessageWrapper oProjectNumberWrapper = createProjectMessageWrapper(sProjectId, false, false);
		oProjectNumberWrapper.PROJECT_HEADER.JOB_ID = messageQueueId;
		string json_ProjectMessageWrapper = JSON.serializePretty(oProjectNumberWrapper);
		return json_ProjectMessageWrapper;
	}

	public static string SendProjectNumberData(Id sProjectId, Id messageQueueId){
		ProjectMessageWrapper oProjectNumberWrapper = createProjectMessageWrapper(sProjectId, true, false);
		oProjectNumberWrapper.PROJECT_HEADER.JOB_ID = messageQueueId;
		string json_ProjectMessageWrapper = JSON.serializePretty(oProjectNumberWrapper);
		return json_ProjectMessageWrapper;
	}

	public static string SendProjectNumberData(Id sProjectId){
 		return SendProjectNumberData(sProjectId, null);
	}

	
	public static string SendProjectNumberData(){
		ProjectMessageWrapper oProjectNumberWrapper = new ProjectMessageWrapper();
		string json_ProjectMessageWrapper = JSON.serializePretty(oProjectNumberWrapper);
		return json_ProjectMessageWrapper;
	}
	

	
	public static string TestProxy(string url, string body){
		Http h = new Http();

	    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(url);
	    req.setMethod('GET');
        
        req.setCompressed(true);
        req.setTimeout(30000);
        req.setClientCertificateName('ECOProjService');
        
        req.setBody(body);

	    // Send the request, and return a response
	    HttpResponse res = h.send(req);

	    system.debug(res.getBody());


	    return res.getBody();
	}




	public static pse__Proj__c GetOracleProjectRecord(Id sProjectId){
		
		list<pse__Proj__c> lProjects = new list<pse__Proj__c>([SELECT OracleProjectnumber__c,
																		Segment1__c,
																		Name,
																		pse__Project_Type__c,
																		CarryingOutOrganization__r.OrganizationName__c,
																		pse__Stage__c,
																		ProjectDescription__c,
																		ProjectLongName__c,
																		pse__Start_Date__c,
																		OracleCompletionDate__c,
																		OracleCloseDate__c,
																		EnableTopTaskCustomerFlag__c,
																		OracleCustomerID__c,
																		pse__Account__c,
																		pse__Account__r.Name,
																		PrimarySite__c,
																		PrimarySite__r.Name,
																		PrimarySiteId__c,
																		DefaultTopTaskCustomer__c,
																		ContractTypes__c,
																		DistributionRule__c,			
																		TemplateId__c,		
																		Attribute1__c,
																		Attribute2__c,
																		Attribute3__c,
																		Attribute4__c,
																		Attribute5__c,
																		Attribute6__c,
																		Attribute7__c,
																		Attribute8__c,
																		Attribute9__c,
																		Attribute10__c,
																		Id,
																		AllowCrossChargeFlag__c,
																		IntegrationJobID__c,
																		OracleSyncStatus__c,
																		OracleSyncErrorMessage__c,			
																		CarryingOutOrganizationOracleId__c,
																		TemplateName__c,
																		OrgId__c,
																		ProjectOwningOrg__c,
																		OracleProjectId__c,
																		OracleCustomerNumber__c,
																		pse__Project_Status__c,
																		CostIndRateSCHID__c,
																		ProjectFunctionalCurrencyCode__c,
																		ProjectCurrencyCode__c,
																		CarryingOutOrganization__r.OrgID__c,
																		CarryingOutOrganization__r.OUID__c,
																		LastModifiedDate,
																		CarryingOutOrganization__r.PLManagerContact__r.user__c,
																		CarryingOutOrganization__r.Name,
																		CarryingOutOrganization__r.OUName__c,
																		Template_Id__c,
																		Template_Name__c,
																		ProgBarPrelimPlanApproval__c

																FROM pse__Proj__c
																WHERE Id = :sProjectId]);

		if(lProjects.size() == 0){
			throw new EcoServiceException('Project Not Found');
		}

		return lProjects.get(0);
	}


	public static pse__Proj__c GetOracleProjectClassificationValues(Id sProjectId, Set<String> fieldApiNames){
		String fields = '';
		for(String fieldApiName : fieldApiNames){
			fields += fieldApiName + ',';
		}
		String soql = 'SELECT ' + fields + ' OracleProjectnumber__c, OracleProjectId__c, Id FROM pse__Proj__c WHERE Id = :sProjectId';
		system.debug('classification soql = ' + soql);
		list<pse__Proj__c> lProjects = Database.query(soql);

		if(lProjects.size() == 0){
			throw new EcoServiceException('Project Not Found');
		}

		return lProjects.get(0);
	}

	/*
	 * Refactored existing method GetOracleProjectTaskRecords by adding suffix New so that existing code will work as it is.
	 * This method retrieves the related EarnedValueTask records for a given snapshot date, uses an extra parameter called snapShotDate
	*/
	public static List<pse__Project_Task__c> GetOracleProjectTaskRecordsNew(Id sProjectId, Datetime dateFilterVal, Date snapShotDate){
		List<pse__Project_Task__c> lTasks = new List<pse__Project_Task__c>([SELECT Id,
																				OrgID__c,
																				ProjectNumber__c,																			
																				ProjectTaskNumber__c,
																				Name,
																				pse__Description__c,
																				LongProjTaskName__c,
																				TaskOrg__c,
																				OracleCustomerId__c,
																				BillTo__c,
																				ShipTo__c,			
																				OwnerId,
																				pse__End_Date__c,
																				pse__Start_Date__c,
																				IsBillable__c,
																				IsChargeable__c,
																				WorkTypeName__c,	
																				pse__Parent_Task__c,	
																				pse__Parent_Task__r.Name,		
																				OracleSyncStatus__c,
																				OracleSyncErrorMessage__c,
																				Attribute1__c,
																				Attribute2__c,
																				Attribute3__c,
																				Attribute4__c,
																				Attribute5__c,
																				Attribute6__c,
																				Attribute7__c,
																				Attribute8__c,
																				Attribute9__c,
																				Attribute10__c,
																				pse__Project__r.OrgID__c,
																				pse__Project__r.OracleProjectnumber__c,
																				pse__Project__r.OracleProjectId__c,
																				CostIndRateSCHID__c,
																				LastModifiedDate,
																				pse__Hierarchy_Depth__c,
																				TaxReceivingTask__c,
																				AECOMTaxOverride__c,
																				AECOMWorkSiteCity__c,
																				AECOMWorkSiteStateCountry__c,
																				AllowCrossCharge__c,
																				TopTaskOwningCustomerOracleId__c,
																				ProjectTaskOwner__c,
																				ProjectTaskOwner__r.Name,
																				ProjectTaskOwner__r.Email,
																				FinancialTask__c,
																				pse__Actual_Start_Date__c,
																				pse__Actual_End_Date__c,
																				TotalApprovedCost__c,
																				(SELECT Id,
																						PercentComplete__c,
																						ProjectTask__c,
																						NotifyTaskOwner__c,
																						Comments__c,
																						Committed__c,
																						CostAccruals__c,
																						EarnedValueHeader__c,
																						EarnedValueSnapshot__c,
																						EarnedValueSnapshot__r.WeekStartDate__c,
																						TaskTotalApprovedCostSnapshot__c,
																						SnapshotDate__c,
																						ProjectTask__r.Name
																					FROM Earned_Value_Tasks__r 
																					WHERE SnapshotDate__c = :snapShotDate
																				) 		
																	
																			FROM pse__Project_Task__c
																			WHERE pse__Project__c = :sProjectId
																			AND LastModifiedDate >= :dateFilterVal
																			]);

		return lTasks;
	}
	
	public static List<pse__Project_Task__c> GetOracleProjectTaskRecordsforProjectAndReport(Id sProjectId, Id reportId, Datetime dateFilterVal, Date snapShotDate) {
		List<pse__Project_Task__c> lTasks = new List<pse__Project_Task__c>([SELECT Id,
																				OrgID__c,
																				ProjectNumber__c,																			
																				ProjectTaskNumber__c,
																				Name,
																				pse__Description__c,
																				LongProjTaskName__c,
																				TaskOrg__c,
																				OracleCustomerId__c,
																				BillTo__c,
																				ShipTo__c,			
																				OwnerId,
																				pse__End_Date__c,
																				pse__Start_Date__c,
																				IsBillable__c,
																				IsChargeable__c,
																				WorkTypeName__c,	
																				pse__Parent_Task__c,	
																				pse__Parent_Task__r.Name,		
																				OracleSyncStatus__c,
																				OracleSyncErrorMessage__c,
																				Attribute1__c,
																				Attribute2__c,
																				Attribute3__c,
																				Attribute4__c,
																				Attribute5__c,
																				Attribute6__c,
																				Attribute7__c,
																				Attribute8__c,
																				Attribute9__c,
																				Attribute10__c,
																				pse__Project__r.OrgID__c,
																				pse__Project__r.OracleProjectnumber__c,
																				pse__Project__r.OracleProjectId__c,
																				CostIndRateSCHID__c,
																				LastModifiedDate,
																				pse__Hierarchy_Depth__c,
																				TaxReceivingTask__c,
																				AECOMTaxOverride__c,
																				AECOMWorkSiteCity__c,
																				AECOMWorkSiteStateCountry__c,
																				AllowCrossCharge__c,
																				TopTaskOwningCustomerOracleId__c,
																				ProjectTaskOwner__c,
																				ProjectTaskOwner__r.Name,
																				ProjectTaskOwner__r.Email,
																				FinancialTask__c,
																				pse__Actual_Start_Date__c,
																				pse__Actual_End_Date__c,
																				TotalApprovedCost__c,
																				TotalProjectFunctionalBurdenedCost__c,
																				(SELECT Id,
																						PercentComplete__c,
																						ProjectTask__c,
																						NotifyTaskOwner__c,
																						Comments__c,
																						Committed__c,
																						CostAccruals__c,
																						EarnedValueHeader__c,
																						EarnedValueSnapshot__c,
																						EarnedValueSnapshot__r.WeekStartDate__c,
																						TaskTotalApprovedCostSnapshot__c,
																						SnapshotDate__c,
																						ProjectTask__r.Name,
																						TrendEAC1__c,
																						TrendEAC2__c
																					FROM Earned_Value_Tasks__r 
																					WHERE SnapshotDate__c = :snapShotDate
																					and EarnedValueHeader__c = :reportId
																				) 		
																	
																			FROM pse__Project_Task__c
																			WHERE pse__Project__c = :sProjectId
																			AND LastModifiedDate >= :dateFilterVal
																			]);

		return lTasks;
	}

	public static List<pse__Project_Task__c> GetOracleProjectTaskRecords(Id sProjectId, Datetime dateFilterVal){
		List<pse__Project_Task__c> lTasks = new List<pse__Project_Task__c>([SELECT Id,
																				OrgID__c,
																				ProjectNumber__c,																			
																				ProjectTaskNumber__c,
																				Name,
																				pse__Description__c,
																				LongProjTaskName__c,
																				TaskOrg__c,
																				OracleCustomerId__c,
																				BillTo__c,
																				ShipTo__c,			
																				OwnerId,
																				pse__End_Date__c,
																				pse__Start_Date__c,
																				IsBillable__c,
																				IsChargeable__c,
																				WorkTypeName__c,	
																				pse__Parent_Task__c,	
																				pse__Parent_Task__r.Name,		
																				OracleSyncStatus__c,
																				OracleSyncErrorMessage__c,
																				Attribute1__c,
																				Attribute2__c,
																				Attribute3__c,
																				Attribute4__c,
																				Attribute5__c,
																				Attribute6__c,
																				Attribute7__c,
																				Attribute8__c,
																				Attribute9__c,
																				Attribute10__c,
																				pse__Project__r.OrgID__c,
																				pse__Project__r.OracleProjectnumber__c,
																				pse__Project__r.OracleProjectId__c,
																				CostIndRateSCHID__c,
																				LastModifiedDate,
																				pse__Hierarchy_Depth__c,
																				TaxReceivingTask__c,
																				AECOMTaxOverride__c,
																				AECOMWorkSiteCity__c,
																				AECOMWorkSiteStateCountry__c,
																				AllowCrossCharge__c,
																				TopTaskOwningCustomerOracleId__c,
																				ProjectTaskOwner__c,
																				ProjectTaskOwner__r.Name,
																				ProjectTaskOwner__r.Email,
																				FinancialTask__c,
																				pse__Actual_Start_Date__c,
																				pse__Actual_End_Date__c,
																				TotalApprovedCost__c 																			
																			FROM pse__Project_Task__c
																			WHERE pse__Project__c = :sProjectId
																			AND LastModifiedDate >= :dateFilterVal
																			]);

		return lTasks;
	}

	/*
	public static List<ProjectTeamMember__c> GetOracleProjectTeamMemberRecords(Id sProjectId){
		List<ProjectTeamMember__c> lTeamMembers = new List<ProjectTeamMember__c>([SELECT Id,
																					Name,
																					Project__r.OracleProjectnumber__c,
																					Project__r.OracleProjectId__c,
																					Employee_number__c,
																					PersonId__c,
																					ProjectRole__r.Name,
																					ProjectRole__r.Active__c,
																					ProjectRole__r.Type__c,
																					StartDate__c,
																					EndDate__c,
																					OracleSyncStatus__c,
																					OracleSyncErrorMessage__c,
																					RecordTypeId,
																					Contact__r.pse__Salesforce_User__c,
																					Contact__r.Name,
																					OracleEmployeeNumber__c,
																					OraclePersonId__c,
																					OracleProjectRoleTypeId__c,
																					OracleProjectNumber__c,
																					OracleProjectId__c,
																					LastModifiedDate 
																				FROM ProjectTeamMember__c
																				WHERE Project__c = :sProjectId
																				AND ProjectRole__r.Active__c = true]);
		return lTeamMembers;
	}
	
*/
	public static List<ProjectTeamMember__c> GetOracleKeyMemberRecords(Id sProjectId, Datetime dateFilterVal){

		List<ProjectTeamMember__c> lTeamMembers = new List<ProjectTeamMember__c>([SELECT Id,
																					Name,
																					User__r.Name,
																					Project__r.OracleProjectnumber__c,
																					Project__r.OracleProjectId__c,
																					Employee_number__c,
																					PersonId__c,
																					ProjectRole__r.Name,
																					ProjectRole__r.Active__c,
																					ProjectRole__r.Type__c,
																					StartDate__c,
																					EndDate__c,
																					OracleSyncStatus__c,
																					OracleSyncErrorMessage__c,
																					RecordTypeId,
																					Contact__r.pse__Salesforce_User__c,
																					Contact__r.Name,
																					Contact__r.User__c,
																					OracleEmployeeNumber__c,
																					OraclePersonId__c,
																					OracleProjectRoleTypeId__c,
																					OracleProjectNumber__c,
																					OracleProjectId__c,
																					LastModifiedDate 
																				FROM ProjectTeamMember__c
																				WHERE Project__c = :sProjectId
																				AND ProjectRole__r.Type__c = 'Key Member'
																				AND ProjectRole__r.Active__c = true		
																				AND LastModifiedDate >= :dateFilterVal																		
																				]);
		return lTeamMembers;
	}
	

	public static List<ProjectTeamMember__c> GetOracleKeyMemberRecords(Id sProjectId){
				

		List<ProjectTeamMember__c> lTeamMembers = new List<ProjectTeamMember__c>([SELECT Id,
																					Name,
																					Project__r.OracleProjectnumber__c,
																					Project__r.OracleProjectId__c,
																					Employee_number__c,
																					PersonId__c,
																					ProjectRole__r.Name,
																					ProjectRole__r.Active__c,
																					ProjectRole__r.Type__c,
																					StartDate__c,
																					EndDate__c,
																					OracleSyncStatus__c,
																					OracleSyncErrorMessage__c,
																					RecordTypeId,
																					Contact__r.pse__Salesforce_User__c,
																					Contact__r.Name,
																					OracleEmployeeNumber__c,
																					OraclePersonId__c,
																					OracleProjectRoleTypeId__c,
																					OracleProjectNumber__c,
																					OracleProjectId__c,
																					LastModifiedDate,
																					User__c
																				FROM ProjectTeamMember__c
																				WHERE Project__c = :sProjectId
																				AND ProjectRole__r.Type__c = 'Key Member'
																				AND ProjectRole__r.Active__c = true]);
		return lTeamMembers;
	}


    public static List<Project_Site__c> GetOracleProjectSiteRecords(Id sProjectId, Datetime dateFilterVal){
		List<Project_Site__c> lSites = new List<Project_Site__c>([SELECT Project__c,
																				Name,
																				Project__r.OracleProjectnumber__c,
																				Project__r.OracleProjectId__c,
																				Segment1__c,
																				OracleCustomerID__c,
																				OracleCustomerNumber__c,
																				Account_Name__c,
																				BillToAddressID__c,
																				ShipToAddressID__c,
																				BillingContactID__c,
																				Is_Default_Top_Task__c,
																				CurrencyIsoCode,
																				Contribution__c,			
																				JobID__c,
																				OracleSyncStatus__c,
																				OracleSyncErrorMessage__c,
																				OracleProjectId__c,
																				Site__r.CustomerAccountSiteID__c,
																				OracleBillToAddressId__c,
																				OracleShipToAddressId__c,
																				LastModifiedDate 
																		FROM Project_Site__c
																		WHERE Project__c = :sProjectId
																		AND IsCustomer__c = true
																		AND LastModifiedDate >= :dateFilterVal
																		AND Is_Billing__c = true
																		]);
		return lSites;
	}



	public class ProjectMessageWrapper {
		//To store as reference in Oracle
		public string FF_PROJECT_ID {get; set;}
		//Field will help us with performance
		public string ORACLE_PROJECT_ID {get; set;}
		//NEW/SYNCH/UPDATE ? Not mandatory, we can determine  Create or update request based on the oracle_Project_id field in the string
		public string MODE {get; set;}
		//Populate with oracle person_id of the person initiating the action, in future we could use this field to update audit data in Oracle
		public string ORACLE_PERSON_ID {get; set;}
		public string MESSAGE_ID {get; set;}
		public OR_Project PROJECT_HEADER {get; set;}		
		public list<OR_Task> WBS_COLLECTION {get; set;}		
		public list<OR_Classification> CLASSIFICATION_COLLECTION {get; set;}
		public list<OR_KeyMember> KEYMEMBERS_COLLECTION {get; set;}
		public list<OR_ProjectCustomer> CUSTOMERS_COLLECTION {get; set;}

		public ProjectMessageWrapper(){
			this.FF_PROJECT_ID = '';
			this.ORACLE_PROJECT_ID = '';
			this.MODE = '';
			this.ORACLE_PERSON_ID = '';			
			this.MESSAGE_ID = '';
			this.PROJECT_HEADER = new OR_Project();
			this.WBS_COLLECTION = new list<OR_Task>();
			this.CLASSIFICATION_COLLECTION = new list<OR_Classification>();
			this.KEYMEMBERS_COLLECTION = new list<OR_KeyMember>();
			this.CUSTOMERS_COLLECTION = new list<OR_ProjectCustomer>();
		}
	}

	public class OR_Project {
		public string PROJECT_ID {get; set;}
		public string SEGMENT1 {get; set;}
		public string PROJECT_NAME {get; set;}
		public string PROJECT_TYPE {get; set;}
		public string CARRYING_OUT_ORGANIZATION_ID {get; set;}
		public string PROJECT_STATUS {get; set;}
		public string DESCRIPTION {get; set;}	
		public string LONG_NAME {get; set;}
		public string START_DATE {get; set;}
		public string COMPLETION_DATE {get; set;}
		public string CLOSED_DATE {get; set;}
		public string ENABLE_TOP_TASK_CUSTOMER  {get; set;}
		public string CUSTOMER_ID {get;set;}
		public string CUSTOMER_NUMBER {get;set;}
		public string CUSTOMER_NAME {get;set;}
		public string CUSTOMER_SITE {get;set;}
		public string CUSTOMER_SITE_ID {get;set;}
		public string DEFAULT_TOP_TASK_CUST {get;set;}
		//public string CONTRACT_TYPE {get; set;}
		public string DISTRIBUTION_RULE {get; set;}
		public string TEMPLATE_ID {get; set;}
		public string TEMPLATE_NAME {get;set;}
		public string COST_IND_RATE_SCH_ID  {get; set;}		
		public string ATTRIBUTE1 {get; set;}
		public string ATTRIBUTE2 {get; set;}
		public string ATTRIBUTE3 {get; set;}
		public string ATTRIBUTE4 {get; set;}
		public string ATTRIBUTE5 {get; set;}
		public string ATTRIBUTE6 {get; set;}
		public string ATTRIBUTE7 {get; set;}
		public string ATTRIBUTE8 {get; set;}
		public string ATTRIBUTE9 {get; set;}
		public string ATTRIBUTE10 {get; set;}
		public string ORG_ID {get; set;}
		public string PM_PROJECT_REFERENCE {get; set;}		
		public string PROJECT_CURRENCY_CODE {get; set;}
		public string PROJFUNC_CURRENCY_CODE {get; set;}
		public string ALLOW_CROSS_CHARGE_FLAG {get; set;}
		public string SEQUENCE_ID {get; set;}
		public string JOB_ID {get; set;}
		public string RECORD_STATUS {get; set;}
		public string ERROR_MESSAGE {get; set;}

		//Populate with Y if header information is changed: eg: Start Date/End Date, Project Name etc
		public string UPDATES_TO_HEADER {get; set;}
		//Populate with Y if WBS is updated
		public string UPDATES_TO_WBS {get; set;}
		//Populate with Y if Classifications are updated
		public string UPDATES_TO_CLASSIFICATION {get; set;}
		//Populate with Y if key members are updated
		public string UPDATES_TO_KEYMEMBERS {get; set;}
		//Populated with Y if customer records are updated
		public string UPDATES_TO_CUSTOMERS {get; set;}

		public OR_Project(){
			this.PROJECT_ID = '';
			this.SEGMENT1 = '';
			this.PROJECT_NAME = '';
			this.PROJECT_TYPE = '';
			this.CARRYING_OUT_ORGANIZATION_ID = '';
			this.PROJECT_STATUS = '';
			this.DESCRIPTION = '';
			this.LONG_NAME = '';
			this.START_DATE = '';					
			this.COMPLETION_DATE = '';			
			this.CLOSED_DATE = '';
			this.ENABLE_TOP_TASK_CUSTOMER = '';
			this.CUSTOMER_NUMBER = '';
			this.CUSTOMER_NAME = '';
			this.CUSTOMER_SITE = '';
			this.CUSTOMER_SITE_ID = '';
			this.CUSTOMER_ID = '';
			this.DEFAULT_TOP_TASK_CUST = '';			
			//this.CONTRACT_TYPE = '';
			this.DISTRIBUTION_RULE = '';
			this.TEMPLATE_ID = '';	
			this.COST_IND_RATE_SCH_ID  = '';
			this.ATTRIBUTE1 = '';
			this.ATTRIBUTE2 = '';
			this.ATTRIBUTE3 = '';
			this.ATTRIBUTE4 = '';
			this.ATTRIBUTE5 = '';
			this.ATTRIBUTE6 = '';
			this.ATTRIBUTE7 = '';
			this.ATTRIBUTE8 = '';
			this.ATTRIBUTE9 = '';
			this.ATTRIBUTE10 = '';
			this.ORG_ID = '';
			this.PM_PROJECT_REFERENCE = '';			
			this.PROJECT_CURRENCY_CODE = '';
			this.PROJFUNC_CURRENCY_CODE = '';
			this.ALLOW_CROSS_CHARGE_FLAG = '';	
			this.SEQUENCE_ID = '';
			this.JOB_ID ='';
			this.RECORD_STATUS = '';
			this.ERROR_MESSAGE = '';

			this.UPDATES_TO_HEADER = 'N';
			this.UPDATES_TO_WBS = 'N';
			this.UPDATES_TO_CLASSIFICATION = 'N';
			this.UPDATES_TO_KEYMEMBERS = 'N';
			this.UPDATES_TO_CUSTOMERS = 'N';
		}

		public OR_Project(pse__Proj__c oProject){					

			
			/*	
			String derivedProjectTemplateId = oProject.TemplateId__c;
			String derivedProjectTemplateName = oProject.TemplateName__c;		


			if(String.isEmpty(derivedProjectTemplateId)){
				//Map<String,String> derivedTemplateInfo = getDerivedTemplateInfo(oProject.DistributionRule__c, '147');
				Map<String,String> derivedTemplateInfo = getDerivedTemplateInfo(oProject.DistributionRule__c, oProject.CarryingOutOrganization__r.OUID__c);
		
				if(!derivedTemplateInfo.isEmpty()){			
					for(String templateId : derivedTemplateInfo.keySet()){
						derivedProjectTemplateId =templateId;
						derivedProjectTemplateName = derivedTemplateInfo.get(templateId);
					}					
				}
			}
			*/

			String derivedProjectTemplateId = oProject.Template_Id__c;
			String derivedProjectTemplateName = oProject.Template_Name__c;

		
			this.TEMPLATE_ID = derivedProjectTemplateId;
			this.TEMPLATE_NAME = derivedProjectTemplateName;

			this.PROJECT_ID = ECO_Utils_String.NullCheck(oProject.OracleProjectId__c);
			this.SEGMENT1 = ECO_Utils_String.NullCheck(oProject.Segment1__c);
			this.PROJECT_NAME = ECO_Utils_String.NullCheck(oProject.Name);
			this.PROJECT_TYPE = ECO_Utils_String.NullCheck(oProject.pse__Project_Type__c);
			//this.CARRYING_OUT_ORGANIZATION_ID = oProject.PrimaryOrganization__c;
			//this.CARRYING_OUT_ORGANIZATION_ID = ECO_Utils_String.NullCheck(oProject.PrimaryOrganization__r.OrgID__c);
			
			//fix for imported projects not having primary id set
			//if(oProject.PrimaryOrganization__r.OrgID__c != null){
			//	this.CARRYING_OUT_ORGANIZATION_ID = ECO_Utils_String.NullCheck(oProject.PrimaryOrganization__r.OrgID__c);
			//}else{
				this.CARRYING_OUT_ORGANIZATION_ID = ECO_Utils_String.NullCheck(oProject.CarryingOutOrganizationOracleId__c);
			//}
			
			// ITEM:WI-003020
			IF(ECO_Utils_String.NullCheck(oProject.pse__Stage__c).toUpperCase() == 'ON HOLD'){
				//this.PROJECT_STATUS = ECO_Utils_String.NullCheck(oProject.pse__Stage__c).toUpperCase();
				this.PROJECT_STATUS = '1020';
			} ELSE IF(ECO_Utils_String.NullCheck(oProject.pse__Stage__c).toUpperCase() == 'CLOSED'){
				//this.PROJECT_STATUS = ECO_Utils_String.NullCheck(oProject.pse__Stage__c).toUpperCase();
				this.PROJECT_STATUS = 'CLOSED';
			} else {
				this.PROJECT_STATUS = 'APPROVED';
			}
			//this.PROJECT_STATUS = ECO_Utils_String.NullCheck(oProject.pse__Stage__c).toUpperCase();
			

			// TC: Agreed between ML and Suresh that description will be sent as '' or 'null'
			//this.DESCRIPTION = ECO_Utils_String.NullCheck(oProject.ProjectDescription__c);
			this.DESCRIPTION = '';
			this.LONG_NAME = ECO_Utils_String.NullCheck(oProject.ProjectLongName__c);
			this.START_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(oProject.pse__Start_Date__c));
			this.COMPLETION_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(oProject.OracleCompletionDate__c));
			this.CLOSED_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(oProject.OracleCloseDate__c));
			this.ENABLE_TOP_TASK_CUSTOMER  = ECO_Utils_String.NullCheck(formatBooleanForOracle(oProject.EnableTopTaskCustomerFlag__c));
			this.CUSTOMER_NUMBER = ECO_Utils_String.NullCheck(oProject.OracleCustomerNumber__c);
			this.CUSTOMER_NAME = ECO_Utils_String.NullCheck(oProject.pse__Account__r.Name);
			this.CUSTOMER_SITE = ECO_Utils_String.NullCheck(formatLookupIdForOracle(oProject.PrimarySite__c));
			this.CUSTOMER_SITE_ID = ECO_Utils_String.NullCheck(oProject.PrimarySiteId__c);
			this.CUSTOMER_ID = ECO_Utils_String.NullCheck(oProject.OracleCustomerID__c);
			this.DEFAULT_TOP_TASK_CUST = ECO_Utils_String.NullCheck(formatLookupIdForOracle(oProject.DefaultTopTaskCustomer__c));	
			//this.CONTRACT_TYPE = ECO_Utils_String.NullCheck(oProject.ContractTypes__c);
			this.DISTRIBUTION_RULE = ECO_Utils_String.NullCheck(oProject.DistributionRule__c);			
			


			this.COST_IND_RATE_SCH_ID = ECO_Utils_String.NullCheck(oProject.CostIndRateSCHID__c);

     		this.ATTRIBUTE1 = ECO_Utils_String.NullCheck(oProject.Attribute1__c);
			this.ATTRIBUTE2 = ECO_Utils_String.NullCheck(oProject.Attribute2__c);
			this.ATTRIBUTE3 = ECO_Utils_String.NullCheck(oProject.Attribute3__c);
			this.ATTRIBUTE4 = ECO_Utils_String.NullCheck(oProject.Attribute4__c);
			this.ATTRIBUTE5 = ECO_Utils_String.NullCheck(oProject.Attribute5__c);
			this.ATTRIBUTE6 = ECO_Utils_String.NullCheck(oProject.Attribute6__c);
			this.ATTRIBUTE7 = ECO_Utils_String.NullCheck(oProject.Attribute7__c);
			this.ATTRIBUTE8 = ECO_Utils_String.NullCheck(oProject.Attribute8__c);
			this.ATTRIBUTE9 = ECO_Utils_String.NullCheck(oProject.Attribute9__c);
			this.ATTRIBUTE10 = ECO_Utils_String.NullCheck(oProject.Attribute10__c);
			//this.ORG_ID = ECO_Utils_String.NullCheck(oProject.OrgID__c);

			this.ORG_ID = ECO_Utils_String.NullCheck(oProject.CarryingOutOrganization__r.OUID__c);

			this.PM_PROJECT_REFERENCE = ECO_Utils_String.NullCheck(oProject.Id);			
			this.PROJECT_CURRENCY_CODE = ECO_Utils_String.NullCheck(oProject.ProjectCurrencyCode__c);	
			this.PROJFUNC_CURRENCY_CODE = ECO_Utils_String.NullCheck(oProject.ProjectFunctionalCurrencyCode__c);	
			this.ALLOW_CROSS_CHARGE_FLAG = formatBooleanForOracle(oProject.AllowCrossChargeFlag__c);	
			this.SEQUENCE_ID = '';
			this.JOB_ID ='';
			this.RECORD_STATUS = '';
			this.ERROR_MESSAGE = '';
										
		}
	}

	public class OR_Classification{
		public string PROJECT_NUMBER {get; set;}
		public string PROJECT_ID {get; set;}
		public string CLASS_CATEGORY {get; set;}
		public string CLASS_CODE {get; set;}

		public OR_Classification(){
			this.PROJECT_NUMBER = '';
			this.PROJECT_ID = '';
			this.CLASS_CATEGORY = '';
			this.CLASS_CODE = '';
		}

		public OR_Classification(string sProjectNumber, string sProjectId, string sClassCategory, string sClassCode){
			this.PROJECT_NUMBER = ECO_Utils_String.NullCheck(sProjectNumber); 
			this.PROJECT_ID = ECO_Utils_String.NullCheck(sProjectId);
			this.CLASS_CATEGORY = ECO_Utils_String.NullCheck(sClassCategory);
			this.CLASS_CODE = ECO_Utils_String.NullCheck(sClassCode);
		}
	}

	public class OR_KeyMember{
		public string PROJECT_NUMBER {get; set;}
		public string PROJECT_ID {get; set;}
		public string EMPLOYEE_NUMBER {get; set;}
		public string PERSON_ID {get; set;}
		public string PROJECT_ROLE_TYPE_M {get; set;}
		public string START_DATE {get; set;}
		public string END_DATE {get; set;}
		public string SEQUENCE_ID {get; set;}
		public string JOB_ID {get; set;}
		public string RECORD_STATUS {get; set;}
		public string ERROR_MESSAGE {get; set;}

		public OR_KeyMember(){
			this.PROJECT_NUMBER = '';
			this.PROJECT_ID = '';
			this.EMPLOYEE_NUMBER = '';
			this.PERSON_ID = '';
			this.PROJECT_ROLE_TYPE_M = '';
			this.START_DATE = '';
			this.END_DATE = '';
			this.SEQUENCE_ID = '';
			this.JOB_ID = '';
			this.RECORD_STATUS = '';
			this.ERROR_MESSAGE = '';
		}

		public OR_KeyMember(ProjectTeamMember__c oProjectTeamMember){
			//this.PROJECT_NUMBER = ECO_Utils_String.NullCheck(oProjectTeamMember.Project__r.OracleProjectnumber__c);
			//this.PROJECT_ID = ECO_Utils_String.NullCheck(oProjectTeamMember.Project__r.OracleProjectId__c);

			this.PROJECT_NUMBER = ECO_Utils_String.NullCheck(oProjectTeamMember.OracleProjectNumber__c);
			this.PROJECT_ID = ECO_Utils_String.NullCheck(oProjectTeamMember.OracleProjectId__c);
																				
		
			//use these when we get updated user and contact data
			this.EMPLOYEE_NUMBER = ECO_Utils_String.NullCheck(oProjectTeamMember.OracleEmployeeNumber__c);
			this.PERSON_ID = ECO_Utils_String.NullCheck(oProjectTeamMember.OraclePersonId__c);

			//these fields will allow input of values for testing
			/*
			if(!String.isEmpty(ECO_Utils_String.NullCheck(oProjectTeamMember.Employee_number__c)) || !String.isEmpty(ECO_Utils_String.NullCheck(oProjectTeamMember.PersonId__c))){
				this.EMPLOYEE_NUMBER = ECO_Utils_String.NullCheck(oProjectTeamMember.Employee_number__c);
				this.PERSON_ID = ECO_Utils_String.NullCheck(oProjectTeamMember.PersonId__c);
			}
			*/
				
			//String roleName = ECO_Utils_String.NullCheck(oProjectTeamMember.ProjectRole__r.Name);
			//this.PROJECT_ROLE_TYPE_M = roleName.toUpperCase();
			this.PROJECT_ROLE_TYPE_M = ECO_Utils_String.NullCheck(oProjectTeamMember.OracleProjectRoleTypeId__c);
			
			this.START_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(oProjectTeamMember.StartDate__c));
			this.END_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(oProjectTeamMember.EndDate__c));
			this.SEQUENCE_ID = '';
			this.JOB_ID = '';
			this.RECORD_STATUS = '';
			this.ERROR_MESSAGE = '';
		}
	}

	public class OR_Task{
		//public string ORG_ID {get;set;}
		public string PROJECT_NUM {get; set;}
		public string WBS_LEVEL {get; set;}
		public string TASK_NO {get; set;}
		public string TASK_NAME {get; set;}
		//public string TASK_DESCRIPTION {get; set;}
		public string LONG_TASK_NAME {get; set;}
		public string TASK_ORG {get; set;}
		public string CUSTOMER_ID {get; set;}
		//public string BILL_TO {get;set;}
		//public string SHIP_TO {get;set;}
		//public string CONTACT {get;set;}
		public string TASK_MANAGER {get; set;}
		public string TASK_COMPLETION_DATE {get; set;}
		public string TASK_START_DATE {get; set;}
		public string BILLABLE_FLAG {get; set;}
		public string CHARGEABLE_FLAG {get; set;}
		public string WORK_TYPE_NAME {get; set;}
		public string COST_IND_RATE_SCH_ID {get; set;}
		public string PM_TASK_REFERENCE {get; set;}
		public string PM_PARENT_TASK_REFERENCE {get; set;}
		public string ATTRIBUTE_CATEGORY {get; set;}
		public string SEQUENCE_ID {get; set;}
		public string JOB_ID {get; set;}
		public string RECORD_STATUS {get;set;}
		//public string ERROR_MESSAGE {get;set;}
		public string ALLOW_CROSS_CHARGE_FLAG {get;set;}
		public string ATTRIBUTE1 {get; set;}
		public string ATTRIBUTE2 {get; set;}
		public string ATTRIBUTE3 {get; set;}
		public string ATTRIBUTE4 {get; set;}
		public string ATTRIBUTE5 {get; set;}
		public string ATTRIBUTE6 {get; set;}
		public string ATTRIBUTE7 {get; set;}
		public string ATTRIBUTE8 {get; set;}
		public string ATTRIBUTE9 {get; set;}
		public string ATTRIBUTE10 {get; set;}
		public string PROJECT_ID {get; set;}

		

		public OR_Task(){
			//this.ORG_ID = '';
			this.PROJECT_NUM = '';
			this.WBS_LEVEL = '';
			this.TASK_NO = '';
			this.TASK_NAME = '';
			//this.TASK_DESCRIPTION = '';
			this.LONG_TASK_NAME = '';
			this.TASK_ORG = '';
			this.CUSTOMER_ID = '';
			//this.BILL_TO = '';
			//this.SHIP_TO = '';
			//this.CONTACT = '';
			this.TASK_MANAGER = '';
			this.TASK_COMPLETION_DATE = '';
			this.TASK_START_DATE = '';
			this.BILLABLE_FLAG = '';
			this.CHARGEABLE_FLAG = '';
			this.WORK_TYPE_NAME = '';
			this.COST_IND_RATE_SCH_ID = '';
			this.PM_TASK_REFERENCE = '';
			this.PM_PARENT_TASK_REFERENCE  = '';
			this.ATTRIBUTE_CATEGORY = '';
			this.SEQUENCE_ID = '';
			this.JOB_ID = '';
			this.RECORD_STATUS = '';
			//this.ERROR_MESSAGE = '';
			this.ALLOW_CROSS_CHARGE_FLAG = '';
			this.ATTRIBUTE1 = '';
			this.ATTRIBUTE2 = '';
			this.ATTRIBUTE3 = '';
			this.ATTRIBUTE4 = '';
			this.ATTRIBUTE5 = '';
			this.ATTRIBUTE6 = '';
			this.ATTRIBUTE7 = '';
			this.ATTRIBUTE8 = '';
			this.ATTRIBUTE9 = '';
			this.ATTRIBUTE10 = '';
			this.PROJECT_ID = '';
		
		}

		public OR_Task(pse__Project_Task__c oTask){
			//this.ORG_ID = ECO_Utils_String.NullCheck(oTask.OrgID__c);
			this.PROJECT_NUM = ECO_Utils_String.NullCheck(oTask.ProjectNumber__c);
			Integer level = 1;
			if(oTask.pse__Hierarchy_Depth__c != null){
				level += oTask.pse__Hierarchy_Depth__c.intValue();
			}
			this.WBS_LEVEL = String.valueOf(level);	
			this.TASK_NO = ECO_Utils_String.NullCheck(oTask.ProjectTaskNumber__c);
			this.TASK_NAME = ECO_Utils_String.NullCheck(oTask.Name);
			//this.TASK_DESCRIPTION = ECO_Utils_String.NullCheck(oTask.pse__Description__c);
			this.LONG_TASK_NAME = ECO_Utils_String.NullCheck(oTask.LongProjTaskName__c);
			//this.TASK_ORG = oTask.TaskOrg__c;
			this.TASK_ORG = ECO_Utils_String.NullCheck(oTask.OrgID__c);
			//this.CUSTOMER_ID = ECO_Utils_String.NullCheck(oTask.OracleCustomerId__c);
			this.CUSTOMER_ID = ECO_Utils_String.NullCheck(oTask.TopTaskOwningCustomerOracleId__c);

			//this.BILL_TO = ECO_Utils_String.NullCheck(formatLookupIdForOracle(oTask.BillTo__c));
			//this.SHIP_TO = ECO_Utils_String.NullCheck(formatLookupIdForOracle(oTask.ShipTo__c));
			//this.CONTACT = '';	//TBD
			this.TASK_MANAGER = '';
			this.TASK_COMPLETION_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(oTask.pse__End_Date__c));
			this.TASK_START_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(oTask.pse__Start_Date__c));
			this.BILLABLE_FLAG = ECO_Utils_String.NullCheck(formatBooleanForOracle(oTask.IsBillable__c));
			this.CHARGEABLE_FLAG = ECO_Utils_String.NullCheck(formatBooleanForOracle(oTask.IsChargeable__c));
			this.WORK_TYPE_NAME = ECO_Utils_String.NullCheck(oTask.WorkTypeName__c);
			this.COST_IND_RATE_SCH_ID = ECO_Utils_String.NullCheck(oTask.CostIndRateSCHID__c);
			this.PM_TASK_REFERENCE = String.valueOf(oTask.Id);
			this.PM_PARENT_TASK_REFERENCE  = ECO_Utils_String.NullCheck(String.valueOf(oTask.pse__Parent_Task__c));
			this.ATTRIBUTE_CATEGORY = '';
			this.SEQUENCE_ID = '';
			this.JOB_ID = '';
			this.RECORD_STATUS = '';
			//this.ERROR_MESSAGE = '';
			//this.ALLOW_CROSS_CHARGE_FLAG = ECO_Utils_String.NullCheck(formatBooleanForOracle(oTask.TaxReceivingTask__c));
			this.ALLOW_CROSS_CHARGE_FLAG = ECO_Utils_String.NullCheck(formatBooleanForOracle(oTask.AllowCrossCharge__c));
			
			if(!String.isEmpty(ECO_Utils_String.NullCheck(oTask.AECOMWorkSiteStateCountry__c))){
				this.ATTRIBUTE1 = oTask.AECOMWorkSiteStateCountry__c;
			}else{
				this.ATTRIBUTE1 = ECO_Utils_String.NullCheck(oTask.Attribute1__c);
			}
			
			if(!String.isEmpty(ECO_Utils_String.NullCheck(oTask.AECOMWorkSiteCity__c))){
				this.ATTRIBUTE2 = oTask.AECOMWorkSiteCity__c;
			}else{
				this.ATTRIBUTE2 = ECO_Utils_String.NullCheck(oTask.Attribute2__c);
			}
	
			this.ATTRIBUTE3 = ECO_Utils_String.NullCheck(oTask.Attribute3__c);
			this.ATTRIBUTE4 = ECO_Utils_String.NullCheck(oTask.Attribute4__c);
			this.ATTRIBUTE5 = ECO_Utils_String.NullCheck(oTask.Attribute5__c);
			this.ATTRIBUTE6 = ECO_Utils_String.NullCheck(oTask.Attribute6__c);
			this.ATTRIBUTE7 = ECO_Utils_String.NullCheck(oTask.Attribute7__c);
			this.ATTRIBUTE8 = ECO_Utils_String.NullCheck(oTask.Attribute8__c);
			this.ATTRIBUTE9 = ECO_Utils_String.NullCheck(oTask.Attribute9__c);

			if(!String.isEmpty(ECO_Utils_String.NullCheck(oTask.AECOMTaxOverride__c))){
				this.ATTRIBUTE10 = oTask.AECOMTaxOverride__c;
			}else{
				this.ATTRIBUTE10 = ECO_Utils_String.NullCheck(oTask.Attribute10__c);
			}
			this.PROJECT_ID = ECO_Utils_String.NullCheck(oTask.pse__Project__r.OracleProjectId__c);
		}
	}

	public class OR_ProjectCustomer{
		public string PROJECT_ID {get; set;}
		public string SEGMENT1 {get; set;}
		public string CUSTOMER_ID {get; set;}
		public string CUSTOMER_NUMBER {get; set;}
		public string CUSTOMER_NAME {get; set;}
		public string BILL_TO_ADDRESS_ID {get; set;}
		public string SHIP_TO_ADDRESS_ID {get; set;}
		public string BILLING_CONTACT_ID {get; set;}
		public string DEFAULT_TOP_TASK_CUSTOMER {get; set;}
		public string INVOICE_CURRENCY_CODE {get; set;}
		public string CONTRIBUTION {get; set;}
		public string SEQUENCE_ID {get;set;}
		public string JOB_ID {get;set;}
		public string RECORD_STATUS {get;set;}
		public string ERROR_MESSAGE {get;set;}

		public OR_ProjectCustomer(){
			this.PROJECT_ID = '';
			this.SEGMENT1 = '';
			this.CUSTOMER_ID = '';
			this.CUSTOMER_NUMBER = '';
			this.CUSTOMER_NAME = '';
			this.BILL_TO_ADDRESS_ID = null;
			this.SHIP_TO_ADDRESS_ID = null;
			this.BILLING_CONTACT_ID = '';
			this.DEFAULT_TOP_TASK_CUSTOMER = '';
			this.INVOICE_CURRENCY_CODE = '';
			this.CONTRIBUTION = '';
			this.SEQUENCE_ID = '';
			this.JOB_ID = '';
			this.RECORD_STATUS = '';
			this.ERROR_MESSAGE = '';
		}

		public OR_ProjectCustomer(Project_Site__c oSite){
			this.PROJECT_ID = ECO_Utils_String.NullCheck(oSite.OracleProjectId__c);
			this.SEGMENT1 = ECO_Utils_String.NullCheck(oSite.Segment1__c);
			this.CUSTOMER_ID = ECO_Utils_String.NullCheck(oSite.OracleCustomerID__c);
			this.CUSTOMER_NUMBER = ECO_Utils_String.NullCheck(oSite.OracleCustomerNumber__c);
			this.CUSTOMER_NAME = ECO_Utils_String.NullCheck(oSite.Account_Name__c);

			//allow for overriding of bill to and ship to address ids
			if(String.isEmpty(oSite.BillToAddressID__c)){
				this.BILL_TO_ADDRESS_ID = ECO_Utils_String.NullCheck(oSite.OracleBillToAddressId__c);
			}else{
				this.BILL_TO_ADDRESS_ID = ECO_Utils_String.NullCheck(oSite.BillToAddressID__c);
			}

			if(String.isEmpty(oSite.ShipToAddressID__c)){
				this.SHIP_TO_ADDRESS_ID = ECO_Utils_String.NullCheck(oSite.OracleShipToAddressId__c);
			}else{
				this.SHIP_TO_ADDRESS_ID = ECO_Utils_String.NullCheck(oSite.ShipToAddressID__c);
			}
			
			this.BILLING_CONTACT_ID = ECO_Utils_String.NullCheck(oSite.BillingContactID__c);
			this.DEFAULT_TOP_TASK_CUSTOMER = ECO_Utils_String.NullCheck(formatBooleanForOracle(oSite.Is_Default_Top_Task__c));
			this.INVOICE_CURRENCY_CODE = ECO_Utils_String.NullCheck(oSite.CurrencyIsoCode);
			if(oSite.Contribution__c == null){
				this.CONTRIBUTION = '';
			}else{
				this.CONTRIBUTION = String.valueOf(oSite.Contribution__c);
			}			
			this.SEQUENCE_ID = '';
			//this.JOB_ID = ECO_Utils_String.NullCheck(oSite.JobID__c);
			this.JOB_ID = '';
			this.RECORD_STATUS = '';
			this.ERROR_MESSAGE = '';

		}
	}


/*
	public final Static String[] monthAbbr = new List<String>{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};

	public Static String formatDateForOracle(Date dateIn){
		String result = null;
		if(dateIn != null){
			String dayVal = '';
			if(dateIn.day() < 10){
				dayVal += '0';
			}
			dayVal += String.valueOf(dateIn.day());

			result = dayVal + '-' + monthAbbr.get(dateIn.month() -1) + '-' + String.valueOf(dateIn.year());
		}
		return result;
	}
*/

	public Static String formatDateForOracle(Date dateIn){
		
		if(dateIn != null){
			return String.valueOf(dateIn);
		}
		return null;
	}

	public Static String formatBooleanForOracle(Boolean boolIn){
		String result = null;
		if(boolIn != null){
			if(boolIn){
				result = 'Y';
			}else{
				result = 'N';
			}
		}
		return result;
	}
	
	public Static String formatLookupIdForOracle(Id idIn){
		String result = null;
		if(idIn != null){
			return String.valueOf(idIn);
		}
		return result;
	}
/*
	private Static List<OR_Task> getOracleTaskCollection(List<pse__Project_Task__c> tasks){
		List<OR_TASK> results = new List<OR_TASK>();
		for(pse__Project_Task__c task : tasks){
			results.add(new OR_TASK(task));
		}
		return results;
	}

*/
	private Static List<OR_Task> getOracleTaskCollection(List<pse__Project_Task__c> tasks, pse__Proj__c project){

		Map<String, String> mapBurdenSchedules = new Map<String,String>();
		if(project.CarryingOutOrganization__c != null){
			mapBurdenSchedules = getTaskBurdenSchedule(project.CarryingOutOrganization__r.OUID__c);
		}				

		List<OR_TASK> results = new List<OR_TASK>();
		for(pse__Project_Task__c task : tasks){
			if(!mapBurdenSchedules.isEmpty()){
				if(task.WorkTypeName__c == 'Field Office' && mapBurdenSchedules.containsKey('HA FIELD')){
					task.CostIndRateSCHID__c = mapBurdenSchedules.get('HA FIELD');
				}else if(task.WorkTypeName__c == 'Home Office' && mapBurdenSchedules.containsKey('HA HOME')){
					task.CostIndRateSCHID__c = mapBurdenSchedules.get('HA HOME');
				}
			}
			results.add(new OR_TASK(task));
		}
		return results;
	}

	private Static List<OR_KeyMember> getOracleKeyMemberCollection(List<ProjectTeamMember__c> teamMembers){
		/*
		//have to get oracle employee number and oracle person id values from user
		Map<Id, User> mapUserIdUser = new Map<Id, User>();
		for(ProjectTeamMember__c teamMember : teamMembers){
			if(teamMember.Contact__r.pse__Salesforce_User__c != null){
				mapUserIdUser.put(teamMember.Contact__r.pse__Salesforce_User__c, null);
			}
		}
		if(!mapUserIdUser.isEmpty()){
			List<User> users = [SELECT Id, EmployeeNumber, PersonId__c
								FROM User
								WHERE Id IN :mapUserIdUser.keySet()];
			for(User user : users){
				mapUserIdUser.put(user.Id, user);
			}
		}
*/
		List<OR_KeyMember> results = new List<OR_KeyMember>();
		for(ProjectTeamMember__c teamMember : teamMembers){
			/*
			String oracleEmpNumber = '';
			String oraclePersonId = '';
			if(mapUserIdUser.containsKey(teamMember.Contact__r.pse__Salesforce_User__c)){
				oracleEmpNumber = mapUserIdUser.get(teamMember.Contact__r.pse__Salesforce_User__c).EmployeeNumber;
				oraclePersonId = mapUserIdUser.get(teamMember.Contact__r.pse__Salesforce_User__c).PersonId__c;
			}		
			*/
			results.add(new OR_KeyMember(teamMember));
		}
		return results;
	}

	private Static List<OR_ProjectCustomer> getOracleCustomerCollection(List<Project_Site__c> sites){
		List<OR_ProjectCustomer> results = new List<OR_ProjectCustomer>();
		for(Project_Site__c site : sites){		
			results.add(new OR_ProjectCustomer(site));
		}
		return results;
	}

	public Static List<OR_Classification> getOracleClassificationCollection(pse__Proj__c oProject, Set<String> classificationFields){
		List<OR_Classification> results = new List<OR_Classification>();	
		String projectNumber = oProject.OracleProjectnumber__c;
		String projectId = oProject.OracleProjectId__c;
		Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.pse__Proj__c.fields.getMap();

		Set<String> fieldApiNames = new Set<String>();
		
		for(String classificationField : classificationFields){
			fieldApiNames.add(classificationField.toLowerCase());
		}


		//todo - make this a fieldset maybe
		
		Set<String> classifications_Y_OR_N = new Set<String>();
		classifications_Y_OR_N.add('cleurukrdqualified__c');
		classifications_Y_OR_N.add('claecompmcmflag__c');
		classifications_Y_OR_N.add('claecomprojectinitiative__c');
		classifications_Y_OR_N.add('aecomjointventureproject__c');
		


		for(String fieldApiName : fieldMap.keySet()){
			String currFieldLabel = fieldMap.get(fieldApiName).getDescribe().getLabel().toLowerCase();
			system.debug('currFieldLabel = ' + currFieldLabel);
			if(fieldApiNames.contains(fieldApiName)){	//field is for classification
				
				if(oProject.get(fieldApiName) != null){
					String classCategory = fieldMap.get(fieldApiName).getDescribe().getLabel();
					String classCode = '';
					if(fieldMap.get(fieldApiName).getDescribe().getType() == Schema.DisplayType.Boolean){
						if(fieldApiName.equalsIgnoreCase('clMiningProject__c')){
							classCode = 'Yes';
						}else{
							if((Boolean)oProject.get(fieldApiName) == true){
								if(classifications_Y_OR_N.contains(fieldApiName)){
									classCode = 'Y';
								}else{
									classCode = 'Yes';
								}							
							}else{
								if(classifications_Y_OR_N.contains(fieldApiName)){
									classCode = 'N';
								}else{
									classCode = 'No';
								}
							}
						}
						
					}else if(fieldMap.get(fieldApiName).getDescribe().getType() == Schema.DisplayType.String || fieldMap.get(fieldApiName).getDescribe().getType() == Schema.DisplayType.Picklist){
						classCode = (String)oProject.get(fieldApiName);
					}					
					OR_Classification oracleClassification = new OR_Classification(projectNumber, projectId, classCategory, classCode);
					results.add(oracleClassification);
				}
			}
		}

		//OR_Classification tempClassification = new OR_Classification(projectNumber, projectId, 'AECOM Business Line Segment', 'Water');
		//results.add(tempClassification);
		return results;
	}


	public Static Id createMessageQueueForRequest(Id sProjectId, String sJobName){
		//save to the msg queue that we're attempting a call to the oracle ws
		IntegrationMessageQueue__c msgQueue = new IntegrationMessageQueue__c();
		msgQueue.ErrorMessage__c = '';
		msgQueue.JobName__c = sJobName;
		msgQueue.RecordId__c = sProjectId;
		msgQueue.Status__c = STATUS_INITIATED;
		//msgQueue.OwnerId = '005e0000002Bj3L';
		insert msgQueue;
		return msgQueue.Id;
	}


	
	public Static IntegrationMessageQueue__c getMessageQueue(Id sMessageQueueId){
		IntegrationMessageQueue__c msgQueue = null;
		List<IntegrationMessageQueue__c> messageQueues = [SELECT Id, 
															ErrorMessage__c, 
															Status__c, 
															JobName__c, 
															SuccessMessage__c, 
															RecordId__c
															FROM IntegrationMessageQueue__c
															WHERE Id = :sMessageQueueId];

		if(!messageQueues.isEmpty()){
			msgQueue = messageQueues.get(0);
		}
		return msgQueue;
	}

	public Static String syncProjectOnlyWithOracle(Id sProjectId, String url, Id sMessageQueueId){
		String result = '';

		IntegrationMessageQueue__c messageQueue = getMessageQueue(sMessageQueueId);
		if(messageQueue == null){
			throw new EcoServiceException('Cannot find message queue with Id = ' + sMessageQueueId);
		}
		
		try{

			String jsonPayload = SendProjectOnlyData(sProjectId, sMessageQueueId);
			result = sendRequest(url, jsonPayload);

			if(!String.isEmpty(result)){
				messageQueue.Status__c = STATUS_SENT;
				//messageQueue.SuccessMessage__c = result;
				update messageQueue;
			}else{
				throw new EcoServiceException('No request returned no response!');
			}
					    
			
		}catch(Exception e){
			
			result = e.getMessage();
			messageQueue.ErrorMessage__c = result;
			messageQueue.Status__c = STATUS_ATTEMPTED;
			update messageQueue;
		}
		
	    return result;
	}



	public Static String syncProjectWithOracle(Id sProjectId, String url, Id sMessageQueueId){
		String result = '';

		IntegrationMessageQueue__c messageQueue = getMessageQueue(sMessageQueueId);
		if(messageQueue == null){
			throw new EcoServiceException('Cannot find message queue with Id = ' + sMessageQueueId);
		}
		
		try{

			String jsonPayload = SendProjectData(sProjectId, sMessageQueueId);
			result = sendRequest(url, jsonPayload);

			if(!String.isEmpty(result)){
				messageQueue.Status__c = STATUS_SENT;
				//messageQueue.SuccessMessage__c = result;
				update messageQueue;
			}else{
				throw new EcoServiceException('No request returned no response!');
			}
					    
			
		}catch(Exception e){
			
			result = e.getMessage();
			messageQueue.ErrorMessage__c = result;
			messageQueue.Status__c = STATUS_ATTEMPTED;
			update messageQueue;
		}
		
	    return result;
	}


	public Static String sendProjectNumberRequestToOracle(Id sProjectId, String url, Id sMessageQueueId){
		String result = '';

		IntegrationMessageQueue__c messageQueue = getMessageQueue(sMessageQueueId);
		if(messageQueue == null){
			throw new EcoServiceException('Cannot find message queue with Id = ' + sMessageQueueId);
		}		

		try{
			String jsonPayload = SendProjectNumberData(sProjectId, sMessageQueueId);
			result = sendRequest(url, jsonPayload);

			messageQueue.Status__c = STATUS_SENT;
			update messageQueue;

		}catch(Exception e){			
			result = e.getMessage();
			messageQueue.ErrorMessage__c = result;
			messageQueue.Status__c = STATUS_ATTEMPTED;
			update messageQueue;
		}
		
	    return result;
	}

	
	public Static String sendRequest(String sEndPointUrl, String sJsonPayload){
				
			Http h = new Http();
		    
		    HttpRequest req = new HttpRequest();

		    String restUrl = sEndPointUrl; 		    

		    req.setEndpoint(restUrl);
		    
		    
		    //for POST
		    req.setMethod('POST');
		    String body = 'REQUEST_STRING=' + EncodingUtil.urlEncode(sJsonPayload, 'UTF-8');
		    req.setBody(body);

		    //for GET
		    //req.setMethod('GET');
		    //restUrl += '&REQUEST_STRING=' + EncodingUtil.urlEncode(sJsonPayload, 'UTF-8');

		    /*
		    req.setHeader('Content-Encoding', 'gzip');
		    req.setHeader('Accept-Encoding', 'gzip');
		    */
		    req.setCompressed(true);
			req.setTimeout(30000);
			//req.setClientCertificate(String clientCert, String password)
			req.setClientCertificateName('ECOProjService');

		    // Send the request, and return a response
		    HttpResponse res = h.send(req);

		    system.debug('ECO_Service_ProjectSync.sendRequest request response = ' + res.getBody());

		    String result = res.getBody();

		    //use try catch in case request didn't make it all the way thru (won't be in xml format)
		    if(!String.isEmpty(result)){
		    	result = result.trim();

		    	
			    PICRequestStatus requestStatus = new PICRequestStatus();
			    requestStatus.Status = STATUS_SENT;
			    try{		    	
					requestStatus = parseXMLResponse(result);
				 }catch(Exception e){
			    	throw new EcoServiceException(e.getMessage());
			    	result = e.getMessage();
			    }	
				//if response made it thru and was successfully parsed determine success/fail msg
				if(requestStatus.Status.equalsIgnoreCase(STATUS_SUCCESS)){
					result = 'The request has successfully been submitted! ' + requestStatus.Message + ' ' + requestStatus.Details;
				}else if(requestStatus.Status.equalsIgnoreCase(STATUS_ERROR)){
					result = 'An error has occurred while processing the request! ' + requestStatus.Message + ' ' + requestStatus.Details;
					throw new EcoServiceException(result);	//error gets caught at controller level and displayed to user in pagemessage
				}else{
					//unknown/unhandled status coming back - assume it's an error
					result = 'An error has occurred while processing the request! ' + requestStatus.Message + ' ' + requestStatus.Details;
					throw new EcoServiceException(result);	//error gets caught at controller level and displayed to user in pagemessage
				}		
				
		    }		       		    


		    return result;
	}

	private static String getPrimaryOrgForProject(Id projectId){
		String result = null;
		List<ProjectOrganization__c> projOrgs = [SELECT Id, 
													OrganizationString__r.OrgID__c,
													OrganizationString__r.OUID__c,
													OrganizationString__r.Name 
													FROM ProjectOrganization__c
													 WHERE Project__c = :projectId
													 AND OrgIsActive__c = true
													 AND Type__c = 'Primary'];
		if(!projOrgs.isEmpty()){
			result = projOrgs.get(0).OrganizationString__r.OrgID__c;
			//result = projOrgs.get(0).OrganizationString__r.OUID__c;
		}

		return result;
	}

	public class PICRequestStatus {
		public String Status {get;set;}
		public String Message {get;set;}
		public String Details {get;set;}
	} 
		
	private static PICRequestStatus parseXMLResponse(String xml){
		//example of response xml
		//<?xml version="1.0" encoding="UTF-8"?> <PICRequestStatus> <Status>SUCCESS</Status> <Message></Message> <Details></Details> </PICRequestStatus>

		Dom.Document doc = new Dom.Document();
		doc.load(xml);

		PICRequestStatus requestStatus = new PICRequestStatus();
		String result = '';

		for(dom.XmlNode node : doc.getRootElement().getChildElements()) {
			String nodeName = node.getName().toLowerCase();
		  	if(nodeName =='status') {
		     	requestStatus.Status = node.getText();
		   	}else if(nodeName == 'message') {
				requestStatus.Message = node.getText();
			} else if(nodeName == 'details') {
				requestStatus.Details = node.getText();
			}
		} 

	    return requestStatus;	    
	}


	public static List<IntegrationMessageQueue__c> getProjectSyncHistory(Id projectId, String jobName){
		List<IntegrationMessageQueue__c> msgQueues = [SELECT ErrorMessage__c, JobName__c, RecordCount__c, RecordId__c, Status__c, SuccessMessage__c,
														CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate
														FROM IntegrationMessageQueue__c
														WHERE RecordId__c = :projectId AND Status__c = :STATUS_SUCCESS 
														AND JobName__c = :jobName
														ORDER By LastModifiedDate DESC];

		return msgQueues;
	}

	public static List<IntegrationMessageQueue__c> getProjectSyncHistory(Id projectId, String jobName, Set<String> statuses){
		List<IntegrationMessageQueue__c> msgQueues = [SELECT ErrorMessage__c, JobName__c, RecordCount__c, RecordId__c, Status__c, SuccessMessage__c,
														CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate
														FROM IntegrationMessageQueue__c
														WHERE RecordId__c = :projectId AND Status__c IN :statuses 
														AND JobName__c = :jobName
														ORDER By LastModifiedDate DESC];

		return msgQueues;
	}

	public static Datetime getLastProjectSyncDateTime(Id projectId, String jobName){
		Datetime result = null;
		Set<String> statuses = new Set<String>{ STATUS_SUCCESS };

		List<IntegrationMessageQueue__c> projectSyncHistory = getProjectSyncHistory(projectId, jobName, statuses);
		if(!projectSyncHistory.isEmpty()){
			result = projectSyncHistory.get(0).LastModifiedDate;
		}

		return result;
	}

	public static List<IntegrationMessageQueue__c> getProjectSyncHistory(Id projectId){
		List<IntegrationMessageQueue__c> msgQueues = [SELECT ErrorMessage__c, JobName__c, RecordCount__c, RecordId__c, Status__c, SuccessMessage__c,
														CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate
														FROM IntegrationMessageQueue__c
														WHERE RecordId__c = :projectId AND Status__c = :STATUS_SUCCESS AND JobName__c = :JOBNAME_PROJECT_SYNC
														ORDER By LastModifiedDate DESC];

		return msgQueues;
	}

	public static List<IntegrationMessageQueue__c> getTaskSyncHistory(Id projectId){

		//get project tasks
		Set<Id> taskIds = new Set<Id>();
		List<pse__Project_Task__c> tasks = [SELECT Id 
											FROM pse__Project_Task__c
											WHERE pse__Project__c = :projectId];

		for(pse__Project_Task__c task : tasks){
			taskIds.add(task.Id);
		}


		List<IntegrationMessageQueue__c> msgQueues = [SELECT ErrorMessage__c, JobName__c, RecordCount__c, RecordId__c, Status__c, SuccessMessage__c,
														CreatedById, CreatedBy.Name, CreatedDate, LastModifiedDate
														FROM IntegrationMessageQueue__c
														WHERE RecordId__c IN :taskIds
														ORDER By LastModifiedDate DESC];

		return msgQueues;
	}

	public static Datetime getLastProjectSyncDateTime(Id projectId){
		Datetime result = null;

		List<IntegrationMessageQueue__c> projectSyncHistory = getProjectSyncHistory(projectId);
		if(!projectSyncHistory.isEmpty()){
			result = projectSyncHistory.get(0).LastModifiedDate;
		}

		return result;
	}


	public static List<ProjectTeamMember__c> getProjectManagerForProject(Id projectId){
		
		List<ProjectTeamMember__c> projectManagers = [SELECT Id, Contact__c, Contact__r.Name, Contact__r.pse__Salesforce_User__c, 
													EndDate__c, OracleEmployeeNumber__c,  OraclePersonId__c, 
													ProjectRole__r.Name, ProjectRole__r.Active__c, ProjectRole__r.Type__c,
													Contact__r.User__c
													FROM ProjectTeamMember__c
													WHERE Project__c = :projectId AND 
													ProjectRole__r.Name = 'Project Manager' AND ProjectRole__r.Active__c = true];
		return projectManagers;
	}



	public static void flagProjectTasksWithSyncStatus(String syncStatus, Id sProjectId, DateTime dateFilterVal){
		List<pse__Project_Task__c> lTasks =  GetOracleProjectTaskRecords(sProjectId, dateFilterVal);

		if(!lTasks.isEmpty()){
			for(pse__Project_Task__c task : lTasks){
				task.OracleSyncStatus__c = syncStatus;
			}
			update lTasks;
		}
		
	}


	public static void flagKeymembersWithSyncStatus(String syncStatus, Id sProjectId, DateTime dateFilterVal){
		List<ProjectTeamMember__c> lKeyMembers = GetOracleKeyMemberRecords(sProjectId, dateFilterVal);

		if(!lKeyMembers.isEmpty()){
			for(ProjectTeamMember__c keyMember : lKeyMembers){
				keyMember.OracleSyncStatus__c = syncStatus;
			}
			update lKeyMembers;
		}
		
	}

	public static void flagProjectSitesWithSyncStatus(String syncStatus, Id sProjectId, DateTime dateFilterVal){
		List<Project_Site__c> lProjectSites = GetOracleProjectSiteRecords(sProjectId, dateFilterVal);

		if(!lProjectSites.isEmpty()){
			for(Project_Site__c site : lProjectSites){
				site.OracleSyncStatus__c = syncStatus;
			}
			update lProjectSites;
		}
		
	}



	//Template_Id__c
	public static Map<String, String> getDerivedTemplateInfo(String distributionRule, String ouId){
    	Map<String, String> derivedTemplateInfo = new Map<String,String>();
    	String derivedProjectTemplateId = '';
    	String derivedProjectTemplateName = '';

    	if(ouId == '147'){
    		if(distributionRule == 'COST/WORK'){
				//derivedProjectTemplateId = '1035552'; 
				derivedProjectTemplateId = '1152536'; //new from TS52 refresh
				derivedProjectTemplateName = 'T_ECO_CW_AUS'; 
			}else if(distributionRule == 'WORK/WORK'){
				derivedProjectTemplateId = '1035553'; 
				derivedProjectTemplateName = 'T_ECO_WW_AUS'; 
			}else if(distributionRule == 'COST/EVENT'){
				derivedProjectTemplateId = '1035554'; 
				derivedProjectTemplateName = 'T_ECO_CE_AUS'; 
			}else if(distributionRule == 'EVENT/EVENT'){	
				derivedProjectTemplateId = '1035555'; 
				derivedProjectTemplateName = 'T_ECO_EE_AUS'; 
			}
    	}else if(ouId == '140'){
			if(distributionRule == 'COST/WORK'){
				derivedProjectTemplateId = '1035556'; 
				derivedProjectTemplateName = 'T_ECO_CW_NZ'; 
			}else if(distributionRule == 'WORK/WORK'){
				derivedProjectTemplateId = '1035558'; 
				derivedProjectTemplateName = 'T_ECO_WW_NZ'; 
			}else if(distributionRule == 'COST/EVENT'){
				derivedProjectTemplateId = '1035559'; 
				derivedProjectTemplateName = 'T_ECO_CE_NZ'; 
			}
    	}

    	if(!String.isEmpty(derivedProjectTemplateId) && !String.isEmpty(derivedProjectTemplateName)){
    		derivedTemplateInfo.put(derivedProjectTemplateId, derivedProjectTemplateName);
    	}

    	return derivedTemplateInfo;

    }


    //@future
    public static void initiateTaskSyncNowProcessing(){
    	Set<Id> processedIds = new Set<Id>();
    	ECO_TaskSyncBatch batchSync = new ECO_TaskSyncBatch(JOBNAME_TASK_SYNC_NOW, processedIds);
        Id batchprocessid = Database.executeBatch(batchSync);
    }

    public static void initiateTaskSyncLaterProcessing(){
    	Set<Id> processedIds = new Set<Id>();
    	ECO_TaskSyncBatch batchSync = new ECO_TaskSyncBatch(JOBNAME_TASK_SYNC_LATER, processedIds);
        Id batchprocessid = Database.executeBatch(batchSync);
    }


    //@future (callout=true)
    public static void syncTaskOnly(Id messageQueueId){
    	//get message queue
    	IntegrationMessageQueue__c msgQueue = getMessageQueue(messageQueueId);

    	if(msgQueue != null){
    		Id taskId = Id.valueOf(msgQueue.RecordId__c);
			pse__Project_Task__c task = GetOracleProjectTask(taskId);

			if(task == null){

			}

    		Id projectId = task.pse__Project__c;
    		pse__Proj__c project = GetOracleProjectRecord(projectId);
    		if(project == null){
    			//todo - log error
    		}

    		ProjectMessageWrapper wrapper = new ProjectMessageWrapper();
    		wrapper.PROJECT_HEADER = new OR_Project(project);
    		//wrapper.PROJECT_HEADER.ORG_ID = '147';		
    		wrapper.PROJECT_HEADER.JOB_ID = messageQueueId;

    		List<OR_Task> tasks = new List<OR_Task>();
    		tasks.add(new OR_Task(task));
    		wrapper.WBS_COLLECTION = tasks;


    		wrapper.PROJECT_HEADER.UPDATES_TO_HEADER = 'Y';
			wrapper.PROJECT_HEADER.UPDATES_TO_WBS = 'Y';
			wrapper.PROJECT_HEADER.UPDATES_TO_CLASSIFICATION = 'N';
			wrapper.PROJECT_HEADER.UPDATES_TO_KEYMEMBERS = 'N';
			wrapper.PROJECT_HEADER.UPDATES_TO_CUSTOMERS = 'N';

			
			String response = '';

			try{

				String json_ProjectMessageWrapper = JSON.serializePretty(wrapper);

				system.debug('task sync only json = ' + json_ProjectMessageWrapper);

				//String endPointUrl = 'https://ecodev.aecom.com/OA_HTML/jsp/fnd/xxpic/apps/PicDisconn.jsp?PICAction=SalesIntegration&ebizId=X123456&MESSAGE_TYPE=UPDATE_PROJECT';


                String endPointUrl = 'https://ecodev.aecom.com/OA_HTML/jsp/fnd/PicDisconnSF.jsp?PICAction=SalesIntegration&ebizId=';
                
				if(Test.isRunningtest()){
					response = '<?xml version="1.0" encoding="UTF-8"?><PICRequestStatus><Status>SUCCESS</Status><Message></Message><Details></Details></PICRequestStatus>';
				}else{
					response = sendRequest(endPointUrl, json_ProjectMessageWrapper);
				}
				
				system.debug('syncTaskOnly response success = ' + response);

				if(!String.isEmpty(response)){
					msgQueue.Status__c = STATUS_SENT;
					//messageQueue.SuccessMessage__c = result;
					update msgQueue;

					//update all other pending sync requests for the task just processed
					List<IntegrationMessageQueue__c> otherMsgQueues = [SELECT Id
																		FROM IntegrationMessageQueue__c
																		WHERE RecordId__c = :msgQueue.RecordId__c
																		AND Status__c = :STATUS_INITIATED
																		AND Id != :msgQueue.Id];

					if(!otherMsgQueues.isEmpty()){
						for(IntegrationMessageQueue__c otherMsgQueue : otherMsgQueues){
							otherMsgQueue.Status__c = STATUS_ABORTED;
						}
						update otherMsgQueues;
					}
				}else{
					throw new EcoServiceException('No request returned no response!');
				}
						    
				
			}catch(Exception e){
				
				response = e.getMessage();

				system.debug('syncTaskOnly response error = ' + response);
				msgQueue.ErrorMessage__c = response;
				msgQueue.Status__c = STATUS_ATTEMPTED;
				update msgQueue;
			}


    		/*
			this.FF_PROJECT_ID = '';
			this.ORACLE_PROJECT_ID = '';
			this.MODE = '';
			this.ORACLE_PERSON_ID = '';			
			this.MESSAGE_ID = '';
			this.PROJECT_HEADER = new OR_Project();
			this.WBS_COLLECTION = new list<OR_Task>();
			this.CLASSIFICATION_COLLECTION = new list<OR_Classification>();
			this.KEYMEMBERS_COLLECTION = new list<OR_KeyMember>();
			this.CUSTOMERS_COLLECTION = new list<OR_ProjectCustomer>()
			*/

    	}
    }


    public static pse__Project_Task__c GetOracleProjectTask(Id taskId){
    	pse__Project_Task__c result = null;

		List<pse__Project_Task__c> lTasks = new List<pse__Project_Task__c>([SELECT Id,
																				OrgID__c,
																				ProjectNumber__c,																			
																				ProjectTaskNumber__c,
																				Name,
																				pse__Description__c,
																				LongProjTaskName__c,
																				TaskOrg__c,
																				OracleCustomerId__c,
																				BillTo__c,
																				ShipTo__c,			
																				OwnerId,
																				pse__End_Date__c,
																				pse__Start_Date__c,
																				IsBillable__c,
																				IsChargeable__c,
																				WorkTypeName__c,	
																				pse__Parent_Task__c,	
																				pse__Parent_Task__r.Name,		
																				OracleSyncStatus__c,
																				OracleSyncErrorMessage__c,
																				Attribute1__c,
																				Attribute2__c,
																				Attribute3__c,
																				Attribute4__c,
																				Attribute5__c,
																				Attribute6__c,
																				Attribute7__c,
																				Attribute8__c,
																				Attribute9__c,
																				Attribute10__c,
																				pse__Project__r.OrgID__c,
																				pse__Project__r.OracleProjectnumber__c,
																				pse__Project__r.OracleProjectId__c,
																				CostIndRateSCHID__c,
																				LastModifiedDate,
																				pse__Hierarchy_Depth__c,
																				TaxReceivingTask__c,
																				AECOMTaxOverride__c,
																				AECOMWorkSiteCity__c,
																				AECOMWorkSiteStateCountry__c,
																				AllowCrossCharge__c,
																				TopTaskOwningCustomerOracleId__c																			
																			FROM pse__Project_Task__c
																			WHERE Id = :taskId																			
																			]);

		if(!lTasks.isEmpty()){
			result = lTasks.get(0);
		}
		return result;
	}


	public static void SetupTasksForSync(Set<Id> taskIds, String sJobName){

		List<IntegrationMessageQueue__c> msgQueues = new List<IntegrationMessageQueue__c>();
		for(Id taskId : taskIds){
			IntegrationMessageQueue__c msgQueue = new IntegrationMessageQueue__c();			
			msgQueue.ErrorMessage__c = '';
			msgQueue.JobName__c = sJobName;
			msgQueue.RecordId__c = taskId;
			msgQueue.Status__c = STATUS_INITIATED;
			msgQueues.add(msgQueue);
		}
		if(!msgQueues.isEmpty()){
			insert msgQueues;
		}
	}


	public static void SetupSyncNowTasks(Set<Id> taskIds){
		SetupTasksForSync(taskIds, 'Task Sync Now');
		//kick of batch processing
	}

	public static void SetupSyncLaterTasks(Set<Id> taskIds){
		SetupTasksForSync(taskIds, 'Task Sync Later');
		//tasks will be processed via scheduled apex
	}
	
	public static Map<String, String> getTaskBurdenSchedule(String orgId){
		Map<String, String> results = new Map<String, String>();
		List<BurdenSchedule__c> burdenSchedules = [SELECT CostCode__c, 
													OracleRateScheduleID__c, 
													OracleRateScheduleName__c, 
													OrganizationName__c,
													 OrgID__c
													FROM BurdenSchedule__c
													WHERE OrgID__c = :orgId];

		if(!burdenSchedules.isEmpty()){
			for(BurdenSchedule__c bs : burdenSchedules){
				results.put(bs.CostCode__c, bs.OracleRateScheduleID__c);
			}
		}
		return results;
	}

	public static void validateProject()
	{

	}

	public static void validateProjectTasks()
	{

	}

	public static void validateProjectKeyMembersData()
	{

	}

	public static void validateProjectCustomerData()
	{
		
	}



}