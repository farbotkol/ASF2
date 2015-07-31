public without sharing class ECO_Service_Projects {

	public final Static String STATUS_INITIATED = 'Initiated';	//Connection attempt started
	public final Static String STATUS_ATTEMPTED = 'Attempted';	//Connection attempt failed (time out, or responded with fail code)
	public final Static String STATUS_SENT = 'Sent';				//HTTP Request completed positively
	public final Static String STATUS_ERROR = 'Error';			//Service writes to Message an error
	public final Static String STATUS_SUCCESS = 'Success';		//Service writes to Message with success
	private static Boolean doDataValidation = true;

	public final Static String JOBNAME_PROJECT_SYNC = 'Project Sync';
	public final Static String JOBNAME_PROJECT_NUMBER = 'Project Number';

	public class EcoServiceException extends Exception {}
	
	public static List<pse__Proj__c> getProdjectsForUser (Id userId, Boolean includeClosed, String roleName) {
		Set<String> closedStrings = new Set<String>();
		closedStrings.add('Completed');
		closedStrings.add('Canceled');
		closedStrings.add('Closed');
		
		ECO_Utils_Meta.SelectAll soUtil = new ECO_Utils_Meta.SelectAll();
		soUtil.GetFields('pse__Proj__c');
		String queryString = soUtil.SOQL;
		
		queryString = querystring.replace('FROM pse__Proj__c', '');
		queryString += ' , (SELECT Id';
				queryString += ' , ApprovedCost__c';
				queryString += ' , ApprovedRevenue__c';
				queryString += ' , BudgetVersionDescription__c';
				queryString += ' , BudgetVersionName__c';
				queryString += ' , ForecastedCost__c';
				queryString += ' , ForecastedRevenue__c';
				queryString += ' , Project__c';
				queryString += ' , Status__c';
				queryString += ' , VersionNumber__c';
			queryString += ' FROM BudgetVersions__r';
			queryString += ' )';
			
		queryString += ' FROM pse__Proj__c';
		
		queryString += ' WHERE Id != null';
		
		
		if (!includeClosed) {
			queryString += ' AND pse__Stage__c NOT IN :closedStrings';
		}
		
		/*  Temp commented for Jodi
		if (ECO_Utils_String.NullCheck(roleName) != '') {
			queryString += ' AND Id IN (SELECT Project__c FROM ProjectTeamMember__c WHERE User__c = \''+userId+'\' AND Role__c = :roleName)';
		} else {
			queryString += ' AND Id IN (SELECT Project__c FROM ProjectTeamMember__c WHERE User__c = \''+userId+'\')';
		}
		*/
		
		queryString += ' AND OwnerId = \''+userId+'\'';
		
		system.debug('queryString:  '+queryString);
		
		return Database.query(queryString);
	}
	public static pse__Proj__c getProjectById(Id projectId){
		if(ECO_Utils_String.NullCheck(projectId) == ''){
			throw new EcoServiceException('Project Id Null');
		}

		list<pse__Proj__c> lProjects = new list<pse__Proj__c>([SELECT Id
																		, Name
																		, ProjectOwningOrg__c
																		, BudgetOffline__c																
																		, (SELECT Id
																					, Type__c
																					, OrganizationString__r.OrganizationName__c
																					, OrganizationString__r.GeographyName__c
																					, OrganizationString__r.Region__c
																					, OrganizationString__r.District__c
																					, OrganizationString__r.Department__c
																					, ContributionPercent__c 
																			FROM ProjectOrganizations__r
																			ORDER BY Type__c ASC)
																		 , (SELECT Id
																				 , ApprovedCost__c
																				 , ApprovedRevenue__c
																				 , BudgetVersionDescription__c
																				 , BudgetVersionName__c
																				 , ForecastedCost__c
																				 , ForecastedRevenue__c
																				 , Project__c
																				 , Status__c
																				 , VersionNumber__c
																		 FROM BudgetVersions__r)
															   FROM pse__Proj__c
															   WHERE Id = :projectId]);

		pse__Proj__c oProject = new pse__Proj__c();

		if(lProjects.size() > 0){
			oProject = lProjects.get(0);
		}else{
			throw new EcoServiceException('Project Not Found');
		}

		return oProject;
	}
/*
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

		ProjectMessageWrapper oProjectMessageWrapper = createProjectMessageWrapper(sProjectId, false, false);
		oProjectMessageWrapper.PROJECT_HEADER.JOB_ID = messageQueueId;

		//return json
		string json_ProjectMessageWrapper = JSON.serializePretty(oProjectMessageWrapper);

		return json_ProjectMessageWrapper;
	}

	public static ProjectMessageWrapper createProjectMessageWrapper(Id sProjectId, Boolean isProjectNumberRequest, Boolean blnValidateData){
		doDataValidation = blnValidateData;
		return createProjectMessageWrapper(sProjectId, isProjectNumberRequest);
	}

	public static ProjectMessageWrapper createProjectMessageWrapper(Id sProjectId, Boolean isProjectNumberRequest){
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
			projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = project.PrimaryOrganization__r.OrgID__c;
			//temp hack until I figure out which field should be used
			if(projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID == null){
				//projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = project.ProjectOwningOrg__c;
			}
			if(projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID == null){ 
				projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = getPrimaryOrgForProject(sProjectId);
			}
			projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = ECO_Utils_String.NullCheck(projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID);
			if(isSuresh){
				projectNumberRequest.CARRYING_OUT_ORGANIZATION_ID = '117';
			}

			projectNumberRequest.LONG_NAME = ECO_Utils_String.NullCheck(project.ProjectLongName__c);
			//projectNumberRequest.CONTRACT_TYPE = ECO_Utils_String.NullCheck(project.ContractTypes__c);
			projectNumberRequest.DISTRIBUTION_RULE = ECO_Utils_String.NullCheck(project.DistributionRule__c);	

			//temp hardcoding of templateid and name
			projectNumberRequest.TEMPLATE_ID = project.TemplateId__c;
			if(projectNumberRequest.TEMPLATE_ID == null){
				projectNumberRequest.TEMPLATE_ID = '1037567';
			}
			//projectNumberRequest.TEMPLATE_ID = ECO_Utils_String.NullCheck(projectNumberRequest.TEMPLATE_ID);

			projectNumberRequest.TEMPLATE_NAME = project.TemplateName__c;
			if(projectNumberRequest.TEMPLATE_NAME == null){
				projectNumberRequest.TEMPLATE_NAME = 'T_AUS_ACM_Ecosystem';
			}
			projectNumberRequest.TEMPLATE_NAME = ECO_Utils_String.NullCheck(projectNumberRequest.TEMPLATE_NAME);	

			projectNumberRequest.ORG_ID = project.PrimaryOrganization__r.OrgID__c;
			//temp hack until I figure out which field should be used
			if(projectNumberRequest.ORG_ID == null){ 
				//projectNumberRequest.ORG_ID = project.ProjectOwningOrg__c;
			}
			if(projectNumberRequest.ORG_ID == null){ 
				projectNumberRequest.ORG_ID = getPrimaryOrgForProject(sProjectId);
			}
			projectNumberRequest.ORG_ID = ECO_Utils_String.NullCheck(projectNumberRequest.ORG_ID);
			//if(isSuresh){
				projectNumberRequest.ORG_ID = '147';
			//}

			projectNumberRequest.PM_PROJECT_REFERENCE = project.Id;	
			projectNumberRequest.START_DATE = ECO_Utils_String.NullCheck(formatDateForOracle(project.pse__Start_Date__c));
			projectNumberRequest.COST_IND_RATE_SCH_ID = '6746';	//todo - map SFDC field
			projectNumberRequest.PROJECT_STATUS = ECO_Utils_String.NullCheck(project.pse__Stage__c);
			
			projectNumberRequest.PROJECT_ID = ECO_Utils_String.NullCheck(project.OracleProjectId__c);	

			oProjectMessageWrapper.PROJECT_HEADER = projectNumberRequest;


		}else{

			Datetime lastProjectSyncDateTime = getLastProjectSyncDateTime(project.Id);
			if(lastProjectSyncDateTime == NULL){
				//use a temp date in the past to make querying related items easier
				lastProjectSyncDateTime = Datetime.newInstance(1900, 1, 1);
			}
			
			oProjectMessageWrapper.PROJECT_HEADER = new OR_Project(project);

			oProjectMessageWrapper.PROJECT_HEADER.ORG_ID = '147';

			//todo - determine if project was modified
			oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_HEADER = 'Y';

			//todo - deterimine if tasks were modified
			oProjectMessageWrapper.WBS_COLLECTION = getOracleTaskCollection(GetOracleProjectTaskRecords(sProjectId, lastProjectSyncDateTime));		
			if(!oProjectMessageWrapper.WBS_COLLECTION.isEmpty()){
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_WBS = 'Y';
			}

			//todo - determine if keymembers were modified
			oProjectMessageWrapper.KEYMEMBERS_COLLECTION = getOracleKeyMemberCollection(GetOracleKeyMemberRecords(sProjectId, lastProjectSyncDateTime));
			if(!oProjectMessageWrapper.KEYMEMBERS_COLLECTION.isEmpty()){
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_KEYMEMBERS = 'Y';


				if(isSuresh){
					for(OR_KeyMember keymember : oProjectMessageWrapper.KEYMEMBERS_COLLECTION){
						keymember.PERSON_ID = '9903';
					}					
				}
			}

	
			Set<String> projectClassificationFieldApiNames = ECO_Utils_sObject.getFieldSetMembers('ECO_OracleClassificationFields', 'pse__Proj__c');

			system.debug('projectClassificationFieldApiNames size ' + projectClassificationFieldApiNames.size());
			oProjectMessageWrapper.CLASSIFICATION_COLLECTION = getOracleClassificationCollection(GetOracleProjectClassificationValues(sProjectId, projectClassificationFieldApiNames), projectClassificationFieldApiNames);
			if(!oProjectMessageWrapper.CLASSIFICATION_COLLECTION.isEmpty()){
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_CLASSIFICATION = 'Y';
			}

			oProjectMessageWrapper.CUSTOMERS_COLLECTION = getOracleCustomerCollection(GetOracleProjectSiteRecords(sProjectId, lastProjectSyncDateTime));
			if(!oProjectMessageWrapper.CUSTOMERS_COLLECTION.isEmpty()){
				oProjectMessageWrapper.PROJECT_HEADER.UPDATES_TO_CUSTOMERS = 'Y';


				if(isSuresh){
					for(OR_ProjectCustomer customer : oProjectMessageWrapper.CUSTOMERS_COLLECTION){
						customer.SHIP_TO_ADDRESS_ID = '177579';
						customer.CUSTOMER_ID = '153281';
						customer.BILLING_CONTACT_ID = '274168';
						customer.BILL_TO_ADDRESS_ID = '177579';
					}
				}
			}

		}		

		return oProjectMessageWrapper;
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

	/*
	public static string TestProxy(string url){
		Http h = new Http();

	    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(url);
	    req.setMethod('GET');

	    // Send the request, and return a response
	    HttpResponse res = h.send(req);

	    system.debug(res.getBody());


	    return res.getBody();
	}
*/

/*
	public static pse__Proj__c GetOracleProjectRecord(Id sProjectId){
		
		list<pse__Proj__c> lProjects = new list<pse__Proj__c>([SELECT OracleProjectnumber__c,
																		Segment1__c,
																		Name,
																		pse__Project_Type__c,
																		PrimaryOrganization__r.OrganizationName__c,
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
																		PrimaryOrganization__r.OrgID__c,
																		PrimaryOrganization__r.Name,
																		ProjectOwningOrg__c,
																		OracleProjectId__c,
																		OracleCustomerNumber__c	
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


	public static List<pse__Project_Task__c> GetOracleProjectTaskRecords(Id sProjectId, Datetime dateFilterVal){
		List<pse__Project_Task__c> lTasks = new List<pse__Project_Task__c>([SELECT Id,
																				OrgID__c,
																				ProjectNumber__c,																			
																				ProjectTaskNumber__c,
																				Name,
																				pse__Description__c,
																				LongTaskName__c,
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
																				LastModifiedDate
																			FROM pse__Project_Task__c
																			WHERE pse__Project__c = :sProjectId
																			AND LastModifiedDate >= :dateFilterVal
																			]);

		return lTasks;
	}


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
																					OraclePersonId__c
																				FROM ProjectTeamMember__c
																				WHERE Project__c = :sProjectId
																				AND ProjectRole__r.Active__c = true]);
		return lTeamMembers;
	}


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
																					OracleEmployeeNumber__c,
																					OraclePersonId__c
																				FROM ProjectTeamMember__c
																				WHERE Project__c = :sProjectId
																				AND ProjectRole__r.Type__c = 'Key Member'
																				AND ProjectRole__r.Active__c = true		
																				AND LastModifiedDate >= :dateFilterVal																		
																				]);
		return lTeamMembers;
	}

	public static List<ProjectTeamMember__c> GetOracleKeyMemberRecords(Id sProjectId){
		Id keyMemberRecordTypeId = ECO_Utils_sObject.getRecordTypeId(ProjectTeamMember__c.sObjectType, 'Key Member');
		if(keyMemberRecordTypeId == null){
			throw new EcoServiceException('RecordType \'Key Member\' was not found for SObjectType \'ProjectTeamMember__c\'.');							
		}						

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
																					OraclePersonId__c
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
																				OracleSyncErrorMessage__c
																		FROM Project_Site__c
																		WHERE Project__c = :sProjectId
																		AND LastModifiedDate >= :dateFilterVal
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
			this.PROJECT_ID = ECO_Utils_String.NullCheck(oProject.OracleProjectId__c);
			this.SEGMENT1 = ECO_Utils_String.NullCheck(oProject.Segment1__c);
			this.PROJECT_NAME = ECO_Utils_String.NullCheck(oProject.Name);
			this.PROJECT_TYPE = ECO_Utils_String.NullCheck(oProject.pse__Project_Type__c);
			//this.CARRYING_OUT_ORGANIZATION_ID = oProject.PrimaryOrganization__c;
			this.CARRYING_OUT_ORGANIZATION_ID = ECO_Utils_String.NullCheck(oProject.PrimaryOrganization__r.OrgID__c);
			this.PROJECT_STATUS = ECO_Utils_String.NullCheck(oProject.pse__Stage__c).toUpperCase();
			this.DESCRIPTION = ECO_Utils_String.NullCheck(oProject.ProjectDescription__c);
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
			
			//temp hardcoding of templateid and name
			this.TEMPLATE_ID = oProject.TemplateId__c;
			if(this.TEMPLATE_ID == null){
				this.TEMPLATE_ID = '1037567';
			}
			this.TEMPLATE_NAME = oProject.TemplateName__c;
			if(this.TEMPLATE_NAME == null){
				this.TEMPLATE_NAME = 'T_AUS_ACM_Ecosystem';
			}

			//this.COST_IND_RATE_SCH_ID  = '';
			this.COST_IND_RATE_SCH_ID = '6746';	//todo - map SFDC field
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
			//this.ORG_ID = oProject.PrimaryOrganization__r.OrganizationName__c;
			this.ORG_ID = ECO_Utils_String.NullCheck(oProject.OrgID__c);
			this.PM_PROJECT_REFERENCE = ECO_Utils_String.NullCheck(oProject.Id);			
			this.PROJECT_CURRENCY_CODE = '';
			this.PROJFUNC_CURRENCY_CODE = '';
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
			this.PROJECT_NUMBER = ECO_Utils_String.NullCheck(oProjectTeamMember.Project__r.OracleProjectnumber__c);
			this.PROJECT_ID = ECO_Utils_String.NullCheck(oProjectTeamMember.Project__r.OracleProjectId__c);
		
			//use these when we get updated user and contact data
			//this.EMPLOYEE_NUMBER = ECO_Utils_String.NullCheck(oProjectTeamMember.OracleEmployeeNumber__c);
			//this.PERSON_ID = ECO_Utils_String.NullCheck(oProjectTeamMember.OraclePersonId__c);

			//these fields will allow input of values for testing
			this.EMPLOYEE_NUMBER = ECO_Utils_String.NullCheck(oProjectTeamMember.Employee_number__c);
			this.PERSON_ID = ECO_Utils_String.NullCheck(oProjectTeamMember.PersonId__c);
	
			String roleName = ECO_Utils_String.NullCheck(oProjectTeamMember.ProjectRole__r.Name);
			this.PROJECT_ROLE_TYPE_M = roleName.toUpperCase();
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
			this.WBS_LEVEL = '';	//TBD
			this.TASK_NO = ECO_Utils_String.NullCheck(oTask.ProjectTaskNumber__c);
			this.TASK_NAME = ECO_Utils_String.NullCheck(oTask.Name);
			//this.TASK_DESCRIPTION = ECO_Utils_String.NullCheck(oTask.pse__Description__c);
			this.LONG_TASK_NAME = ECO_Utils_String.NullCheck(oTask.LongTaskName__c);
			//this.TASK_ORG = oTask.TaskOrg__c;
			this.TASK_ORG = ECO_Utils_String.NullCheck(oTask.pse__Project__r.OrgID__c);
			this.CUSTOMER_ID = ECO_Utils_String.NullCheck(oTask.OracleCustomerId__c);
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
			this.ALLOW_CROSS_CHARGE_FLAG = '';
			this.ATTRIBUTE1 = ECO_Utils_String.NullCheck(oTask.Attribute1__c);
			this.ATTRIBUTE2 = ECO_Utils_String.NullCheck(oTask.Attribute2__c);
			this.ATTRIBUTE3 = ECO_Utils_String.NullCheck(oTask.Attribute3__c);
			this.ATTRIBUTE4 = ECO_Utils_String.NullCheck(oTask.Attribute4__c);
			this.ATTRIBUTE5 = ECO_Utils_String.NullCheck(oTask.Attribute5__c);
			this.ATTRIBUTE6 = ECO_Utils_String.NullCheck(oTask.Attribute6__c);
			this.ATTRIBUTE7 = ECO_Utils_String.NullCheck(oTask.Attribute7__c);
			this.ATTRIBUTE8 = ECO_Utils_String.NullCheck(oTask.Attribute8__c);
			this.ATTRIBUTE9 = ECO_Utils_String.NullCheck(oTask.Attribute9__c);
			this.ATTRIBUTE10 = ECO_Utils_String.NullCheck(oTask.Attribute10__c);
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
		public double CONTRIBUTION {get; set;}
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
			this.BILL_TO_ADDRESS_ID = '';
			this.SHIP_TO_ADDRESS_ID = '';
			this.BILLING_CONTACT_ID = '';
			this.DEFAULT_TOP_TASK_CUSTOMER = '';
			this.INVOICE_CURRENCY_CODE = '';
			this.CONTRIBUTION = 0.0;
			this.SEQUENCE_ID = '';
			this.JOB_ID = '';
			this.RECORD_STATUS = '';
			this.ERROR_MESSAGE = '';
		}

		public OR_ProjectCustomer(Project_Site__c oSite){
			this.PROJECT_ID = ECO_Utils_String.NullCheck(oSite.Project__r.OracleProjectId__c);
			this.SEGMENT1 = ECO_Utils_String.NullCheck(oSite.Segment1__c);
			this.CUSTOMER_ID = ECO_Utils_String.NullCheck(oSite.OracleCustomerID__c);
			this.CUSTOMER_NUMBER = ECO_Utils_String.NullCheck(oSite.OracleCustomerNumber__c);
			this.CUSTOMER_NAME = ECO_Utils_String.NullCheck(oSite.Account_Name__c);
			this.BILL_TO_ADDRESS_ID = ECO_Utils_String.NullCheck(oSite.BillToAddressID__c);
			this.SHIP_TO_ADDRESS_ID = ECO_Utils_String.NullCheck(oSite.ShipToAddressID__c);
			this.BILLING_CONTACT_ID = ECO_Utils_String.NullCheck(oSite.BillingContactID__c);
			this.DEFAULT_TOP_TASK_CUSTOMER = ECO_Utils_String.NullCheck(formatBooleanForOracle(oSite.Is_Default_Top_Task__c));
			this.INVOICE_CURRENCY_CODE = ECO_Utils_String.NullCheck(oSite.CurrencyIsoCode);
			this.CONTRIBUTION = ECO_Utils_String.NullCheck(oSite.Contribution__c);
			this.SEQUENCE_ID = '';
			this.JOB_ID = ECO_Utils_String.NullCheck(oSite.JobID__c);
			this.RECORD_STATUS = '';
			this.ERROR_MESSAGE = '';

		}
	}

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

	private Static List<OR_Task> getOracleTaskCollection(List<pse__Project_Task__c> tasks){
		List<OR_TASK> results = new List<OR_TASK>();
		for(pse__Project_Task__c task : tasks){
			results.add(new OR_TASK(task));
		}
		return results;
	}

	private Static List<OR_KeyMember> getOracleKeyMemberCollection(List<ProjectTeamMember__c> teamMembers){
		

		List<OR_KeyMember> results = new List<OR_KeyMember>();
		for(ProjectTeamMember__c teamMember : teamMembers){
			
			results.add(new OR_KeyMember(teamMember));
		}
		return results;
	}

	private Static List<OR_ProjectCustomer> getOracleCustomerCollection(List<Project_Site__c> sites){
		List<OR_ProjectCustomer> results = new List<OR_ProjectCustomer>();
		for(Project_Site__c site : sites){
			if(doDataValidation){
				//validation for required fields 
				if(site.ShipToAddressID__c == null){
					throw new EcoServiceException('Related project site ' + site.Id + ' cannot have an empty Ship To Address ID value!');
				}else if(site.BillToAddressID__c == null){
					throw new EcoServiceException('Related project site ' + site.Id + ' cannot have an empty Bill To Address ID value!');
				}else if(site.BillingContactID__c == null){
					throw new EcoServiceException('Related project site ' + site.Id + ' cannot have an empty Billing Contact ID value!');
				} 
			}
		
			results.add(new OR_ProjectCustomer(site));
		}
		return results;
	}

	private Static List<OR_Classification> getOracleClassificationCollection(pse__Proj__c oProject, Set<String> classificationFields){
		List<OR_Classification> results = new List<OR_Classification>();	
		String projectNumber = oProject.OracleProjectnumber__c;
		String projectId = oProject.OracleProjectId__c;
		Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.pse__Proj__c.fields.getMap();

		Set<String> fieldApiNames = new Set<String>();
		
		for(String classificationField : classificationFields){
			fieldApiNames.add(classificationField.toLowerCase());
		}

		for(String fieldApiName : fieldMap.keySet()){
			String currFieldLabel = fieldMap.get(fieldApiName).getDescribe().getLabel().toLowerCase();
			system.debug('currFieldLabel = ' + currFieldLabel);
			if(fieldApiNames.contains(fieldApiName)){	//field is for classification
				
				if(oProject.get(fieldApiName) != null){
					String classCategory = fieldMap.get(fieldApiName).getDescribe().getLabel();
					String classCode = '';
					if(fieldMap.get(fieldApiName).getDescribe().getType() == Schema.DisplayType.Boolean){
						if((Boolean)oProject.get(fieldApiName) == true){
							classCode = 'Y';
						}else{
							classCode = 'N';
						}
					}else if(fieldMap.get(fieldApiName).getDescribe().getType() == Schema.DisplayType.String || fieldMap.get(fieldApiName).getDescribe().getType() == Schema.DisplayType.Picklist){
						classCode = (String)oProject.get(fieldApiName);
					}					
					OR_Classification oracleClassification = new OR_Classification(projectNumber, projectId, classCategory, classCode);
					results.add(oracleClassification);
				}
			}
		}

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


	@TestVisible
	private Static IntegrationMessageQueue__c getMessageQueue(Id sMessageQueueId){
		IntegrationMessageQueue__c msgQueue = null;
		List<IntegrationMessageQueue__c> messageQueues = [SELECT Id, ErrorMessage__c, Status__c, JobName__c, SuccessMessage__c
															FROM IntegrationMessageQueue__c
															WHERE Id = :sMessageQueueId];

		if(!messageQueues.isEmpty()){
			msgQueue = messageQueues.get(0);
		}
		return msgQueue;
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

		    
		    req.setCompressed(true);
			req.setTimeout(30000);

		    // Send the request, and return a response
		    HttpResponse res = h.send(req);

		    system.debug(res.getBody());

		    String result = res.getBody();

		    //use try catch in case request didn't make it all the way thru (won't be in xml format)
		    if(!String.isEmpty(result)){
			    PICRequestStatus requestStatus = new PICRequestStatus();
			    requestStatus.Status = STATUS_SENT;
			    try{		    	
					requestStatus = parseXMLResponse(result.trim());
				 }catch(Exception e){
			    	
			    }	
				//if response made it thru and was successfully parsed determine success/fail msg
				if(requestStatus.Status.equalsIgnoreCase(STATUS_SUCCESS)){
					result = 'The request has successfully been submitted! ' + requestStatus.Message + ' ' + requestStatus.Details;
				}else if(requestStatus.Status.equalsIgnoreCase(STATUS_ERROR)){
					result = 'An error has occurred while processing the request! ' + requestStatus.Message + ' ' + requestStatus.Details;
					throw new EcoServiceException(result);	//error gets caught at controller level and displayed to user in pagemessage
				}		
		    }		       		    

		    return result;
	}

	private static String getPrimaryOrgForProject(Id projectId){
		String result = null;
		List<ProjectOrganization__c> projOrgs = [SELECT Id, OrganizationString__r.OrgID__c 
													FROM ProjectOrganization__c
													 WHERE Project__c = :projectId
													 AND OrgIsActive__c = true
													 AND Type__c = 'Primary'];
		if(!projOrgs.isEmpty()){
			result = projOrgs.get(0).OrganizationString__r.OrgID__c;
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

		//Dom.Document doc = res.getBodyDocument();

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
													ProjectRole__r.Name, ProjectRole__r.Active__c, ProjectRole__r.Type__c
													FROM ProjectTeamMember__c
													WHERE Project__c = :projectId AND 
													ProjectRole__r.Name = 'Project Manager' AND ProjectRole__r.Active__c = true];
		return projectManagers;
	}
*/
}