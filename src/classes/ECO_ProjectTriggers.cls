public without sharing class ECO_ProjectTriggers {
	public static Boolean run = true;
	public static Set<String> executedMethods = new Set<String>();

	public static void setOwner(list<pse__Proj__c> lstProject){
		for(pse__Proj__c p:lstProject){
			if(p.pse__Stage__c == 'Approved'){
				if(p.Project_Manager_User__c != null){
					p.ownerid = p.Project_Manager_User__c;
				}
			}
		}
	}

	public static void permissionGanttViewEditToOwner(Map<Id, pse__Proj__c> oldMap, List<pse__Proj__c> newList, Boolean isInsert) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PROJ_PermissionGantt')) {
			return;
		}        

		List<pse__Proj__c> toCreate = new List<pse__Proj__c>();

		Set<Id> permissionIds = new Set<Id>();
		Map<Id, Id> permissionMap = new Map<Id, Id>();

		for (pse__Proj__c project : newList) {
			pse__Proj__c oldProject = oldMap.get(project.id);

			if (project.Owner_Permission_Control__c == null) {
				if ((isInsert) || (project.OwnerId != oldProject.OwnerId)) {
					toCreate.add(project);
				}
			} else if (project.OwnerId != oldProject.OwnerId) {
				permissionIds.add(project.Owner_Permission_Control__c);
				permissionMap.put(project.Owner_Permission_Control__c, project.OwnerId);
			}
		}

		List<pse__Permission_Control__c> newPermissions = new List<pse__Permission_Control__c>();

		for (pse__Proj__c project : toCreate) {
			pse__Permission_Control__c permission = new pse__Permission_Control__c();

			permission.AccessReason__c = 'Project Owner';
			permission.pse__Edit_Task_Manager__c = true;
			permission.pse__Project__c = project.id;
			permission.pse__Start_Date__c = Date.today();
			permission.pse__User__c = project.OwnerId;
			permission.pse__View_Task_Manager__c = true;

			newPermissions.add(permission);
		}

		insert newPermissions;

		List<pse__Permission_Control__c> updatePermissions = [select id, pse__User__c, AccessReason__c from pse__Permission_Control__c where AccessReason__c = 'Project Owner' and id in :permissionIds];

		for (pse__Permission_Control__c permission : updatePermissions) {
			permission.pse__User__c = permissionMap.get(permission.id);
		}

		update updatePermissions;
	}

	public static void setCAMEmail(list<pse__Proj__c> lstProject){
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PROJ_CAMEmail')) {
			return;
		}        

		set<id> acctIDs  = new set<id>();

		for(pse__Proj__c p: lstProject){
			acctIDs.add(p.pse__Account__c);
		}

		map<id, account> mapAcct = new map<id, account>([select id, Account_Manager__r.Email__c from account where id IN: acctIDs AND Account_Manager__c <> null AND Account_Manager__r.Email__c <> null]);

		if(mapAcct.size() >= 1){
			for(pse__Proj__c p:lstProject){
				if(mapAcct.containsKey(p.pse__Account__c)){
					p.ClientAccountManagerEmail__c = mapAcct.get(p.pse__Account__c).Account_Manager__r.Email__c;
				}
			}
		}
	}

	public static void handleFundingLevelFlagChanges(Map<Id, pse__Proj__c> oldProjectsMap, Map<Id, pse__Proj__c> newProjectsMap)
	{
		if (executedMethods.contains('handleFundingLevelFlagChanges')) return;
		executedMethods.add('handleFundingLevelFlagChanges');

		List<Id> projectsToDeleteFunding = new List<Id>();
		for(pse__Proj__c project:newProjectsMap.values())
		{
			if(project.ProjectLevelFundingFlag__c != oldProjectsMap.get(project.Id).ProjectLevelFundingFlag__c)
				projectsToDeleteFunding.add(project.Id);	
		}
		list<Funding__c> fundings = [select Id from Funding__c where Project__c in :projectsToDeleteFunding];

		if(!fundings.isEmpty())
			delete fundings;
	}
	
	public static void indetifyChangeManagerRelatedUpdates(map<Id, pse__Proj__c> oldProjectMap, list<pse__Proj__c> updatedProjects)
	{
		set<String> classificationsFieldSet = new set<String>();
		set<String> safetyHealthEnvFieldSet = new set<String>();
		set<String> documentManagementFieldSet = new set<String>();
		set<String> projectStatusFieldSet = new set<String>();
		
		for(Schema.FieldSetMember field :Schema.SObjectType.pse__Proj__c.fieldSets.getMap().get('ECO_OracleClassificationFields').getFields()){
    		classificationsFieldSet.add(field.getFieldPath());
		}
		
		for(Schema.FieldSetMember field :Schema.SObjectType.pse__Proj__c.fieldSets.getMap().get('ECO_SafetyHealthEnvFields').getFields()){
    		safetyHealthEnvFieldSet.add(field.getFieldPath());
		}

		for(Schema.FieldSetMember field :Schema.SObjectType.pse__Proj__c.fieldSets.getMap().get('ECO_DocumentManagementFields').getFields()){
    		documentManagementFieldSet.add(field.getFieldPath());
		}
		
		for(Schema.FieldSetMember field :Schema.SObjectType.pse__Proj__c.fieldSets.getMap().get('ECO_ProjectStatusFields').getFields()){
    		projectStatusFieldSet.add(field.getFieldPath());
		}
		
		for(pse__Proj__c project:updatedProjects)
		{
			//check classifications
			for(String fieldName:classificationsFieldSet)
			{
				if(oldProjectMap.get(project.Id).get(fieldName) != project.get(fieldName))
				{
					project.ChangeManagerIsChangedClass__c = true;
					project.ChangeManagerClassUpdatedDate__c = DateTime.now();
					project.ChangeManagerClassUpdatedBy__c = project.LastModifiedById;
					break;
				}
			}
			
			//check safety and health
			for(String fieldName:safetyHealthEnvFieldSet)
			{
				if(oldProjectMap.get(project.Id).get(fieldName) != project.get(fieldName))
				{
					project.ChangeManagerIsChangedSHE__c = true;
					project.ChangeManagerSafetyUpdatedDate__c = DateTime.now();
					project.ChangeManagerSafetyUpdatedBy__c = project.LastModifiedById;
					break;
				}
			}
			//check document management
			for(String fieldName:documentManagementFieldSet)
			{
				if(oldProjectMap.get(project.Id).get(fieldName) != project.get(fieldName))
				{
					project.ChangeManagerIsChangedDocManage__c = true;
					project.ChangeManagerDocManageUpdatedDate__c = DateTime.now();
					project.ChangeManagerDocManageUpdatedBy__c = project.LastModifiedById;
					break;
				}	
			}	
			
			//prorject closure
			for(String fieldName:projectStatusFieldSet)
			{
				if(oldProjectMap.get(project.Id).get(fieldName) != project.get(fieldName))
				{
					if(project.RequestedProjectStatus__c == 'Closed')
					{
						project.CMProjectClosureIsChanged__c = true;
						project.CMProjectOnHoldIsChanged__c = false;
					}
					else
					{
						project.CMProjectOnHoldIsChanged__c = true;
						project.CMProjectClosureIsChanged__c = false;
					}
					project.ChangeManagerProjectStatusUpdatedDate__c = DateTime.now();
					project.ChangeManagerProjectStatusUpdatedBy__c = project.LastModifiedById;
					break;
				}					
			}				
		}
	}

	public static void maintainEscalationAlerts (Map<Id, pse__Proj__c> projOldMap, Map<Id, pse__Proj__c> projNewMap) {
		if (executedMethods.contains('maintainEscalationAlerts')) return;
		executedMethods.add('maintainEscalationAlerts');

		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PROJ_Alerts')) {
			return;
		}
		
		Map<Id, List<PortalMessage__c>> userMessages = new Map<Id, List<PortalMessage__c>>();
		Set<Date> escalationDates = new Set<Date>();
		
		
		if (projOldMap != null) {
			for (pse__Proj__c proj : projOldMap.values()) {
				userMessages.put(proj.OwnerId, new List<PortalMessage__c>());
				
				if (proj.EscalationDate__c != null) {
					escalationDates.add(proj.EscalationDate__c.addDays(-30));
				}
			}
		}
		
		if (projNewMap != null) {
			for (pse__Proj__c proj : projNewMap.values()) {
				userMessages.put(proj.OwnerId, new List<PortalMessage__c>());
			}
		}
		
		alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);
		
		// Building our map of user to existing portal messages
		for (User u : [SELECT Id
							, (SELECT Id
									, StartDate__c
								FROM PortalMessages__r
								WHERE RecordTypeId = :alertRecordTypeId
									AND IsEscalationAlert__c = true)
						FROM User
						WHERE Id IN :userMessages.keySet()]) {
			if (!u.PortalMessages__r.isEmpty()) {
				userMessages.get(u.Id).addAll(u.PortalMessages__r);
			}
		}
		
		// Setup done, let's do the work now....
		
		List<PortalMessage__c> messagesToDelete = new List<PortalMessage__c>();
		List<PortalMessage__c> messagesToInsert = new List<PortalMessage__c>();
		
		for (pse__Proj__c proj : projNewMap.values()) {
			// If this is an update, and the dates are the same, assume everything is okay and don't do anything
			if (projOldMap != null 
				&& proj.EscalationDate__c == projOldMap.get(proj.Id).EscalationDate__c) {
					continue;
			}
			
			// If this is an insert, and escalationDate is not null, create a new alert
			if (projOldMap == null
				&& proj.EscalationDate__c != null) {
					messagesToInsert.add(createNewAlert(proj, proj.EscalationDate__c.addDays(-30), 'Escalation Date Approaching for '+proj.Name));
					messagesToInsert.add(createNewAlert(proj, proj.EscalationDate__c.addDays(15), 'Set new Escalation Date for '+proj.Name));
			}
			
			// If this is an update, and the dates mismatch, we're going to wipe everything and replace it with new stuff
			if (projOldMap != null 
				&& proj.EscalationDate__c != projOldMap.get(proj.Id).EscalationDate__c) {
					messagesToDelete.addAll(userMessages.get(proj.OwnerId));
					
					messagesToInsert.add(createNewAlert(proj, proj.EscalationDate__c.addDays(-30), 'Escalation Date Approaching for '+proj.Name));
					messagesToInsert.add(createNewAlert(proj, proj.EscalationDate__c.addDays(15), 'Set new Escalation Date for '+proj.Name));
			}
		}
		
		if (!messagesToDelete.isEmpty()) {
			delete messagesToDelete;
		}
		
		if (!messagesToInsert.isEmpty()) {
			insert messagesToInsert;
		}
	}
	
	private static Id alertRecordTypeId;
	
	private static PortalMessage__c createNewAlert (pse__Proj__c proj, Date theDate, String theMessage) {
		PortalMessage__c newPM = new PortalMessage__c();
		newPM.User__c = proj.OwnerId;
		newPM.RecordTypeId = alertRecordTypeId;
		newPM.StartDate__c = theDate;
		newPM.IsEscalationAlert__c = true;
		newPM.Subject__c = theMessage;
		newPM.LinkToRecord__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+proj.Id;
		return newPM;
	}
	
	private static PortalMessage__c createNewAlertForPM (pse__Proj__c proj, Date theDate, String theMessage) {
		PortalMessage__c newPM = new PortalMessage__c();
		newPM.User__c = proj.pse__Project_Manager__r.pse__Salesforce_User__c;
		newPM.RecordTypeId = alertRecordTypeId;
		newPM.StartDate__c = theDate;
		newPM.IsEscalationAlert__c = true;
		newPM.Subject__c = theMessage;
		newPM.LinkToRecord__c = URL.getSalesforceBaseUrl().toExternalForm()+'/'+proj.Id;
		return newPM;
	}	
    
	public static void handleProjectCloseTo_OtherStatus(map<Id, pse__Proj__c> projOldMap, map<Id, pse__Proj__c> projNewMap, list<pse__Proj__c> updatedProjects)
	{
        // If the project Stage went from Closed to something other than Close (reopen), then set the date that it (Reopen) happened.
        system.debug( 'handleProjectCloseTo_OtherStatus called' );
        
        for(pse__Proj__c updatedProject:projNewMap.values())
		{
			system.debug( 'handleProjectCloseTo_OtherStatus called ' + projOldMap.get(updatedProject.Id).pse__Stage__c + ' updatedProject.pse__Stage__c ' + updatedProject.pse__Stage__c );

			if( (projOldMap.get(updatedProject.Id).pse__Stage__c == 'Closed') && (updatedProject.pse__Stage__c != projOldMap.get(updatedProject.Id).pse__Stage__c) )
			{
				updatedProject.StatusClosedToReOpenDate__c = date.Today();
			}			
		}        
    } 
        
   	public static void approveResilience_SetApproveDate(map<Id, pse__Proj__c> projOldMap, map<Id, pse__Proj__c> projNewMap, list<pse__Proj__c> updatedProjects){
        // If the project Stage went from Closed to something other than Close (reopen), then set the date that it (Reopen) happened.
        for(pse__Proj__c updatedProject:projNewMap.values())
		{
			if( (projOldMap.get(updatedProject.Id).OSPApproved__c != null) && (updatedProject.OSPApproved__c != projOldMap.get(updatedProject.Id).OSPApproved__c) )
			{
				updatedProject.StatusClosedToReOpenDate__c = date.Today();
			}			
		} 
    }
    
    
    public static ProjectRole__c resilienceDirectorRole{
    	get {
    		if (resilienceDirectorRole == null) {
    			resilienceDirectorRole = [Select Id, Name From ProjectRole__c Where Name = 'Resilience Director'];
    		}

    		return resilienceDirectorRole;
    	}
    	private set;
    }
   	public static void createResilienceDirectorTeamMember(map<Id, pse__Proj__c> projOldMap, map<Id, pse__Proj__c> projNewMap, list<pse__Proj__c> updatedProjects){
		if (executedMethods.contains('createResilienceDirectorTeamMember')) return;
		executedMethods.add('createResilienceDirectorTeamMember');

		string uName = UserInfo.getUserName();
        string uId = UserInfo.getUserId();
        string uFirstName = UserInfo.getFirstName();
        string uLastName = UserInfo.getLastName();

		ProjectTeamMember__c[] projectTeamMembers = [ Select Id, Project__c, User__c, contact__r.user__r.IsActive, contact__c,  contact__r.user__r.name, user__r.Name From ProjectTeamMember__c Where ProjectRole__r.Name = 'Resilience Director' and Project__c = :updatedProjects and contact__r.user__r.isactive = true ];

        ProjectRole__c role = resilienceDirectorRole;
        
        system.debug( 'pTM ' + projectTeamMembers.size() + ' ' + projectTeamMembers );
        
        Map<String, ProjectTeamMember__c> mapProjTM_PTM = new Map<String, ProjectTeamMember__c> ();
        Map<Id, ProjectTeamMember__c> mapProj_PTM = new Map<Id, ProjectTeamMember__c> ();
        
        String combinedKey;
 		String projId;
        string userId;
        string contactId;
        
        for( ProjectTeamMember__c pTm : projectTeamMembers )
        {
        	projId = pTm.Project__c;
            //userId = pTm.contact__r.user__r.id;
            contactId = pTm.contact__c;
            combinedKey = projId + contactId;
            mapProjTM_PTM.put(combinedKey, pTm);
            mapProj_PTM.put(projId, pTm);
        }   
        
        Set<Id> contactIds = new Set<Id> ();
        
        for(pse__Proj__c oProject: projNewMap.values() ){
			contactIds.add(projNewMap.get(oProject.Id).OSPApprover__c);        	    
        }      
        
        //Map<Id, Contact> mapIdContact = new Map<Id, Contact>([ SELECT Id, Name From Contact Where pse__Salesforce_User__c In :uId ]);
        //List<Contact> currentUserContact = [ SELECT Id, Name From Contact Where pse__Salesforce_User__c = :uId Limit 1 ];
        
        system.debug( 'mapProjTM_PTM	 ' + mapProjTM_PTM );
        
        List<ProjectTeamMember__c> listPTM_To_Insert = new List<ProjectTeamMember__c> ();
        
   		for(pse__Proj__c oProject: updatedProjects /*projNewMap.values() */ ){

            if( (projNewMap.get(oProject.Id).OSPApproved__c == true) && (oProject.OSPApproved__c != projOldMap.get(oProject.Id).OSPApproved__c) )
            {
                oProject.OSPApprovedBy__c = uFirstName + ' ' + uLastName;
                oProject.OSPDateTimeApproved__c = DateTime.now();
            }

            // There is a valid approver, and the approver has changed
            if( ( projNewMap.get(oProject.Id).OSPApprover__c != null ) && ( projNewMap.get(oProject.Id).OSPApprover__c != projOldMap.get(oProject.Id).OSPApprover__c ) )
            {
				System.debug( '***DEBUG:  oProject.OSPApprover__c changed : '+oProject.OSPApprover__c + '  oProject.OSPApprovedBy__c ' +  oProject.OSPApprovedBy__c );	
                string s = string.valueof(oProject.Id) + string.valueof(projNewMap.get(oProject.Id).OSPApprover__c);
                System.debug('***DEBUG: Combined key : '+s+ ' === ' + mapProjTM_PTM );	                
                    	
                if( ! mapProjTM_PTM.containsKey(s) )
                {
                    // Current user is not already a Res director, so add him / her. Multiple res dir is fine as long as diff people
                    //
                    system.debug( 'Line 263 = projNewMap.get(oProject.Id).OSPApprover__c ' + projNewMap.get(oProject.Id).OSPApprover__c );
                    
					listPTM_To_Insert.add(new ProjectTeamMember__c(Project__c = oProject.id,
                                                                    Contact__c = projNewMap.get(oProject.Id).OSPApprover__c,
                                                                    ProjectRole__c = role.Id,
                                                                    RecordTypeID = ECO_Utils_Meta.getRecordTypeId(ProjectTeamMember__c.sObjectType,'Team Member')));   
                }    
            }
            
			System.debug('***DEBUG:  oProject.OSPApprover__c: '+oProject.OSPApprover__c + ' Diff ' + projNewMap.get(oProject.Id).OSPApprover__c + ' === ' + projOldMap.get(oProject.Id).OSPApprover__c);			
		}      
        
        System.debug( 'listPTM_To_Insert ' + listPTM_To_Insert );
        
        if( listPTM_To_Insert.size() > 0 )
        {
            upsert listPTM_To_Insert;            
        }            

    }
    
	public static void handleProjectRestart( map<Id, pse__Proj__c> projOldMap, map<Id, pse__Proj__c> projNewMap )
	{
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PROJ_Restart')) {
			return;
		}        
        
		list<Id> projectIds = new list<Id>();
		alertRecordTypeId = ECO_Utils_Meta.getRecordTypeId(PortalMessage__c.sObjectType, ECO_Constants.PortalMessage_AlertRecordTypeName);
		
		list<PortalMessage__c> messagesToInsert = new list<PortalMessage__c>();

		for(pse__Proj__c updatedProject:projNewMap.values())
		{
			if(updatedProject.IsActive__c && (!projOldMap.get(updatedProject.Id).IsActive__c))
			{
				projectIds.add(updatedProject.Id);
			}			
		}		

		if (!projectIds.isEmpty()) {
			for(pse__Proj__c restartedProject:[select Id, pse__Project_Manager__r.pse__Salesforce_User__c from pse__Proj__c where Id in :projectIds])
			{
				messagesToInsert.add(createNewAlertForPM(restartedProject, Date.today(), 'This project has been restarted'));	
			}	
			
			if(messagesToInsert.size() > 0)
				insert messagesToInsert;
		}		
	}
	
	public static void handleDefaultingTaskOwningCustomer(map<Id, pse__Proj__c> projOldMap, map<Id, pse__Proj__c> projNewMap)
	{
		if (executedMethods.contains('handleDefaultingTaskOwningCustomer')) return;
		executedMethods.add('handleDefaultingTaskOwningCustomer');

		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PROJ_TaskOwning')) {
			return;
		}
		
		list<Id> projectsToUpdateTasks = new list<Id>();		
		for (pse__Proj__c proj : projNewMap.values()) {
			if((proj.EnableTopTaskCustomerFlag__c && !(projOldMap.get(proj.Id).EnableTopTaskCustomerFlag__c)) || (!(proj.EnableTopTaskCustomerFlag__c) && projOldMap.get(proj.Id).EnableTopTaskCustomerFlag__c))
				projectsToUpdateTasks.add(proj.Id);
		}
		
		map<Id, Project_Site__c> projectSiteMap = new map<Id, Project_Site__c>();
		for(Project_Site__c projectSite:[select Id, Project__c from Project_Site__c where Is_Default_Top_Task__c = true and Project__c in :projectsToUpdateTasks])
		{
			projectSiteMap.put(projectSite.Project__c, projectSite);
		}
		
		list<pse__Project_Task__c> projectTasksToUpdate = new list<pse__Project_Task__c>();
		for(pse__Project_Task__c task:[select Id, pse__Project__c, TopTaskOwningCustomer__c from pse__Project_Task__c where pse__Project__c in :projectsToUpdateTasks])
		{
			if(task.TopTaskOwningCustomer__c == null && projNewMap.get(task.pse__Project__c).EnableTopTaskCustomerFlag__c && projectSiteMap.get(task.pse__Project__c) != null)
			{
				task.TopTaskOwningCustomer__c = projectSiteMap.get(task.pse__Project__c).Id;
				projectTasksToUpdate.add(task);
			}
			else if(task.TopTaskOwningCustomer__c != null && !(projNewMap.get(task.pse__Project__c).EnableTopTaskCustomerFlag__c))
			{
				task.TopTaskOwningCustomer__c = null;	
				projectTasksToUpdate.add(task);
			}
		}
		
		update projectTasksToUpdate;	
	}

	public static void setExpenditureFlagOnProjectReOpen(list<pse__Proj__c> lProjects){
		if (executedMethods.contains('setExpenditureFlagOnProjectReOpen')) return;
		executedMethods.add('setExpenditureFlagOnProjectReOpen');
		// bjacobi@ae.com.ecosysdev
        //if(! ( ( uName == 'bobby.hoque@aecom.com.ecosysdev' ) || ( uName == 'bjacobi@ae.com.ecosysdev' ) ) )
        //    return ; 
        //    
        //    
        if( ( lProjects[0].ReOpenProjectExpenditureEmailFlag__c == true ) || ( lProjects[0].StatusClosedToReOpenDate__c == null ) )
            return;
                
		string uName = UserInfo.getUserName();
        
        //if(! ( uName == 'bobby.hoque@aecom.com.ecosysdev' ) )
        //    return ; 
        
        List<AggregateResult> expendFlagResult = new List<AggregateResult>();
        
        expendFlagResult = [SELECT project__c, count(Id) total_Exp_count
			FROM expenditem__c
			WHERE ProjectStatusChangedDateOlder__c = true and Project__c = : lProjects[0].id
			GROUP BY rollup(project__c)
			];
        
        system.debug( 'expendFlagResult ' + expendFlagResult );
        
        Integer ExpResultsAfter = 0;
        for(AggregateResult sobj : expendFlagResult)
		{   
            ExpResultsAfter = Integer.valueOf(sobj.get('total_Exp_count'));
            
            system.debug( 'ExpResultsAfter ' + ExpResultsAfter );
		}
        
		// If there has been any expenditure items since we have close our project then set this flag to true
        if( ExpResultsAfter > 0 )
        {
        	lProjects[0].ReOpenProjectExpenditureEmailFlag__c = true;   
        }            
    }    
    
	public static void replicateNewProjectTask(list<pse__Project_Task__c> lProjectTasks){
		if (executedMethods.contains('replicateNewProjectTask')) return;
		executedMethods.add('replicateNewProjectTask');

		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PROJTASK_BudgetReplicate')) {
			return;
		}

		//set<Id> lProjectsToQuery.add(oTask.Project__c) = new set<Id>();
		map<Id, list<pse__Project_Task__c>> mTasksByProjectId = new map<Id, list<pse__Project_Task__c>>();

		for(pse__Project_Task__c oTask : lProjectTasks){
			if(!mTasksByProjectId.containsKey(oTask.pse__Project__c))
				mTasksByProjectId.put(oTask.pse__Project__c, new list<pse__Project_Task__c>());

			mTasksByProjectId.get(oTask.pse__Project__c).add(oTask);
		}

		list<pse__Proj__c> lProjects = new list<pse__Proj__c>([SELECT Id,
																	  (SELECT Id
																	   FROM BudgetHeaders__r
																	   WHERE Status__c = :ECO_DTO_BudgetHeader.STATUS_ESTIMATE)
															   FROM pse__Proj__c
															   WHERE Id in :mTasksByProjectId.keySet()]);

		list<BudgetTask__c> lBudgetTasksToInsert = new list<BudgetTask__c>();

		for(pse__Proj__c oProject : lProjects){
			for(BudgetHeader__c oBudgetHeader : oProject.BudgetHeaders__r){
				for(pse__Project_Task__c oProjectTask : mTasksByProjectId.get(oProject.Id)){
					BudgetTask__c oBudgetTaskToInsert = new BudgetTask__c();
					oBudgetTaskToInsert.ProjectTask__c = oProjectTask.Id;
					oBudgetTaskToInsert.BudgetHeader__c = oBudgetHeader.Id;
					oBudgetTaskToInsert.TaskName__c = oProjectTask.Name;

					lBudgetTasksToInsert.add(oBudgetTaskToInsert);
				}
			}
		}

		if(lBudgetTasksToInsert.size() > 0){
			insert lBudgetTasksToInsert;
		}
	}
}