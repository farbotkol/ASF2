public with sharing class ECO_EarnedValueReportController{

	private Id evHeaderId;
	private Id projectId;

	private Boolean useNewWay { get; set; }
	
	public EarnedValueHeader__c evHeader {get;set;}
	public EarnedValueSnapshot__c evSnapshot {get;set;}
	public pse__Proj__c project {get; set;}
	public List<ProjectTaskWrapper> availableTasks {get;set;}

	public List<SelectOption> optBudgets {get;set;}
	public List<SelectOption> optExistingEVReports {get;set;}
	public String selectedBudgetHeaderId {get;set;}
	public String selectedExistingReportId {get;set;}
	public String selectedReportAction {get;set;}
	public Integer numAvailableTasks {get; private set;}

	public Boolean isEdit {get; private set;}

	private Map<Id, EarnedValueSnapshot__c> mapSnapShots;
	private Id projectManagerId;

	public List<EarnedValueSnapshot__c> evSnapshots {get; private set;}

    public String selectedSnapshotId {get;set;}

    public List<SelectOption> optEarnedValueSnapshots {get; private set;}

    private List<pse__Project_Task__c> projectTasks;

    public String chartJSON {get;set;}
    public String cpiAndSpiJSON {get;set;}
    public Boolean rerenderChart {get;set;}

    public String selectedSnapshotDate {get;set;}
    private Map<Date, List<EarnedValueSnapshot__c>> mapWeekOfDateSnapshots;

    public Map<Date, Decimal> mapDateCPI {get; set;}
    public Map<Date, Decimal> mapDateSPI {get; set;}
    public Map<Date, Decimal> mapDatePlannedValues {get; set;}
    public Map<Date, Decimal> mapDateActualCosts {get; set;}
    public Map<Date, Decimal> mapDateEarnedValues {get; set;}

    public Boolean hideAll {get; private set;}

    private Map<String, List<EarnedValueTask__c>> allEVTasksForReport;

    public Boolean existingReportsExist {get;set;}
    private Map<Id, EarnedValueHeader__c> mapExistingEarnedValueReports;

    public Integer posSelectedSnapShot {get; private set;}

    public Boolean hasPrevSnapShot {get; private set;}
    public Boolean hasNextSnapShot {get; private set;}

    public String noTasksForSnapshotDateMsg {get; private set;}
    
    public ECO_EarnedValueReportController(Id headerId)
    {
    	evHeaderId = headerId;
    	init();
    }

	public ECO_EarnedValueReportController(ApexPages.StandardController stdController) {
		evHeaderId = checkForUrlIdParam('id');
		init();
	}
	
	private void init()
	{
		useNewWay = true;
		mapWeekOfDateSnapshots = new Map<Date, List<EarnedValueSnapshot__c>>();
		allEVTasksForReport = new Map<String, List<EarnedValueTask__c>>();
    	//EarnedValueHeader__c rec = (EarnedValueHeader__c)stdController.getRecord();

    	evHeader = new EarnedValueHeader__c();
    	availableTasks = new List<ProjectTaskWrapper>();
    	optBudgets = new List<SelectOption>();
    	optExistingEVReports = new List<SelectOption>();
    	isEdit = false;
    	rerenderChart = false;
    	numAvailableTasks = 0;
        noTasksForSnapshotDateMsg = '';

		//mapSnapShots = new Map<Id, EarnedValueSnapshot__c>();
		hideAll = false;

    	if(evHeaderId == null){

    		projectId = checkForUrlIdParam('projectId');
    		if(projectId == null){
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You have reached this page incorrectly. Please select a project and click \'New Report\' from the Earned Value Reports related list.'));
    			hideAll = true;
                return;
    		}

    		getProject();

            if(project.pse__Start_Date__c == null || project.EstimatedEndDate__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The project must have an actual start date and estimated end date for the earned value report.'));
                hideAll = true;
                return;
            }

			initializeForNewReport();    

    		evSnapshots = getSnapshotsForProject();

    		if(evSnapshots.size() == 0){
    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Earned Value Curve information based on Approved Cost values exist for the project tasks. Please complete the Total Approved Cost and Earned Value Curve fields for the project tasks.'));
    			hideAll = true;
    			return;
    		}

    		//set default snapshot - todo - get last not completed or one closest to current date
    		evSnapshot = evSnapshots.get(0);
    		selectedSnapshotId = evSnapshot.Id;

    		populateWeekOfSnapShotMap();

    		projectTasks = getTasksForProject();

    		optEarnedValueSnapshots = getEarnedValueSnapshots(evSnapshots);

    		if(!optEarnedValueSnapshots.isEmpty()){
    			selectedSnapshotDate = optEarnedValueSnapshots.get(0).getValue();
    		}

            availableTasks = getProjectTasksForNewReport();

    		numAvailableTasks = availableTasks.size();
    	
    	}else{
    		isEdit = true;

    		evHeader = [SELECT Id, Project__c, ReportName__c, Comments__c
    					FROM EarnedValueHeader__c
    					WHERE Id = :evHeaderId];
    		projectId = evHeader.Project__c;			
    		getProject();
    		List<ProjectTeamMember__c> projectManagers = ECO_Service_ProjectSync.getProjectManagerForProject(projectId);
    		if(!projectManagers.isEmpty()){
    			ProjectTeamMember__c projectManager = projectManagers.get(0);
    			projectManagerId = projectManager.Contact__r.pse__Salesforce_User__c;
    		}
    		projectManagerId = null;
    		
    		//default to lateset snapshot
    		posSelectedSnapShot = 0;
    	
    		selectedSnapshotDate = getLatestCompletedSnapshotDateForReport(evHeaderId);
    		evSnapshots = getSnapshotsForProject();
    		allEVTasksForReport = getAllEarnedValueTasksBySnapshotDate();

    		populateWeekOfSnapShotMap();

    		evSnapshot = evSnapshots.get(0);
    		selectedSnapshotId = evSnapshot.Id;

			optEarnedValueSnapshots = getEarnedValueSnapshots(evSnapshots);

    		numAvailableTasks = 0;
    		applySelectedSnapShotToTasks();

    		chartJSON = createEarnedValueGoogleChartJSON();
    		cpiAndSpiJSON = createCpiAndSpiGoogleChartJSON();

            noTasksForSnapshotDateMsg = 'The earned value entry fields have not been enabled for the selected \'Week Of date\' of the report. <a href="#" onclick="createTasksForNextSnapshotDate_JS();"> Enable entry fields for selected week of date</a>';
    	}
    }

    private void populateWeekOfSnapShotMap(){
    	for(EarnedValueSnapshot__c snapshot : evSnapshots){
    		if(mapWeekOfDateSnapshots.containsKey(snapshot.WeekStartDate__c)){
    			mapWeekOfDateSnapshots.get(snapshot.WeekStartDate__c).add(snapshot);
    		}else{
    			List<EarnedValueSnapshot__c> snapshots = new List<EarnedValueSnapshot__c>();
    			snapshots.add(snapshot);
    			mapWeekOfDateSnapshots.put(snapshot.WeekStartDate__c, snapshots);
    		}
    	}
    }
   
    private void getProject(){
    	List<pse__Proj__c> projects = [SELECT Id, Name, pse__Stage__c, pse__Start_Date__c, pse__End_Date__c, EstimatedStartDate__c, EstimatedEndDate__c
    									FROM pse__Proj__c
    									WHERE Id = :projectId];

    	if(projects.isEmpty()){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Unable to find project with id = \'' + projectId + '\'!'));    		
    	}else{
    		project = projects.get(0);
    	}
    }
   
    private Date getPriorSnapShotDate(){
    	Date result = null;
    	Integer currPos = 0;
    	Integer selPos = 0;
    	List<Date> sortedDates = new List<Date>();
    	for(Date snapShotDate : mapWeekOfDateSnapshots.keySet()){
    		sortedDates.add(snapShotDate);
    	}
    	sortedDates.sort();
    	for(Date snapShotDate : sortedDates){
    		if(formatDate(snapShotDate) == selectedSnapshotDate){
    			selPos = currPos; 
    		}
    		currPos ++;
    	}
    	if(selPos > 0){
    		result = sortedDates.get(selPos -1);
    	}
   	
    	return result;
    }

    private Date getNextSnapShotDate(){
    	Date result = null;
    	Integer currPos = 0;
    	Integer selPos = 0;
    	List<Date> sortedDates = new List<Date>();
    	for(Date snapShotDate : mapWeekOfDateSnapshots.keySet()){
    		sortedDates.add(snapShotDate);
    	}
    	sortedDates.sort();
    	for(Date snapShotDate : sortedDates){
    		if(formatDate(snapShotDate) == selectedSnapshotDate){
    			selPos = currPos; 
    		}
    		currPos ++;
    	}
    	if(selPos < sortedDates.size()){
    		result = sortedDates.get(selPos + 1);
    	}
   	
    	return result;
    }

    private List<SelectOption> getEarnedValueSnapshots(List<EarnedValueSnapshot__c> snapShots){
    	List<SelectOption> results = new List<SelectOption>();

    	if(!mapWeekOfDateSnapshots.isEmpty()){

    		//sort snapshot dates
    		List<Date> sortedDates = new List<Date>();
    		for(Date weekOfDate : mapWeekOfDateSnapshots.keySet()){
				sortedDates.add(weekOfDate);
    		}
    		sortedDates.sort();

	    	for(Date weekOfDate : sortedDates){
	    		results.add(new SelectOption(formatDate(weekOfDate), formatDate(weekOfDate)));	    	
	    	}
    	}
    

    	return results;
    }


    private void initializeForNewReport(){
    	existingReportsExist = false;
    	selectedBudgetHeaderId = null;
    	selectedExistingReportId = null;
    	selectedReportAction = 'new';
 		mapExistingEarnedValueReports = new Map<Id, EarnedValueHeader__c>();
    	evHeader.Project__c = project.Id;
        optExistingEVReports = getExistingEarnedValueReports();
    }

    private List<SelectOption> getExistingEarnedValueReports(){
    	List<SelectOption> results = new List<SelectOption>();
		results.add(new SelectOption('', '-- Choose --'));

    	List<EarnedValueHeader__c> earnedValueHeaders = [SELECT Id, ReportName__c    														
    													FROM EarnedValueHeader__c
    													WHERE Project__c = :projectId];

    	if(!earnedValueHeaders.isEmpty()){
    		existingReportsExist = true;
	    	Set<Id> existingReportIds = new Set<Id>();
	    	for(EarnedValueHeader__c evh : earnedValueHeaders){
	    		existingReportIds.add(evh.Id);
	    		mapExistingEarnedValueReports.put(evh.Id, evh);
	    	}	    		

	    	for(EarnedValueHeader__c evh : earnedValueHeaders){
	    		Date latestSnapShotDate = getLatestSnapshotDateForReport(evh.Id);
	    		String reportDesc = evh.ReportName__c;
	    		if(latestSnapShotDate != null){
	    			reportDesc += ' [Last completed "Week of Date" = ' + formatDate(latestSnapShotDate) + ']';
	    		}
	    		results.add(new SelectOption(String.valueOf(evh.Id), reportDesc));
	    	}
    	}

    	system.debug('existing reports size = ' + results.size());

    	return results;
    }

	private List<pse__Project_Task__c> getTasksForProject(){
		Datetime startOfTime = DateTime.newInstance(1900, 1 , 1);
    	return ECO_Service_ProjectSync.GetOracleProjectTaskRecords(projectId, startOfTime);
	}

	private Map<Id, EarnedValueSnapshot__c> getMapOfProjectTaskIdToSnapshotForSnapshotDate(String snapShotDate){
		Map<Id, EarnedValueSnapshot__c> results = new Map<Id, EarnedValueSnapshot__c>();
        if(!evSnapshots.isEmpty()){
            for(EarnedValueSnapshot__c snapShot : evSnapshots){         
                if(formatDate(snapshot.WeekStartDate__c) == selectedSnapshotDate){
                    results.put(snapShot.ProjectTask__c, snapShot);
                }           
            }
        }

		return results;
	}

    private List<ProjectTaskWrapper> getProjectTasksForNewReport(){
    	List<ProjectTaskWrapper> results = new List<ProjectTaskWrapper>();    	
  
    	Datetime startOfTime = DateTime.newInstance(1900, 1 , 1);

    	List<pse__Project_Task__c> tasks = ECO_Service_ProjectSync.GetOracleProjectTaskRecords(projectId, startOfTime);
    	Map<Id, EarnedValueSnapshot__c> mapTaskToSnapshots = getMapOfProjectTaskIdToSnapshotForSnapshotDate(selectedSnapshotDate);

    	system.debug('selectedSnapshotDate = ' + selectedSnapshotDate);
    	for(EarnedValueSnapshot__c snapShot : evSnapshots){
    		system.debug('WeekStartDate__c = ' + formatDate(snapshot.WeekStartDate__c));
    		if(formatDate(snapshot.WeekStartDate__c) == selectedSnapshotDate){
    			mapTaskToSnapshots.put(snapShot.ProjectTask__c, snapShot);
    		}    		
    	}

    	if(!tasks.isEmpty()){
    		for(pse__Project_Task__c task : tasks){
    			ProjectTaskWrapper wrapper = new ProjectTaskWrapper();
    			wrapper.task = task;
    			wrapper.isSelected = false;
    			wrapper.notifyOwnerOnCreate = false;
    			wrapper.disableSelect = false;
    			EarnedValueTask__c evTask = new EarnedValueTask__c();
    			
    			if(mapTaskToSnapshots.containsKey(task.Id)){
    				wrapper.earnedValueSnapshot = mapTaskToSnapshots.get(task.Id);
    			}else{
					wrapper.earnedValueSnapshot = new EarnedValueSnapshot__c();
					//wrapper.disableSelect = true;
    			}
    			
    			wrapper.earnedValueTask = evTask;
    			results.add(wrapper);
    		}
    	}

    	return results;
    }

    private List<EarnedValueSnapshot__c> getSnapshotsForProject(){


    	List<EarnedValueSnapshot__c> results = [SELECT
    												ProjectTask__c,
    												ProjectTask__r.FinancialTask__c,
    												ProjectTask__r.ProjectTaskNumber__c,
    												ProjectTask__r.Name,
    												ProjectTask__r.ProjectTaskOwner__r.Name,
    												ProjectTask__r.pse__Start_Date__c,
    												ProjectTask__r.pse__End_Date__c,
    												ProjectTask__r.TotalApprovedCost__c,
 													Comments__c,
 													ThisWeekAmount__c,
 													ThisWeekNumber__c,
 													ThisWeekRunningTotalAmount__c,
 													ThisWeekTotalRemaining__c,
 													WeekStartDate__c 												
 												FROM EarnedValueSnapshot__c
 												WHERE ProjectTask__r.pse__Project__c = :projectId
 												ORDER BY WeekStartDate__c DESC]; 

 		return results;										
    }

 	private List<ProjectTaskWrapper> getProjectTasksForExistingReport(){
 		Id existingEVHeaderId = Id.valueOf(SelectedExistingReportId);

		String lastSnapShotDate = getLatestCompletedSnapshotDateForReport(existingEVHeaderId);

		return getProjectTasksForSnapshotDate(lastSnapShotDate);
 	}
   	
    public Date getLatestSnapshotDateForReport(Id earnedValueHeaderId){
		Date result = null;

		List<EarnedValueTask__c> evTasks = [SELECT EarnedValueSnapshot__c
												, EarnedValueSnapshot__r.WeekStartDate__c
												, SnapshotDate__c
											FROM EarnedValueTask__c
											WHERE EarnedValueHeader__c = :earnedValueHeaderId
											ORDER BY SnapshotDate__c DESC
											LIMIT 1];
		if(!evTasks.isEmpty()){
			result = evTasks.get(0).SnapshotDate__c;
		}
		return result;
	}
	
	private List<ProjectTaskWrapper> getProjectTasksForSnapshotDate(String snapShotDate) {
		System.debug('useNewWay: ' + useNewWay);
		return useNewWay ? getProjectTasksForSnapshotDateNew(snapShotDate) 
						 : getProjectTasksForSnapshotDateOld(snapShotDate);
	}

	// TODO: in the process of refactoring the method getProjectTasksForSnapshotDate
	// Do not change the existing method, but create another method with New as a suffix 
    private List<ProjectTaskWrapper> getProjectTasksForSnapshotDateNew(String snapShotDate){
    	List<ProjectTaskWrapper> results = new List<ProjectTaskWrapper>();
    	Set<Id> snapShotIds = new Set<Id>();
    	Map<Id, EarnedValueSnapshot__c> mapTaskToSnapshots = getMapOfProjectTaskIdToSnapshotForSnapshotDate(selectedSnapshotDate);
    	
		system.debug('getProjectTasksForSnapshotDate - snapShotDate = ' + snapShotDate);
		Date snapShotDateValue = Date.valueOf(snapShotDate);
	
		/*
    	List<EarnedValueTask__c> snapShotTasks = [SELECT Id,
														PercentComplete__c,
														ProjectTask__c,
														NotifyTaskOwner__c,
														Comments__c,
														Committed__c,
														CostAccruals__c,
														EarnedValueSnapshot__c,
														TaskTotalApprovedCostSnapshot__c,
														SnapshotDate__c,
                                                        ProjectTask__r.Name
													FROM EarnedValueTask__c
													WHERE SnapshotDate__c = :snapShotDateValue  
													AND EarnedValueHeader__c = :evHeaderId];
		*/
		Map<Id, Decimal> mapPriorSnapShotTasks = getPriorEVTaskPercentComplete();

/*
		if(!snapShotTasks.isEmpty()){
			Set<Id> taskIds = new Set<Id>();
    		Map<Id, Boolean> mapNotifyOwner = new Map<Id, Boolean>();
    		Map<Id, EarnedValueTask__c> mapEVTasks = new Map<Id, EarnedValueTask__c>();
    		
    		for(EarnedValueTask__c snapShotTask : snapShotTasks){
    			taskIds.add(snapShotTask.ProjectTask__c);
    			mapNotifyOwner.put(snapShotTask.ProjectTask__c, snapShotTask.NotifyTaskOwner__c);
    			mapEVTasks.put(snapShotTask.ProjectTask__c, snapShotTask);
    		}
    		*/

    		Datetime startOfTime = DateTime.newInstance(1900, 1 , 1);
    		List<pse__Project_Task__c> tasks = ECO_Service_ProjectSync.GetOracleProjectTaskRecordsNew(projectId, startOfTime, snapShotDateValue);
    		Id currUserId = UserInfo.getUserId();
    		
	    	for (pse__Project_Task__c task : tasks) {
	    		for (EarnedValueTask__c evTask : task.Earned_Value_Tasks__r) {
	    		// if (taskIds.contains(task.Id)) {
		    		ProjectTaskWrapper wrapper = new ProjectTaskWrapper();
		    		wrapper.task = task;
		    		wrapper.isSelected = true;	//since it's a continuation
		    		// wrapper.notifyOwnerOnCreate = mapNotifyOwner.get(task.Id);
		    		wrapper.notifyOwnerOnCreate = evTask.NotifyTaskOwner__c;
		    		wrapper.disableSelect = true;
		    		// wrapper.earnedValueTask = mapEVTasks.get(task.Id);
		    		wrapper.earnedValueTask = evTask;
		    		// Id snapshotId = mapEVTasks.get(task.Id).EarnedValueSnapshot__c;
		    		wrapper.earnedValueSnapshot = mapTaskToSnapshots.get(task.Id);
		    		if (wrapper.earnedValueTask.TaskTotalApprovedCostSnapshot__c != null && wrapper.earnedValueTask.PercentComplete__c != null) {
		    			Decimal calcEarnedValue = wrapper.earnedValueTask.TaskTotalApprovedCostSnapshot__c * (wrapper.earnedValueTask.PercentComplete__c / 100);		    				
		    			wrapper.earnedValue = calcEarnedValue.setScale(2);
		    		}
		    			
		    		if (mapPriorSnapShotTasks.containsKey(task.Id)) {
		    			wrapper.priorComplete = mapPriorSnapShotTasks.get(task.Id);
		    		} else {
		    			wrapper.priorComplete = 0;
		    		}	    			

					wrapper.canEdit = true;
		    		results.add(wrapper);
	    		// }
	    		} // end of for loop of ev tasks for each project task	    			
	    	} // end of for loop of tasks
		// } // end of snapshot tasks not empty
    	return results;
    }
	
	// TODO: refactor this method, don't change it but create a new method with the suffix New
    private List<ProjectTaskWrapper> getProjectTasksForSnapshotDateOld(String snapShotDate){
    	List<ProjectTaskWrapper> results = new List<ProjectTaskWrapper>();
    	Set<Id> snapShotIds = new Set<Id>();
    	Map<Id, EarnedValueSnapshot__c> mapTaskToSnapshots = getMapOfProjectTaskIdToSnapshotForSnapshotDate(selectedSnapshotDate);
    	
		system.debug('getProjectTasksForSnapshotDate - snapShotDate = ' + snapShotDate);
		Date snapShotDateValue = Date.valueOf(snapShotDate);
	
    	List<EarnedValueTask__c> snapShotTasks = [SELECT Id,
														PercentComplete__c,
														ProjectTask__c,
														NotifyTaskOwner__c,
														Comments__c,
														Committed__c,
														CostAccruals__c,
														EarnedValueSnapshot__c,
														TaskTotalApprovedCostSnapshot__c,
														SnapshotDate__c,
                                                        ProjectTask__r.Name
													FROM EarnedValueTask__c
													WHERE SnapshotDate__c = :snapShotDateValue  
													AND EarnedValueHeader__c = :evHeaderId];

		Map<Id, Decimal> mapPriorSnapShotTasks = getPriorEVTaskPercentComplete();

		if(!snapShotTasks.isEmpty()){
			Set<Id> taskIds = new Set<Id>();
    		Map<Id, Boolean> mapNotifyOwner = new Map<Id, Boolean>();
    		Map<Id, EarnedValueTask__c> mapEVTasks = new Map<Id, EarnedValueTask__c>();
    		
    		for(EarnedValueTask__c snapShotTask : snapShotTasks){
    			taskIds.add(snapShotTask.ProjectTask__c);
    			mapNotifyOwner.put(snapShotTask.ProjectTask__c, snapShotTask.NotifyTaskOwner__c);
    			mapEVTasks.put(snapShotTask.ProjectTask__c, snapShotTask);
    		}

    		Datetime startOfTime = DateTime.newInstance(1900, 1 , 1);
    		List<pse__Project_Task__c> tasks = ECO_Service_ProjectSync.GetOracleProjectTaskRecords(projectId, startOfTime);
    		Id currUserId = UserInfo.getUserId();
    		
	    	for (pse__Project_Task__c task : tasks) {
	    		if (taskIds.contains(task.Id)) {
		    		ProjectTaskWrapper wrapper = new ProjectTaskWrapper();
		    		wrapper.task = task;
		    		wrapper.isSelected = true;	//since it's a continuation
		    		wrapper.notifyOwnerOnCreate = mapNotifyOwner.get(task.Id);
		    		wrapper.disableSelect = true;
		    		wrapper.earnedValueTask = mapEVTasks.get(task.Id);
		    		Id snapshotId = mapEVTasks.get(task.Id).EarnedValueSnapshot__c;
		    		wrapper.earnedValueSnapshot = mapTaskToSnapshots.get(task.Id);
		    		if (wrapper.earnedValueTask.TaskTotalApprovedCostSnapshot__c != null && wrapper.earnedValueTask.PercentComplete__c != null) {
		    			Decimal calcEarnedValue = wrapper.earnedValueTask.TaskTotalApprovedCostSnapshot__c * (wrapper.earnedValueTask.PercentComplete__c / 100);		    				
		    			wrapper.earnedValue = calcEarnedValue.setScale(2);
		    		}
		    			
		    		if (mapPriorSnapShotTasks.containsKey(task.Id)) {
		    			wrapper.priorComplete = mapPriorSnapShotTasks.get(task.Id);
		    		} else {
		    			wrapper.priorComplete = 0;
		    		}	    			

					wrapper.canEdit = true;
		    		results.add(wrapper);
	    		} // end of if taskIds contains the id of this current iteration task id	    			
	    	} // end of for loop of tasks
		} // end of snapshot tasks not empty
    	return results;
    }

    private Map<Id, Decimal> getPriorEVTaskPercentComplete(){
    	Map<Id, Decimal> results = new Map<Id, Decimal>();

		Date snapShotPriorDate = getPriorSnapShotDate();
	    system.debug('selectedSnapshotDate = ' + selectedSnapshotDate);
    	system.debug('snapShotPriorDate = ' + snapShotPriorDate);

	    if(snapShotPriorDate != null){
	    	if(allEVTasksForReport.containsKey(formatDate(snapShotPriorDate))){
                List<EarnedValueTask__c> priorSnapShotTasks = allEVTasksForReport.get(formatDate(snapShotPriorDate));
                if(!priorSnapShotTasks.isEmpty()){
                    for(EarnedValueTask__c priorSnapShotTask : priorSnapShotTasks){
                        Decimal priorComplete = 0;
                        if(priorSnapShotTask.PercentComplete__c != null){
                            priorComplete = priorSnapShotTask.PercentComplete__c;
                        }
                        results.put(priorSnapShotTask.ProjectTask__c, priorComplete);
                    }
                }
            }    	
	    	
	    	
	    }
    	return results;
    }

      


    private List<ProjectTaskWrapper> getProjectTasksForSnapshot(){
    	List<ProjectTaskWrapper> results = new List<ProjectTaskWrapper>();

    	Map<Id, EarnedValueSnapshot__c> mapTaskToSnapshots = getMapOfProjectTaskIdToSnapshotForSnapshotDate(selectedSnapshotDate);

    	for(EarnedValueSnapshot__c snapShot : evSnapshots){
    		system.debug('WeekStartDate__c = ' + formatDate(snapshot.WeekStartDate__c));
    		if(formatDate(snapshot.WeekStartDate__c) == selectedSnapshotDate){
    			mapTaskToSnapshots.put(snapShot.ProjectTask__c, snapShot);
    		}    		
    	}
 
    	List<EarnedValueTask__c> snapShotTasks = ECO_Service_EarnedValue.getEarnedValueTasksForEarnedValueSnapShot(selectedSnapshotId);
    	
    	Map<Id, Decimal> mapPriorSnapShotTasks = getPriorEVTaskPercentComplete();

    	if(!snapShotTasks.isEmpty()){
    		Set<Id> taskIds = new Set<Id>();
    		Map<Id, Boolean> mapNotifyOwner = new Map<Id, Boolean>();
    		Map<Id, EarnedValueTask__c> mapEVTasks = new Map<Id, EarnedValueTask__c>();
    		for(EarnedValueTask__c snapShotTask : snapShotTasks){
    			taskIds.add(snapShotTask.ProjectTask__c);
    			mapNotifyOwner.put(snapShotTask.ProjectTask__c, snapShotTask.NotifyTaskOwner__c);
    			mapEVTasks.put(snapShotTask.ProjectTask__c, snapShotTask);
    		}

    		Datetime startOfTime = DateTime.newInstance(1900, 1 , 1);
    		List<pse__Project_Task__c> tasks = ECO_Service_ProjectSync.GetOracleProjectTaskRecords(projectId, startOfTime);
    		Id currUserId = UserInfo.getUserId();


    		if(!tasks.isEmpty()){
	    		for(pse__Project_Task__c task : tasks){
	    			if(taskIds.contains(task.Id)){
		    			ProjectTaskWrapper wrapper = new ProjectTaskWrapper();
		    			wrapper.task = task;
		    			wrapper.isSelected = true;	//since it's a continuation
		    			wrapper.notifyOwnerOnCreate = mapNotifyOwner.get(task.Id);
		    			wrapper.disableSelect = true;
		    			wrapper.earnedValueTask = mapEVTasks.get(task.Id);
		    			if(mapPriorSnapShotTasks.containsKey(task.Id)){
		    				wrapper.priorComplete = mapPriorSnapShotTasks.get(task.Id);
		    			}else{
		    				wrapper.priorComplete = 0;
		    			}
						if((currUserId == projectManagerId) || currUserId == task.ProjectTaskOwner__c){
							wrapper.canEdit = true;
						}else{
							wrapper.canEdit = false;
						}
		    			results.add(wrapper);
	    			}	    			
	    		}
	    	}
    	}
    
	
    	return results;
    } 


    private String getLatestCompletedSnapshotDateForReport(Id reportId){
    	String result = '';
    	//ate weekOfDate = ECO_Service_EarnedValue.getLatestSnapshotDateForReport(evHeaderId);
    	Date weekOfDate = getLatestSnapshotDateForReport(reportId);
    	if(weekOfDate != null){
    		result = formatDate(weekOfDate);
    	}
    	return result;
    }


    public void applySelectedSnapShotToTasks(){

        if(allEVTasksForReport.containsKey(selectedSnapshotDate)){
            availableTasks = getProjectTasksForSnapshotDate(selectedSnapshotDate); 
            numAvailableTasks = availableTasks.size();
        }else{
            numAvailableTasks = 0;
        }
    	
    	findSelectedSnapShotPosition();
    	
    }

    public void applySelectedSnapShotToTasksForReport(){

    }

    public void clearTasks(){
    	
    	availableTasks.clear();
    	numAvailableTasks = availableTasks.size();
    	
    }

    public void reloadTasksForProject(){
    	
    	availableTasks = getProjectTasksForNewReport();
    	numAvailableTasks = availableTasks.size(); 
    	
    }

   
    public void applySelectedReportToTasks(){
    	evHeaderId = selectedExistingReportId;
		selectedSnapshotDate = getLatestCompletedSnapshotDateForReport(evHeaderId);
        system.debug('applySelectedReportToTasks - selectedSnapshotDate = ' + selectedSnapshotDate);
    	availableTasks = getProjectTasksForSnapshotDate(selectedSnapshotDate);

    	//getProjectTasksForExistingReport();
    	numAvailableTasks = availableTasks.size();
        system.debug('applySelectedReportToTasks - numAvailableTasks = ' + numAvailableTasks);
    	//select next snapshot date
        selectedSnapshotDate = formatDate(getNextSnapShotDate());

    }


    private Id checkForUrlIdParam(String param){
		Id result = null;
        if(ApexPages.currentPage().getParameters().containsKey(param)){
            result = Id.valueOf(ApexPages.currentPage().getParameters().get(param));          
        }
        return result;
    }

    private String checkForUrlParam(String param){
        String result = null;
        if(ApexPages.currentPage().getParameters().containsKey(param)){
            result = ApexPages.currentPage().getParameters().get(param);          
        }
        return result;
    }

    public PageReference createTasksForNextSnapshotDate(){

        selectedReportAction = 'append';
        selectedExistingReportId = evHeaderId;

        if(String.isEmpty(selectedSnapshotDate)){
            selectedSnapshotDate = optEarnedValueSnapshots.get(0).getValue();
        }
            
          
        Date latestSnapShotDate = getLatestSnapshotDateForReport(evHeaderId);
        if(latestSnapShotDate != null){
            selectedSnapshotDate = formatDate(latestSnapShotDate);        
            selectedSnapshotDate = formatDate(getNextSnapShotDate());
        }
        
        return CreateReport();
    }

    public PageReference CreateReport(){
    	PageReference result = null;    
    	String validationMsg = '';

    	if(selectedReportAction != 'new' && String.isEmpty(selectedExistingReportId)){
			validationMsg += 'An existing report must be selected.<br/>';
    	}
    	if(selectedReportAction == 'new' && String.isEmpty(evHeader.ReportName__c)){
			validationMsg += 'A report name is required for a new report.<br/>';
    	}
    	
    	if(!String.isEmpty(validationMsg)){
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, validationMsg));
    		return result;
    	}
    	

		Savepoint sp = Database.setSavepoint();

		try{
    	   		
    		EarnedValueSnapshot__c evSnapShot = new EarnedValueSnapshot__c();
    		Id reportForSnapShot = null;
    		if(selectedReportAction == 'new'){
				insert evHeader;
				reportForSnapShot = evHeader.Id;
    		}else{
    			reportForSnapShot = Id.valueOf(selectedExistingReportId);
    		} 	
    	
	    	
	    	Map<Id, EarnedValueSnapshot__c> mapTaskToSnapshots = getMapOfProjectTaskIdToSnapshotForSnapshotDate(selectedSnapshotDate);


			system.debug('selectedSnapshotDate = ' + selectedSnapshotDate);
			system.debug('mapTaskToSnapshots size = ' + mapTaskToSnapshots.size());

	    	List<EarnedValueTask__c> evTasks = new List<EarnedValueTask__c>();

	    	for(ProjectTaskWrapper wrapper : availableTasks){

	    		system.debug('wrapper for task ' + wrapper.task.Name + ' is selected = ' + wrapper.isSelected);

	    		if(wrapper.isSelected){

	    			EarnedValueTask__c evTask = new EarnedValueTask__c();
	    			if(mapTaskToSnapshots.containsKey(wrapper.task.Id)){
	    				evTask.EarnedValueSnapshot__c = mapTaskToSnapshots.get(wrapper.task.Id).Id;
	    			}	    			
	    			evTask.EarnedValueHeader__c = reportForSnapShot;
	    			evTask.ProjectTask__c = wrapper.task.Id;	    			
	    			evTask.NotifyUserEmail__c = wrapper.task.ProjectTaskOwner__r.Email;
	    			evTask.TaskTotalApprovedCostSnapshot__c = wrapper.task.TotalApprovedCost__c;
	    			evTask.SnapshotDate__c = Date.valueOf(selectedSnapshotDate);
	    			system.debug('evTask.NotifyUserEmail__c=' + evTask.NotifyUserEmail__c);
	    			//evTask.NotifyUserEmail__c = 'bfurdyk@centerstance.com';	//for testing
	    			if(wrapper.notifyOwnerOnCreate){
	    				evTask.NotifyTaskOwner__c = true;	//will fire workflow to email task owner 
	    			}
	    			evTasks.add(evTask);
	    		}
	    	}

	    	insert evTasks;
	    	
	    	result = new PageReference('/apex/ECO_EarnedValueReport');
	    	result.getParameters().put('id', String.valueOf(reportForSnapShot));	    	
	    	result.setRedirect(true);

	    	system.debug('url after save = ' + result.getUrl());

    	}catch(Exception e){
			Database.rollback(sp);
			throw e;		
		}

    	return result;
    }


    public PageReference returnToProject(){
    	PageReference pageRef = new PageReference('/' + projectId);
    	pageRef.setRedirect(true);
    	return pageRef;
    }

    public void saveEarnedValueTasksForSnapshot(){
   
    
    	Savepoint sp = Database.setSavepoint();

    	try{			
            update evHeader;
	
	    	List<EarnedValueTask__c> evTasksToSave = getAvailableTasksUserCanAccess();
	    	if(!evTasksToSave.isEmpty()){
                    		
				upsert evTasksToSave;
				allEVTasksForReport = getAllEarnedValueTasksBySnapshotDate();
                availableTasks = getProjectTasksForSnapshotDate(selectedSnapshotDate);
				chartJSON = createEarnedValueGoogleChartJSON();
    			cpiAndSpiJSON = createCpiAndSpiGoogleChartJSON();    			
	    	}
	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes successfully saved!' ));


    	}catch(Exception e){
    		Database.rollback(sp);
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while saving! ' + e.getMessage()));
    		throw e;
    	}   	
    	

    }

    public void commitEarnedValueTasksForSnapshot(){
    	
        	
    	Savepoint sp = Database.setSavepoint();

    	try{
            List<EarnedValueTask__c> evTasksToSave = getAvailableTasksUserCanAccess();
            if(!evTasksToSave.isEmpty()){
                Boolean tasksOK = true;
                for(EarnedValueTask__c evTask : evTasksToSave){
                    if(evTask.PercentComplete__c == null){
                        throw new ECO_EarnedvalueReportControllerException('Percent complete for task ' + evTask.ProjectTask__r.Name + ' cannot be empty!');
                    }
                }             
            }

	    	if(!evTasksToSave.isEmpty()){
	    		//todo - validation
	    		
				for(EarnedValueTask__c evTask : evTasksToSave){
		    		evTask.Committed__c = true;
		    	}
				update evTasksToSave;
                allEVTasksForReport = getAllEarnedValueTasksBySnapshotDate();
                availableTasks = getProjectTasksForSnapshotDate(selectedSnapshotDate);
				chartJSON = createEarnedValueGoogleChartJSON();
    			cpiAndSpiJSON = createCpiAndSpiGoogleChartJSON();
    			rerenderChart = true;
	    	}

	    	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes successfully committed!' ));

    	}catch(Exception e){
    		Database.rollback(sp);
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred while committing changes! ' + e.getMessage()));
    	}
    	
    	
    }

    private List<EarnedValueTask__c> getAvailableTasksUserCanAccess(){
    	List<EarnedValueTask__c> results = new List<EarnedValueTask__c>();

	    for(ProjectTaskWrapper wrapper : availableTasks){

	    	if(wrapper.canEdit){	//user can access task
	    		if(!wrapper.earnedValueTask.Committed__c){	//if input already committed skip it		    			
					results.add(wrapper.earnedValueTask);
	    		}
	    	}	    		
	    }
	    
	    return results;
    }



    private void findSelectedSnapShotPosition(){
    	
    	Integer pos = 0;
    	for(SelectOption opt : optEarnedValueSnapshots){
    		if(opt.getValue() == selectedSnapshotDate){
    			posSelectedSnapShot = pos;
    		}
    		pos++;
    	}
		
		hasPrevSnapShot = false;
    	hasNextSnapShot = false;
        if(posSelectedSnapShot == 0){
            hasPrevSnapShot = false;
        }else if(posSelectedSnapShot <= (evSnapshots.size()-1)){    		
    		hasPrevSnapShot = true;
    	}
    	if(posSelectedSnapShot >= 0 && posSelectedSnapShot < (evSnapshots.size()-1)){
			hasNextSnapShot = true;
		}
    }

    public void movePrevSnapShot(){
    	Date snapShotPriorDate = getPriorSnapShotDate();
    	selectedSnapshotDate = formatDate(snapShotPriorDate);
    	applySelectedSnapShotToTasks(); 
    	
    }

    public void moveNextSnapShot(){
    
    	Date snapShotPriorDate = getNextSnapShotDate();
    	selectedSnapshotDate = formatDate(snapShotPriorDate);    	
    	applySelectedSnapShotToTasks();
   
    }


    private Map<String, List<EarnedValueTask__c>> getAllEarnedValueTasksBySnapshotDate(){
    
    	Map<String, List<EarnedValueTask__c>> results = new Map<String, List<EarnedValueTask__c>>();
    
    	List<EarnedValueTask__c> allEVTasks = [SELECT Id,
												PercentComplete__c,
												ProjectTask__c,
												NotifyTaskOwner__c,
												Comments__c,
												Committed__c,
												CostAccruals__c,
												EarnedValueSnapshot__c,
												EarnedValueSnapshot__r.WeekStartDate__c,
												TaskTotalApprovedCostSnapshot__c,
												SnapshotDate__c
											FROM EarnedValueTask__c
											WHERE EarnedValueHeader__c = :evHeaderId
											ORDER BY SnapshotDate__c ASC];

    	if(!allEVTasks.isEmpty()){
    		for(EarnedValueTask__c evTask : allEVTasks){    			
    			String snapshotDate = formatDate(evTask.SnapshotDate__c);
    			if(results.containsKey(snapshotDate)){
    				results.get(snapshotDate).add(evTask);
    			}else{
    				List<EarnedValueTask__c> evTasksForSnapshot = new List<EarnedValueTask__c>();
    				evTasksForSnapshot.add(evTask);
    				results.put(snapshotDate, evTasksForSnapshot);
    			}
    		}
    	}

    	return results;
    }

    private Decimal getTotalBudgetForTasks(List<EarnedValueTask__c> evTasksIn){
    	Decimal result = 0;
    	
    	if(!evTasksIn.isEmpty()){
	    	for(EarnedValueTask__c evTask : evTasksIn){	
	    		if( evTask.TaskTotalApprovedCostSnapshot__c != null){
	    			result += evTask.TaskTotalApprovedCostSnapshot__c;		   
	    		}   		
	    		 	    		
	    	}
    	}  	
  

    	return result;
    }

    private Decimal calculateTotalEarnedValue(List<EarnedValueTask__c> evTasks){
    	Decimal result = 0;

    	for(EarnedValueTask__c evTask : evTasks){   		
    		system.debug('calculateTotalEarnedValue - % complete for task ' + evTask.Id + ' = ' + evTask.PercentComplete__c);
    		if(evTask.TaskTotalApprovedCostSnapshot__c != null && evTask.PercentComplete__c > 0){		
    						
    			Decimal earnedValueForTask = evTask.TaskTotalApprovedCostSnapshot__c * (evTask.PercentComplete__c / 100);
    			earnedValueForTask = earnedValueForTask.setScale(2, RoundingMode.HALF_UP);
    			system.debug('calculateTotalEarnedValue - earned value for task ' + evTask.Id + ' = ' + earnedValueForTask);
    			
    			result += earnedValueForTask;
    		}
    		
    	}

    	system.debug('calculateTotalEarnedValue - total earned value = ' + result);
    	
    	return result;
    }

    private Map<Date, Decimal> getActualCosts(List<Date> benchMarkDates, Map<String, Decimal> accruedCosts){
    	Map<Date,Decimal> results = new Map<Date,Decimal>();    

    	List<Date> sortedDates = new List<Date>();
    	for(Date weekOfDate : benchMarkDates){
			sortedDates.add(weekOfDate);
    	}
    	sortedDates.sort();
        Decimal runningTotal = 0;

    	for(Date snapshotDate : sortedDates){
    		Decimal costAccruals = 0;
    		if(mapWeekOfDateSnapshots.containsKey(snapshotDate)){
	    		List<EarnedValueSnapshot__c> snapshots = mapWeekOfDateSnapshots.get(snapshotDate);	    		
	    		for(EarnedValueSnapshot__c snapshot : snapshots){
	    			//runningTotal += snapshot.ThisWeekRunningTotalAmount__c;
                    runningTotal += snapshot.ThisWeekAmount__c;
	    		}
	    	}	
	    	String dateStr = formatDate(snapshotDate);
	    	if(accruedCosts.containsKey(dateStr)){
	    		costAccruals += accruedCosts.get(dateStr);	    			
	    	}
	    	system.debug('getActualCosts - dateStr = ' + dateStr);
	    	system.debug('getActualCosts - costAccruals = ' + costAccruals);
	    	runningTotal += costAccruals;
	    	results.put(snapshotDate, runningTotal);    	   		
    		
    	}
   
    	return results;
    }

    private Map<Date, Decimal> getPlannedValues(List<Date> benchMarkDates){
    	Map<Date,Decimal> results = new Map<Date,Decimal>();
    	
    	List<Date> sortedDates = sortDatesFromMap(mapWeekOfDateSnapshots.keySet());
        Decimal runningTotal = 0;
    	for(Date snapshotDate : sortedDates){
			
    		if(mapWeekOfDateSnapshots.containsKey(snapshotDate)){
				List<EarnedValueSnapshot__c> snapshots = mapWeekOfDateSnapshots.get(snapshotDate);	    		
	    		for(EarnedValueSnapshot__c snapshot : snapshots){
	    			//runningTotal += snapshot.ThisWeekRunningTotalAmount__c;
                    runningTotal += snapshot.ThisWeekAmount__c;
	    		}
    		}    		
    		results.put(snapshotDate, runningTotal);    	
    	}

    	return results;
    }

    private List<Date> sortDatesFromMap(Set<Date> keySetDates){
    	List<Date> sortedDates = new List<Date>();
    	for(Date dateVal : keySetDates){
			sortedDates.add(dateVal);
    	}
    	sortedDates.sort();

    	return sortedDates;
    }


    private void populateCpiData(Map<Date, Decimal> earnedValues, Map<Date, Decimal> actualCosts){
		mapDateCPI = new Map<Date, Decimal>();
		for(Date snapShotDate : earnedValues.keySet()){
			Decimal cpiValue = 0;
			Decimal earnedValue = earnedValues.get(snapShotDate);
			Decimal actualCost = actualCosts.get(snapShotDate);
			if(earnedValue > 0 && actualCost > 0){
				cpiValue = earnedValue / actualCost;
				cpiValue = cpiValue.setScale(1);
			}
			mapDateCPI.put(snapShotDate, cpiValue);
		}
    }

    private void populateSpiData(Map<Date, Decimal> earnedValues, Map<Date, Decimal> plannedValues){
    	mapDateSPI = new Map<Date, Decimal>();
    	for(Date snapShotDate : earnedValues.keySet()){
			Decimal spiValue = 0;
			Decimal earnedValue = earnedValues.get(snapShotDate);
			Decimal plannedValue = plannedValues.get(snapShotDate);
			if(earnedValue > 0 && plannedValue > 0){
				spiValue = earnedValue / plannedValue;
				spiValue = spiValue.setScale(1);
			}
			mapDateSPI.put(snapShotDate, spiValue);
		}
    }

    private String createEarnedValueGoogleChartJSON(){
    	
    	String results = '';

    	Map<String, Decimal> costAccualsPerSnapshotDate = new Map<String, Decimal>();
    	for(String snapShotDate : allEVTasksForReport.keySet()){
    		List<EarnedValueTask__c> evTasks = allEVTasksForReport.get(snapShotDate);
    		if(!evTasks.isEmpty()){
    			Decimal runningTotalCA = 0;
    			for(EarnedValueTask__c evTask : evTasks){
    				if(evTask.CostAccruals__c != null){
    					runningTotalCA += evTask.CostAccruals__c;
    				}
    			}
    			costAccualsPerSnapshotDate.put(snapShotDate, runningTotalCA);
    		}
    	}

    	
    	ChartDataWrapper wrapper = new ChartDataWrapper();

    	//chart columns
    	List<ChartColumn> chartColumns = new List<ChartColumn>();
    	ChartColumn col1 = new ChartColumn();
    	col1.id = 'snapShotDate';
    	col1.label = 'Date';
    	col1.type = 'string';
    	chartColumns.add(col1);

    	ChartColumn col2 = new ChartColumn();
    	col2.id = 'plannedValue';
    	col2.label = 'Planned Value';
    	col2.type = 'number';
    	chartColumns.add(col2);

    	ChartColumn col3 = new ChartColumn();
    	col3.id = 'actualCost';
    	col3.label = 'Actual Cost';
    	col3.type = 'number';
    	chartColumns.add(col3);

    	ChartColumn col4 = new ChartColumn();
    	col4.id = 'ev';
    	col4.label = 'Total Earned Value';
    	col4.type = 'number';
    	chartColumns.add(col4);

    	ChartColumn col5 = new ChartColumn();
    	col5.id = 'targetBudget';
    	col5.label = 'Total Budget';
    	col5.type = 'number';
    	chartColumns.add(col5);
    	
    	ChartColumn col6 = new ChartColumn();
    	col6.id = 'trendEAC1';
    	col6.label = 'Trend EAC1';
    	col6.type = 'number';
    	chartColumns.add(col6);

    	wrapper.cols = chartColumns;

    	//set up dates used in chart
    	Boolean projectEndDateFound = false;
    	List<Date> benchMarkDates = new List<Date>();
    	
    	//Date projectTargetEndDate = project.pse__End_Date__c;
    	Date projectStartDate = project.pse__Start_Date__c;
		Date projectTargetEndDate = project.EstimatedEndDate__c;


		system.debug('projectStartDate = ' + projectStartDate);
		system.debug('projectTargetEndDate = ' + projectTargetEndDate);    	
		benchMarkDates.add(projectStartDate);

    	//add snapshot as of dates    
    	Date snapShotDate = project.pse__Start_Date__c;

    	if(!mapWeekOfDateSnapshots.isEmpty()){
    		
    		//sort snapshot dates
    		List<Date> sortedDates = new List<Date>();
    		for(Date weekOfDate : mapWeekOfDateSnapshots.keySet()){
				sortedDates.add(weekOfDate);
    		}
    		sortedDates.sort();


    		for(Date weekOfDate : sortedDates){
    			snapShotDate = weekOfDate;
    			system.debug('createEarnedValueGoogleChartJSON -  snapShotDate = ' + snapShotDate);
    			benchMarkDates.add(snapShotDate);
    			if(snapShotDate == projectTargetEndDate){
	    			projectEndDateFound = true;
	    		}
    		}
    		
    	}
    	
    	//get planned value data
    	mapDatePlannedValues = getPlannedValues(benchMarkDates);

    	//get actual cost Database
		mapDateActualCosts =	getActualCosts(benchMarkDates, costAccualsPerSnapshotDate);

		//holder for earned values
		mapDateEarnedValues = new Map<Date, Decimal>();

    	//create chart columns for timespan between last snapshot and project completion date to give chart true perspective
    	Integer daysLeft = snapShotDate.daysBetween(projectTargetEndDate);
    	system.debug('daysLeft = ' + daysLeft);
    	if(daysLeft > 7){    	
    		Integer dayCount = 0;
    		While(dayCount < daysLeft){
    			snapShotDate = snapShotDate.addDays(7);
    			system.debug('snapShotDate = ' + snapShotDate);
    			benchMarkDates.add(snapShotDate);    		
    			dayCount = dayCount + 7;
    		}
    	}
    	
    	//add project end date
    	if(!projectEndDateFound){
    		benchMarkDates.add(projectTargetEndDate);
    	}
    	benchMarkDates.sort();
		
    	


    	List<ChartRow> chartRows = new List<ChartRow>();

    	Boolean doGetTotalBudgetForTasks = true;
    	Decimal totalBudget = 0;

    	//add chart points (aka rows) for planned value, actual cost, earned value
	    Integer chartPos = 0;


	    for(Date benchMarkDate : benchMarkDates){

	    	system.debug('benchMarkDate = ' + benchMarkDate);
			ChartRow row = new ChartRow();
	    	List<ChartRowInfo> rowInfo = new List<ChartRowInfo>();
	    	
	    	//bench mark date row info
	    	ChartRowInfo info_BenchMarkDate = new ChartRowInfo();
	    	info_BenchMarkDate.v = formatDate(benchMarkDate);
	    	rowInfo.add(info_BenchMarkDate);

			//add planned value
	    	Decimal plannedValue = mapDatePlannedValues.get(benchMarkDate);
	    	ChartRowInfo info_PlannedValue = new ChartRowInfo();
	    	info_PlannedValue.v = plannedValue;
	    	rowInfo.add(info_PlannedValue);

	    	//add actual cost
	    	Decimal actualCost = mapDateActualCosts.get(benchMarkDate);
	    	ChartRowInfo info_ActualCost = new ChartRowInfo();
	    	info_ActualCost.v = actualCost;
	    	rowInfo.add(info_ActualCost);
	
	    	//add earned value (if it exists for that date)
			ChartRowInfo info_EarnedValue = new ChartRowInfo();
			//if(chartPos == 0){
			if(benchMarkDate == projectStartDate){
				info_EarnedValue.v = 0;
			}else{

				
				if(allEVTasksForReport.containsKey(formatDate(benchMarkDate))){

		    		List<EarnedValueTask__c> evTasks = allEVTasksForReport.get(formatDate(benchMarkDate));

		    		system.debug(' evTasks.size = ' + evTasks.size());
		    		
		    		if(doGetTotalBudgetForTasks){
		    			totalBudget = getTotalBudgetForTasks(evTasks);
		    			system.debug('totalBudget = ' + totalBudget);
		    			doGetTotalBudgetForTasks = false;
		    		}		    		

		    		//calculate total earned value for the asOfDate based on the individual tasks
		   			Decimal earnedValueForSnapshot = calculateTotalEarnedValue(evTasks);
		    		info_EarnedValue.v = earnedValueForSnapshot;

		    		mapDateEarnedValues.put(benchMarkDate, earnedValueForSnapshot);
		    		
		    	}else{
		    		//create spacer
		    		info_EarnedValue.v = null;
		    	}
		    	
			}	    	
	    	rowInfo.add(info_EarnedValue);

	    	//add spacers for target date/project cost unless the date is the project end date - how we display the target point on the graph
	    	
	    	ChartRowInfo info_ProjectTartgetPoint = new ChartRowInfo();
	    	if(benchMarkDate == projectTargetEndDate){
	    		info_ProjectTartgetPoint.v = totalBudget;
	    	}else{
	    		info_ProjectTartgetPoint.v = null;
	    	}
	    	rowInfo.add(info_ProjectTartgetPoint);
	    	
	    	//add trend eac1
	    	ChartRowInfo infoTrendEAC1 = new ChartRowInfo();
	    	infoTrendEAC1.v = 200000.00;
	    	rowInfo.add(infoTrendEAC1);
			
	    	row.c = rowInfo;
	
	    	chartRows.add(row);
	    	  
	    }

    	wrapper.rows = chartRows;

    	results = JSON.serialize(wrapper);

		//create data used with cpi and spi
		populateCpiData(mapDateEarnedValues, mapDateActualCosts);
		populateSpiData(mapDateEarnedValues, mapDatePlannedValues);

    	return results;

    }

    private String createCpiAndSpiGoogleChartJSON(){

    	String results = '';

    	ChartDataWrapper wrapper = new ChartDataWrapper();

    	//chart columns
    	List<ChartColumn> chartColumns = new List<ChartColumn>();
    	ChartColumn col1 = new ChartColumn();
    	col1.id = 'snapShotDate';
    	col1.label = 'Date';
    	col1.type = 'string';
    	chartColumns.add(col1);

    	ChartColumn col2 = new ChartColumn();
    	col2.id = 'cpi';
    	col2.label = 'CPI Value';
    	col2.type = 'number';
    	chartColumns.add(col2);

    	ChartColumn col3 = new ChartColumn();
    	col3.id = 'spi';
    	col3.label = 'SPI Value';
    	col3.type = 'number';
    	chartColumns.add(col3);

    	wrapper.cols = chartColumns;

    	List<ChartRow> chartRows = new List<ChartRow>();

    	//extract benchmark dates - cpi and spi data maps should have identical values
    	List<Date> benchMarkDates = sortDatesFromMap(mapDateCPI.keySet());
    	for(Date benchMarkDate : benchMarkDates){

    		ChartRow row = new ChartRow();
	    	List<ChartRowInfo> rowInfo = new List<ChartRowInfo>();
	    	
	    	//bench mark date row info
	    	ChartRowInfo info_BenchMarkDate = new ChartRowInfo();
	    	info_BenchMarkDate.v = formatDate(benchMarkDate);
	    	rowInfo.add(info_BenchMarkDate);

			//add cpi value
	    	Decimal cpiValue = mapDateCPI.get(benchMarkDate);
	    	ChartRowInfo info_CpiValue = new ChartRowInfo();
	    	info_CpiValue.v = cpiValue;
	    	rowInfo.add(info_CpiValue);

	    	//add spi value
	    	Decimal spiValue = mapDateSPI.get(benchMarkDate);
	    	ChartRowInfo info_SpiValue = new ChartRowInfo();
	    	info_SpiValue.v = spiValue;
	    	rowInfo.add(info_SpiValue);

	    	row.c = rowInfo;
	
	    	chartRows.add(row);
    	}

    	wrapper.rows = chartRows;

    	results = JSON.serialize(wrapper);

    	return results;

    }

    private String formatDate(Date dateIn){
    	String result = '';
    	String year = String.valueOf(dateIn.year());

    	String month = '0';
    	if(dateIn.month() < 10){
    		month += String.valueOf(dateIn.month());
    	}else{
    		month = String.valueOf(dateIn.month());
    	}
    	String day = '0';
    	if(dateIn.day() < 10){
    		day += String.valueOf(dateIn.day());
    	}else{
    		day = String.valueOf(dateIn.day());
    	}
    	result = year + '-' + month + '-' + day;
    	return result;
    }

    public class ChartDataWrapper {
    	public List<ChartColumn> cols {get;set;}
    	public List<ChartRow> rows {get;set;}
    }
 
 	public class ChartColumn {
 		public String id {get;set;}
 		public String label {get;set;}
 		public String type {get;set;}
 	}

 	public class ChartRow {
 		public List<ChartRowInfo> c {get;set;}
 	}

 	public class ChartRowInfo{
 		public Object v {get;set;}
 	}


    public class ProjectTaskWrapper{

    	public ProjectTaskWrapper(){

    	}

    	public pse__Project_Task__c task {get;set;}
    	public BudgetTask__c budgetTask {get;set;}
    	public Boolean isSelected {get;set;}
    	public Boolean notifyOwnerOnCreate {get;set;}
    	public Boolean disableSelect {get;set;}
    	public Decimal priorComplete {get;set;}
    	public EarnedValueTask__c earnedValueTask {get;set;}
    	public Decimal earnedValue {get;set;}
    	public Boolean canEdit {get;set;}
    	public EarnedValueSnapshot__c earnedValueSnapshot {get;set;}

    }

    public class ECO_EarnedvalueReportControllerException extends Exception{

    }
}