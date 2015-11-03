public with sharing class ECO_ProjectTaskTriggers {
	
	public static Boolean run = true;

	public static Boolean updatingBurden = false;
	public static Boolean copyingCarrying = false;

	public static void recalculateProjects(Set<Id> projectIds, Boolean force) {
		List<pse__Proj__c> projects = [select id, RevisedStartDate__c, RevisedEndDate__c, pse__Start_Date__c, pse__End_Date__c, (select id, pse__Start_Date__c, pse__End_Date__c from pse__Project_Tasks__r) from pse__Proj__c where id in :projectIds];

		List<pse__Proj__c> toUpdate = new List<pse__Proj__c>();

		List<WeeklyRollupEntry__c> toUpsert = new List<WeeklyRollupEntry__c>();
		
		List<pse__Time_Period__c> timePeriods = [select id, TimePeriodCode__c, pse__Start_Date__c, pse__End_Date__c from pse__Time_Period__c where pse__Type__c = 'Month'];

		for (pse__Proj__c project : projects) {
			Date newStartDate = null;
			Date newEndDate = null;

			for (pse__Project_Task__c task : project.pse__Project_Tasks__r) {
				if ((newStartDate == null) || (task.pse__Start_Date__c < newStartDate)) {
					newStartDate = task.pse__Start_Date__c;
				}

				if ((newEndDate == null) || (task.pse__End_Date__c > newEndDate)) {
					newEndDate = task.pse__End_Date__c;
				}
			}

			Boolean changed = false;

			// Uncommented by Sujit as per Michael, TODO: please review with Graham
			if (project.pse__Start_Date__c != newStartDate) {
				project.pse__Start_Date__c = newStartDate;
				changed = true;
			}

			// Uncommented by Sujit as per Michael, TODO: please review with Graham
			if (project.pse__End_Date__c != newEndDate) {
				project.pse__End_Date__c = newEndDate;
				changed = true;
			}

			if (project.RevisedStartDate__c != newStartDate) {
				project.RevisedStartDate__c = newStartDate;
				changed = true;
			}

			if (project.RevisedEndDate__c != newEndDate) {
				project.RevisedEndDate__c = newEndDate;
				changed = true;
			}

			if (changed) {
				toUpdate.add(project);
			}

//			newStartDate = (newStartDate < project.pse__Start_Date__c) ? newStartDate : project.pse__Start_Date__c;
//			newEndDate = (newEndDate > project.pse__End_Date__c) ? newEndDate : project.pse__End_Date__c;

			if (changed || force) {
				Integer i = 1;

//				for (Date currentDate = project.pse__Start_Date__c; currentDate <= project.pse__End_Date__c; currentDate = currentDate.addDays(7)) {
				for (Date currentDate = newStartDate; currentDate <= newEndDate.addDays(7); currentDate = currentDate.addDays(7)) {
					WeeklyRollupEntry__c rollup = new WeeklyRollupEntry__c(
						Project__c = project.id,
						CompositeKey__c = ECO_Service_Snapshots.DateToSnapshotKey(currentDate, project.id),
						PeriodStartDate__c = ECO_Service_Snapshots.getFirstDateOfWeek(currentDate));
					
					// time period
					for (pse__Time_Period__c tp : timePeriods){
						if (tp.pse__Start_Date__c >= rollup.PeriodStartDate__c && tp.pse__End_Date__c <= rollup.PeriodStartDate__c){	
							rollup.FiscalMonth__c = tp.TimePeriodCode__c;
						}
					}
						

					toUpsert.add(rollup);

					if (i >= 500)
						break;

					i++;
				}

				System.debug('spittig out - ' + i);
			}
		}	

		update toUpdate;

		System.debug('upserting WeeklyRollupEntry(s) - ' + toUpsert);

		upsert toUpsert CompositeKey__c;
	}

	public static void recalculateProjectDates (List<pse__Project_Task__c> tNew) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents')) {
			return;
		}

		if (updatingBurden) {
			return;
		}

		Set<Id> projectIds = new Set<Id>();

		for (pse__Project_Task__c task : tNew) {
			if (task.pse__Project__c != null) {
				projectIds.add(task.pse__Project__c);
			}
		}

		recalculateProjects(projectIds, false);
	}

	public static void applyLookups(List<pse__Project_Task__c> tNew) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents')) {
			return;
		}

		Set<Id> projectIds = new Set<Id>();

		for (pse__Project_Task__c task : tNew) {
			projectIds.add(task.pse__Project__c);
		}

		List<pse__Proj__c> projects = [select id, CarryingOutOrganization__c, CarryingOutOrganization__r.OUID__c from pse__Proj__c where id in :projectIds];

		Map<Id, Id> projectMap = new Map<Id, Id>();
		Map<Id, String> projectMapString = new Map<Id, String>();

		for (pse__Proj__c project : projects) {
			projectMap.put(project.id, project.CarryingOutOrganization__c);
			projectMapString.put(project.id, project.CarryingOutOrganization__r.OUID__c);
		}

		Set<String> owningOrgs = new Set<String>();
		Map<String, List<pse__Project_Task__c>> owningOrgMap = new Map<String, List<pse__Project_Task__c>>();

		for (pse__Project_Task__c task : tNew) {
			task.CarryingOutOrganization__c = projectMap.get(task.pse__Project__c);

			String owningOrg = projectMapString.get(task.pse__Project__c);

			owningOrgs.add(owningOrg);

			List<pse__Project_Task__c> ptasks = owningOrgMap.get(owningOrg);

			if (ptasks == null) {
				ptasks = new List<pse__Project_Task__c>();

				owningOrgMap.put(owningOrg, ptasks);
			}

			ptasks.add(task);
		}

		List<BurdenReference__c> burdenReferences = [select id, OU_ID__c, Home_Field__c, OU_Schedule__c, Schedule__c, Ind_Rate_Sch_Id__c from BurdenReference__c where OU_ID__c in :owningOrgs];

		for (BurdenReference__c burdenReference : burdenReferences) {
			System.debug('burden reference - ' + burdenReference);

			List<pse__Project_Task__c> ptasks = owningOrgMap.get(burdenReference.OU_ID__c);

			for (pse__Project_Task__c task : ptasks) {
				String workType = task.WorkTypeName__c;

				if (workType == null)
					continue;

				String homeField = burdenReference.Home_Field__c;

				if (homeField == null)
					continue;

				System.debug('worktype - ' + workType);
				System.debug('homeField - ' + homeField);	

				if (workType.left(4).equalsIgnoreCase(homeField.left(4))) {  // both start with HOME or FIEL, found a match
					task.Burden_Reference_Schedule_Name__c = burdenReference.OU_Schedule__c;
					task.CostIndRateSCHID__c = burdenReference.Ind_Rate_Sch_Id__c;
				}
			}
		}
	}

	public static void copyCarryingOutToTask(List<pse__Project_Task__c> tNew) {
		if (copyingCarrying)
			return;

		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents')) {
			return;
		}

		copyingCarrying = true;

		Set<Id> projectIds = new Set<Id>();

		for (pse__Project_Task__c task : tNew) {
			projectIds.add(task.pse__Project__c);
		}

		List<pse__Proj__c> projects = [select id, CarryingOutOrganization__c from pse__Proj__c where id in :projectIds];

		Map<Id, String> projectMap = new Map<Id, String>();

		for (pse__Proj__c project : projects) {
			projectMap.put(project.id, project.CarryingOutOrganization__c);
		}

		for (pse__Project_Task__c task : tNew) {
			task.CarryingOutOrganization__c = projectMap.get(task.pse__Project__c);
		}

		copyingCarrying = false;
	}

	public static void getScheduleName(List<pse__Project_Task__c> tNew) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents')) {
			return;
		}

		if (updatingBurden) {
			return;
		}

		updatingBurden = true;  // prevent recursion

		Set<Id> taskIds = new Set<Id>();

		for (pse__Project_Task__c task : tNew) {
			taskIds.add(task.id);
		}		

		//List<pse__Project_Task__c> tasks = [select TaskOrg__r.OrganizationString__r.OUID__c, WorkTypeName__c, Burden_Reference_Schedule_Name__c from pse__Project_Task__c where id in :taskIds];
		List<pse__Project_Task__c> tasks = [select CarryingOutOrganization__r.OUID__c, WorkTypeName__c, Burden_Reference_Schedule_Name__c from pse__Project_Task__c where id in :taskIds];

		Set<String> owningOrgs = new Set<String>();
		Map<String, pse__Project_Task__c> owningOrgMap = new Map<String, pse__Project_Task__c>();

		for (pse__Project_Task__c task : tasks) {
			//String owningOrg = task.TaskOrg__r.OrganizationString__r.OUID__c;
			String owningOrg = task.CarryingOutOrganization__r.OUID__c;

			System.debug('hey1 - ' + owningOrg + ' - ' + task);
			
			owningOrgs.add(owningOrg);

			owningOrgMap.put(owningOrg, task);
		}

		List<BurdenReference__c> burdenReferences = [select id, OU_ID__c, Home_Field__c, OU_Schedule__c, Schedule__c, Ind_Rate_Sch_Id__c from BurdenReference__c where OU_ID__c in :owningOrgs];

		List<pse__Project_Task__c> toUpdate = new List<pse__Project_Task__c>();

		for (BurdenReference__c burdenReference : burdenReferences) {
			System.debug('burden reference - ' + burdenReference);

			pse__Project_Task__c task = owningOrgMap.get(burdenReference.OU_ID__c);

			String workType = task.WorkTypeName__c;

			System.debug('herea');

			if (workType == null)
				continue;

			System.debug('hereb');

			String homeField = burdenReference.Home_Field__c;

			if (homeField == null)
				continue;

			System.debug('worktype - ' + workType);
			System.debug('homeField - ' + homeField);	

			if (workType.left(4).equalsIgnoreCase(homeField.left(4))) {  // both start with HOME or FIEL, found a match
				if (task.Burden_Reference_Schedule_Name__c == null) {
					if (burdenReference.OU_Schedule__c == null) {
						// same

						System.debug('here1');
					} else {
						task.Burden_Reference_Schedule_Name__c = burdenReference.OU_Schedule__c;
						task.CostIndRateSCHID__c = burdenReference.Ind_Rate_Sch_Id__c;

						toUpdate.add(task);

						System.debug('here2');
					}
				} else {
					if (burdenReference.OU_Schedule__c == null) {
						task.Burden_Reference_Schedule_Name__c = null;
						task.CostIndRateSCHID__c = null;

						toUpdate.add(task);

						System.debug('here3');
					} else if (!task.Burden_Reference_Schedule_Name__c.equals(burdenReference.OU_Schedule__c)) {
						task.Burden_Reference_Schedule_Name__c = burdenReference.OU_Schedule__c;
						task.CostIndRateSCHID__c = burdenReference.Ind_Rate_Sch_Id__c;

						toUpdate.add(task);

						System.debug('here4');
					} else {
						// same

						System.debug('here5');
					}
				}
			}
		}

		update toUpdate;

		updatingBurden = false;
	}

	// TAL - I ripped this out of the trigger body and put it here...... but I didn't write it.
	public static void legacyCalcsFromTriggerBody (Boolean isBefore
													, Boolean isInsert
													, Boolean isUpdate
													, Boolean isDelete
													, Boolean isAfter
													, List<pse__Project_Task__c> tNew
													, List<pse__Project_Task__c> tOld
													, Map<Id, pse__Project_Task__c> tOldMap) {
		
		if (!run) {
			return;
		}

		if (updatingBurden) {
			return;
		}
		
		Boolean isTriggerEnabled = ECO_TriggerSettings.getIsTriggerEnabled('ECO_ProjectTask_AllEvents');

		 if (isBefore && isTriggerEnabled) {
	
	        ECO_ProjectTaskValidator validator = new ECO_ProjectTaskValidator();
	
	        //set any top level tasks to financial - to support creating from gantt
	        if(isInsert){          
	            validator.setTopTasksFinancial(tNew);
	        }
	
	        if (isInsert || isUpdate) {
	            validator.validateForInsertAndUpdate(tNew, isUpdate); 
	        }
	
	
	        if(isDelete){
	            validator.validateForDelete(tOld);           
	        }
	
	     }
	
	    if(isAfter && isUpdate && isTriggerEnabled){
	        Set<Id> tasksToSyncNow = new Set<Id>();
	        Set<Id> tasksToSyncLater = new Set<Id>();
	
	
	        for(pse__Project_Task__c newVersion : tNew){
	            pse__Project_Task__c oldVersion = ( pse__Project_Task__c)tOldMap.get(newVersion.Id);
	            if(oldVersion.OracleSyncStatus__c == 'S'){  //task has been succesfully synce with oracle
	                if(newVersion.IsChargeable__c && !oldVersion.IsChargeable__c ){
	                    tasksToSyncNow.add(newVersion.Id);
	                }else if(!newVersion.IsChargeable__c && oldVersion.IsChargeable__c){
	                    tasksToSyncLater.add(newVersion.Id);
	                }
	            }
	            
	        }
	
	        if(!tasksToSyncLater.isEmpty()){
	            ECO_Service_ProjectSync.SetupSyncLaterTasks(tasksToSyncLater);
	        }
	
	        if(!tasksToSyncNow.isEmpty()){
	            ECO_Service_ProjectSync.SetupSyncNowTasks(tasksToSyncNow);
	            ECO_Service_ProjectSync.initiateTaskSyncNowProcessing();
	        }
	   
	    }
	}
	
	
	
	
	
	
	
	
	
	public static void calculateEarnedValueSnaps (List<pse__Project_Task__c> newTasks) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PT_CalcEV')) {
			return;
		}

		if (updatingBurden) {
			return;
		}
		
		List<EarnedValueSnapshot__c> evsToUpsert = new List<EarnedValueSnapshot__c>();
		List<EarnedValueSnapshot__c> evsToDelete = new List<EarnedValueSnapshot__c>();
		
		for (pse__Project_Task__c pt : [SELECT Id 
												, pse__Project__c
												, pse__Start_Date__c
												, pse__End_Date__c
												, TotalApprovedCost__c
												, EarnedValueCurve__c
                                        		, TotalEstimateCost__c
												, (SELECT Id 
														, ThisWeekNumber__c
													FROM EarnedValueSnapshots__r)
									FROM pse__Project_Task__c 
									WHERE Id IN :newTasks]) {
										
			system.debug('EarnedValueCurve__c:  '+pt.EarnedValueCurve__c);
			
			Map<String, List<EarnedValueSnapshot__c>> returnedMap;
			
			try{
				if ('S Curve'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
					returnedMap = ECO_Service_EarnedValue.calculateSCurveForTask(pt, pt.EarnedValueSnapshots__r);
				} else if ('Front Loaded'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
					returnedMap = ECO_Service_EarnedValue.calculateFrontLoadedCurveForTask(pt, pt.EarnedValueSnapshots__r);
				} else if ('Even'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
					returnedMap = ECO_Service_EarnedValue.calculateEvenCurveForTask(pt, pt.EarnedValueSnapshots__r);
				} else if ('Bell Shaped'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
					returnedMap = ECO_Service_EarnedValue.calculateBellCurveForTask(pt, pt.EarnedValueSnapshots__r);
				} else if ('Back Loaded'.equalsIgnoreCase(pt.EarnedValueCurve__c)) {
					returnedMap = ECO_Service_EarnedValue.calculateBackLoadedCurveForTask(pt, pt.EarnedValueSnapshots__r);
				}
			}
			catch(Exception ex){
				system.debug('Error: ' + ex);
			}
			
			if (returnedMap != null && returnedMap.get('Upsert') != null) {
				evsToUpsert.addAll(returnedMap.get('Upsert'));
			}
			
			if (returnedMap != null && returnedMap.get('Delete') != null) {
				evsToDelete.addAll(returnedMap.get('Delete'));
			}
		}
		
		if (!evsToUpsert.isEmpty()) {
			run = false;
			upsert evsToUpsert CompositeKey__c;
			run = true;
		}
		
		if (!evsToDelete.isEmpty()) {
			run = false;
			delete evsToDelete;
			run = true;
		}
	}
	
	public static void handleDefaultingTaskOwningCustomer(list<pse__Project_Task__c> projectTasks)
	{
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('PT_TaskOwning')) {
			return;
		}

		if (updatingBurden) {
			return;
		}
		
		map<Id, list<pse__Project_Task__c>> projectToProjectTaskMap = new map<Id, list<pse__Project_Task__c>>();
		for(pse__Project_Task__c projectTask:projectTasks)
		{
			if(projectToProjectTaskMap.get(projectTask.pse__Project__c) == null)
				projectToProjectTaskMap.put(projectTask.pse__Project__c, new list<pse__Project_Task__c>());
			projectToProjectTaskMap.get(projectTask.pse__Project__c).add(projectTask);
		}
		
		map<Id, Project_Site__c> projectSiteMap = new map<Id, Project_Site__c>();
		for(Project_Site__c projectSite:[select Id, Project__c from Project_Site__c where Is_Default_Top_Task__c = true and Project__c in :projectToProjectTaskMap.keyset()])
		{
			projectSiteMap.put(projectSite.Project__c, projectSite);
		}
		
		for(pse__Proj__c project:[select Id from pse__Proj__c where Id in :projectToProjectTaskMap.keyset() and EnableTopTaskCustomerFlag__c = true])
		{
			for(pse__Project_Task__c task:projectToProjectTaskMap.get(project.Id))
			{
				if(projectSiteMap.get(task.pse__Project__c) != null)
					task.TopTaskOwningCustomer__c = projectSiteMap.get(task.pse__Project__c).Id; 
			}
		}
		
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