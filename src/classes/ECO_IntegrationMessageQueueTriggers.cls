public without sharing class ECO_IntegrationMessageQueueTriggers {
	public static Boolean run = true;
	
	private static System.LoggingLevel debugLevel = LoggingLevel.INFO;

	private static final String ORACLE_SYNC_STATUS_SUCCESS = 'S';
	private static final String ORACLE_SYNC_STATUS_ERROR = 'E';
	private static final String ORACLE_SYNC_STATUS_PENDING = 'P';
	private static final String ORACLE_SYNC_STATUS_TRANSFER = 'T';
	
	public static void updateProjectNumber (List<IntegrationMessageQueue__c> messages) {
		List<pse__Proj__c> projectsToUpdate = new List<pse__Proj__c>();

		Set<Id> succesfulProjectSyncsIds = new Set<Id>();
		Set<Id> failedProjectSyncsIds = new Set<Id>();
		Map<Id, DateTime> successfulProjectSyncIdLastModDate = new Map<Id, DateTime>();

		for (IntegrationMessageQueue__c imq : messages) {
			if ('Project Number'.equalsIgnoreCase(imq.JobName__c) 
				&& 'Success'.equalsIgnoreCase(imq.Status__c)) {
					system.debug('success project number found');
					//upon successful creation of project in oracle initiated from a project number request in salesforce,
					//both oracle project number and project id will be returned seperated by a "|" (ProjectNumber|ProjectID)
					pse__Proj__c projectToUpdate = new pse__Proj__c();
					projectToUpdate.Id = (Id)imq.RecordId__c;
					String successMsg = imq.SuccessMessage__c;
					if(!String.isEmpty(successMsg)){						
						List<String> oracleValues = successMsg.split('\\|');
						system.debug('successMsg = ' + successMsg);
						system.debug('oracleValues size = ' + oracleValues.size());
						projectToUpdate.OracleProjectnumber__c = oracleValues.get(0);
						if(oracleValues.size() > 1){
							projectToUpdate.OracleProjectId__c = oracleValues.get(1);
						}
						system.debug('OracleProjectnumber__c = ' + projectToUpdate.OracleProjectnumber__c);
						system.debug('OracleProjectId__c = ' + projectToUpdate.OracleProjectId__c);
						projectsToUpdate.add(projectToUpdate);
					}	
			} else if ('Project Sync'.equalsIgnoreCase(imq.JobName__c) ){

				system.debug('DEBUG****: START2');
				if('Success'.equalsIgnoreCase(imq.Status__c)) {
					system.debug('DEBUG****: START3');
					pse__Proj__c projectSuccess = new pse__Proj__c();
					projectSuccess.Id = (Id)imq.RecordId__c;
					projectSuccess.OracleSyncStatus__c = ORACLE_SYNC_STATUS_SUCCESS;
					projectSuccess.OracleSyncErrorMessage__c = null;
					projectsToUpdate.add(projectSuccess);
					succesfulProjectSyncsIds.add(projectSuccess.Id);
					successfulProjectSyncIdLastModDate.put(projectSuccess.Id, imq.LastModifiedDate);
				} else if ('Error'.equalsIgnoreCase(imq.Status__c) || 'Attempted'.equalsIgnoreCase(imq.Status__c)){
					system.debug('DEBUG****: START4');
					pse__Proj__c projectError = new pse__Proj__c();
					projectError.Id = (Id)imq.RecordId__c;
					projectError.OracleSyncStatus__c = ORACLE_SYNC_STATUS_ERROR;
					projectError.OracleSyncErrorMessage__c = imq.ErrorMessage__c;
					projectsToUpdate.add(projectError);
					failedProjectSyncsIds.add(projectError.Id);
				} else if ('Initiated'.equalsIgnoreCase(imq.Status__c)) {
					system.debug('DEBUG****: START5');
					pse__Proj__c projectInitiated = new pse__Proj__c();
					projectInitiated.Id = (Id)imq.RecordId__c;
					projectInitiated.OracleSyncStatus__c = ORACLE_SYNC_STATUS_PENDING;
					projectInitiated.OracleSyncErrorMessage__c = null;
					projectsToUpdate.add(projectInitiated);
				} else if ('Sent'.equalsIgnoreCase(imq.Status__c)) {
					system.debug('DEBUG****: START6');
					pse__Proj__c projectSent = new pse__Proj__c();
					projectSent.Id = (Id)imq.RecordId__c;
					projectSent.OracleSyncStatus__c = ORACLE_SYNC_STATUS_TRANSFER;
					projectSent.OracleSyncErrorMessage__c = imq.ErrorMessage__c;
					projectsToUpdate.add(projectSent);
				}
			}

			/*
			todo - per specs once a project gets created in oracle subsequent webservice commits will have limited sections of payload
			that can be manipulated. If we need to update any flags in the project we can do it here.
			*/

			/*
			NOTE: if an error occurs on the error side the record will be updated with Status__c - "Error" and the ErrorMessage__c should
			should contain the error msg. A workflow will then send an email to the user who initiated the request
			*/
		}

		//Advance status on first successful sync

		system.debug('DEBUG****: HERE');
		if(!succesfulProjectSyncsIds.isEmpty()){
			map<id, pse__Proj__c> mSuccessfulProjects = new map<id, pse__Proj__c>([SELECT Id, RecordTypeId, pse__Stage__c FROM pse__Proj__c WHERE id in :succesfulProjectSyncsIds]);
			system.debug('DEBUG****: HERE2');
			id sPlanning = ECO_Utils_Meta.getRecordTypeId(pse__Proj__c.sObjectType, 'Customer Project (Planning)');
			id sApproved = ECO_Utils_Meta.getRecordTypeId(pse__Proj__c.sObjectType, 'Customer Project (Approved)');

			for(pse__Proj__c oProject : projectsToUpdate){
				system.debug('DEBUG****: HERE3');
				pse__Proj__c oProjectToCheck = mSuccessfulProjects.get(oProject.Id);

				if(ECO_Utils_String.NullChecK(oProjectToCheck.RecordTypeId) == sPlanning){
					oProject.RecordTypeId = sApproved;
					oProject.pse__Stage__c = 'Execution';
				}
			}
		}

		if(!projectsToUpdate.isEmpty()){
			update projectsToUpdate;
		}
		
		//update oracle sync status on related items for successful syncs, current status should be 'T'
		if(!succesfulProjectSyncsIds.isEmpty()){
			updateProjectTasksSyncStatus(succesfulProjectSyncsIds, ORACLE_SYNC_STATUS_TRANSFER, ORACLE_SYNC_STATUS_SUCCESS, successfulProjectSyncIdLastModDate);
			updateKeyMemberSyncStatus(succesfulProjectSyncsIds, ORACLE_SYNC_STATUS_TRANSFER, ORACLE_SYNC_STATUS_SUCCESS, successfulProjectSyncIdLastModDate);
			updateProjectSitesSyncStatus(succesfulProjectSyncsIds, ORACLE_SYNC_STATUS_TRANSFER, ORACLE_SYNC_STATUS_SUCCESS, successfulProjectSyncIdLastModDate);
		}
		
		//update oracle sync status on related items for failed syncs, current status should be 'T'
		if(!failedProjectSyncsIds.isEmpty()){
			updateProjectTasksSyncStatus(failedProjectSyncsIds, ORACLE_SYNC_STATUS_TRANSFER, ORACLE_SYNC_STATUS_ERROR, successfulProjectSyncIdLastModDate);
			updateKeyMemberSyncStatus(failedProjectSyncsIds, ORACLE_SYNC_STATUS_TRANSFER, ORACLE_SYNC_STATUS_ERROR, successfulProjectSyncIdLastModDate);
			updateProjectSitesSyncStatus(failedProjectSyncsIds, ORACLE_SYNC_STATUS_TRANSFER, ORACLE_SYNC_STATUS_ERROR, successfulProjectSyncIdLastModDate);
		}
	}
	
	public static void updatePMOwnerFromKeymembers (List<IntegrationMessageQueue__c> messages) {
		Set<Id> allProjectIds = new Set<Id>();
		for (IntegrationMessageQueue__c imq : messages) {
			if ('Project Number'.equalsIgnoreCase(imq.JobName__c) 
				&& 'Success'.equalsIgnoreCase(imq.Status__c)) {
					allProjectIds.add((Id)imq.RecordId__c);
			}
		}
		
		List<pse__Proj__c> projectWithKeyMembersList = [SELECT Id
																, (SELECT Id
																		, User__c
																		, User__r.ContactId
																		, Role__c 
																	FROM ProjectTeamMembers__r
																	WHERE Role__c = 'Project Manager')  
														FROM pse__Proj__c 
														WHERE Id IN :allProjectIds ];

		for (pse__Proj__c proj : projectWithKeyMembersList) {
			if (!proj.ProjectTeamMembers__r.isEmpty()) {
				ProjectTeamMember__c ptm = proj.ProjectTeamMembers__r[0];
				proj.OwnerId = ptm.User__c;
				proj.pse__Project_Manager__c = ptm.User__r.ContactId;  //This field is a contact
			}
		}
		
		update projectWithKeyMembersList;
	}


	private static void updateProjectTasksSyncStatus(Set<Id> projectIds, String syncSourceStatus, String syncTargetStatus, Map<Id, DateTime> syncDateTimes){
		List<pse__Project_Task__c> lTasks =  [SELECT Id, 
													OracleSyncStatus__c,
													OracleLastSyncDateTime__c,
													pse__Project__c
												FROM pse__Project_Task__c
												WHERE pse__Project__c IN :projectIds
												AND OracleSyncStatus__c = :syncSourceStatus];

		if(!lTasks.isEmpty()){
			for(pse__Project_Task__c task : lTasks){
				task.OracleSyncStatus__c = syncTargetStatus;
				if(syncTargetStatus == ORACLE_SYNC_STATUS_SUCCESS && syncDateTimes.containsKey(task.pse__Project__c)){
					task.OracleLastSyncDateTime__c = syncDateTimes.get(task.pse__Project__c);
				}
			}
			update lTasks;
		}		
	}

	public static void updateKeyMemberSyncStatus(Set<Id> projectIds, String syncSourceStatus, String syncTargetStatus, Map<Id, DateTime> syncDateTimes){
		List<ProjectTeamMember__c> lKeyMembers = [SELECT Id, 
														OracleSyncStatus__c,
														OracleLastSyncDateTime__c,
														Project__c
													FROM ProjectTeamMember__c
													WHERE Project__c IN :projectIds
													AND OracleSyncStatus__c = :syncSourceStatus];

		if(!lKeyMembers.isEmpty()){
			for(ProjectTeamMember__c keyMember : lKeyMembers){
				keyMember.OracleSyncStatus__c = syncTargetStatus;
				if(syncTargetStatus == ORACLE_SYNC_STATUS_SUCCESS && syncDateTimes.containsKey(keyMember.Project__c)){
					keyMember.OracleLastSyncDateTime__c = syncDateTimes.get(keyMember.Project__c);
				}
			}
			update lKeyMembers;
		}
		
	}

	public static void updateProjectSitesSyncStatus(Set<Id> projectIds, String syncSourceStatus, String syncTargetStatus, Map<Id, DateTime> syncDateTimes){
		List<Project_Site__c> lProjectSites = [SELECT Id, 
														OracleSyncStatus__c,
														OracleLastSyncDateTime__c,
														Project__c
													FROM Project_Site__c
													WHERE Project__c IN :projectIds
													AND OracleSyncStatus__c = :syncSourceStatus];

		if(!lProjectSites.isEmpty()){
			for(Project_Site__c site : lProjectSites){
				site.OracleSyncStatus__c = syncTargetStatus;
				if(syncTargetStatus == ORACLE_SYNC_STATUS_SUCCESS && syncDateTimes.containsKey(site.Project__c)){
					site.OracleLastSyncDateTime__c = syncDateTimes.get(site.Project__c);
				}
			}
			update lProjectSites;
		}
		
	}
}