public without sharing class ECO_ProjectTriggers {
	public static Boolean run = true;
	
	public static void setOwner(list<pse__Proj__c> lstProject){
		for(pse__Proj__c p:lstProject){
			if(p.pse__Stage__c == 'Approved'){
				if(p.Project_Manager_User__c != null){
					p.ownerid = p.Project_Manager_User__c;
				}
			}
		}
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
	
	public static void handleProjectRestart(map<Id, pse__Proj__c> projOldMap, map<Id, pse__Proj__c> projNewMap)
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

		for(pse__Proj__c restartedProject:[select Id, pse__Project_Manager__r.pse__Salesforce_User__c from pse__Proj__c where Id in :projectIds])
		{
			messagesToInsert.add(createNewAlertForPM(restartedProject, Date.today(), 'This project has been restarted'));	
		}	
		
		if(messagesToInsert.size() > 0)
			insert messagesToInsert;
	}
	
	public static void handleDefaultingTaskOwningCustomer(map<Id, pse__Proj__c> projOldMap, map<Id, pse__Proj__c> projNewMap)
	{
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


	public static void replicateNewProjectTask(list<pse__Project_Task__c> lProjectTasks){
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
																	   WHERE Status__c = 'Estimate')
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