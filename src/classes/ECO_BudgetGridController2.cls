/* Author: Michael Lawrence */
public with sharing class ECO_BudgetGridController2 {
	
	private class BudgetGridControllerException extends Exception {}
	
	public pse__Proj__c theProject 										{ get; set; }
	public ECO_Service_Budget2.BudgetHolder theBudgetHolder				{ get; set; }
	public String selectedType											{ get; set; }
	public List<SelectOption> availableTypes							{ get; set; }
	
	public BudgetAssignment__c newBudgetLine							{ get; set; }
	public BudgetResource__c newBudgetColumn							{ get; set; }
	public BudgetTask__c newBudgetTask									{ get; set; }
	public BudgetTask__c editBudgetTask									{ get; set; }
	public BudgetHeader__c newBudgetHeader								{ get; set; }
	
	public Boolean showAddResourceBoolean								{ get; set; }
	public Boolean showAddResourcePerson								{ get; set; }
	public Boolean showAddResourceSub									{ get; set; }
	public Boolean showAddResourceFEEODC								{ get; set; }
	public Boolean showAddResourceContingency							{ get; set; }
	public Boolean showProjectTaskModalBoolean							{ get; set; }
	public Boolean showAddTaskBoolean									{ get; set; }
	public Boolean showAddChangeOrderBoolean							{ get; set; }
	public Boolean showSortColumnsBoolean								{ get; set; }
	
	public Id selectedProjectTaskId										{ get; set; }
	public String selectedResourceName									{ get; set; }
	public Id selectedVersionId											{ get; set; }
	public Id selectedColumnId											{ get; set; }
	public Id selectedTaskId											{ get; set; }
	public Id submitForApprovalId										{ get; set; }
	public String selectedChangeManagerId								{ get; set; }
	
	public List<Id> peopleColumns										{ get; set; }
	public List<Id> subColumns											{ get; set; }
	public List<Id> feeColumns											{ get; set; }
	public List<Id> contingencyColumns									{ get; set; }
	public TotalsColumn personTotalColumn								{ get; set; }
	public TotalsColumn subTotalColumn									{ get; set; }
	public TotalsColumn feeTotalColumn									{ get; set; }
	public TotalsColumn contingencyTotalColumn							{ get; set; }
	public TotalsColumn totalTotalColumn								{ get; set; }
	
	public List<SelectOption> allProjectTeamMembers						{ get; set; }
	public List<Id> orderedTaskList										{ get; set; }
	
	public ECO_Service_Actuals.ActualsHolder actualsHolder				{ get; set; }	
	
	private Boolean isThisFirstBudget;
	private Id globalTaskId; // This is used for 'project level' budgets

	public String[] peopleColumnList {get; set;}
	public String[] subColumnList {get; set;}
	public String[] feeColumnList {get; set;}
	public String[] contingencyColumnList {get; set;}

	public List<SelectOption> peopleColumnOptions {get; set;}
	public List<SelectOption> subColumnOptions {get; set;}
	public List<SelectOption> feeColumnOptions {get; set;}
	public List<SelectOption> contingencyColumnOptions {get; set;}

	public List<SelectOption> businessLineChoices {get; set;}
	public List<SelectOption> regionChoices {get; set;}

	public String businessLineSelection {get; set;}
	public String regionSelection {get; set;}

	public List<SelectOption> jobNameChoices {get; set;}
	public String jobNameSelections {get; set;}
	public String jobNameJSON {get; set;}
	public String jobNameFilter {get; set;}

	public String averageCostRate {get; set;}

	public String currentAddResourceTab {get; set;}

	public List<WeeklyRollupEntry__c> lWeeklyRollupEntries {get; set;}

	public ECO_BudgetGridController2 (ApexPages.StandardController con) {
		theProject = ECO_Service_Projects.getProjectById(con.getId());

		getWeeklyRollups(con.getId());
		
		populateJobNameChoices();
		populateOrganizationStrings();

		populateProjectTeam();
		
		actualsHolder = ECO_Service_Actuals.getActualsForProjectId(theProject.Id);
		
		if (theProject.BudgetHeaders__r.isEmpty()) {
			isThisFirstBudget = true;
		} else {
			isThisFirstBudget = false;
			selectedVersionId = theProject.BudgetHeaders__r[0].Id;
		}
		
		availableTypes = new List<SelectOption>();
		availableTypes.add(new SelectOption('Raw Cost', 'Raw Cost'));
		availableTypes.add(new SelectOption('FBLR', 'FBLR'));
		
		selectedType = 'FBLR';
		
		showAddResourceBoolean = false;
		showAddChangeOrderBoolean = false;
		showSortColumnsBoolean = false;
		
		averageCostRate='$0';

		currentAddResourceTab = 'tabs-1';
	}

	private void getWeeklyRollups(Id sProjectId) {
			lWeeklyRollupEntries = new list<WeeklyRollupEntry__c>([
		SELECT Id
			 , Revenue__c
			 , AcctBurdenedCost__c
			 , AcctRawCost__c
			 , ApprovedCost__c
			 , PeriodStartDate__c
			 , OverrideRevenue__c
			 , OverrideAcctBurdenedCost__c
			 , OverrideAcctRawCost__c
			 , OverrideApprovedCost__c
			 , AppliedRevenue__c
			 , AppliedAcctBurdenedCost__c
			 , AppliedAcctRawCost__c
			 , AppliedApprovedCost__c
			 , ProjectFunctionalBurdenedCost__c
			 , EarnedValue__c
			 , CPI__c
			 , SPI__c
		FROM WeeklyRollupEntry__c
		WHERE
			Project__c = :sProjectId
		ORDER BY
			CompositeKey__c ASC]);
	}

	public Double computeAverageCostRate() {
		populateOrganizationStrings();

		String soql = 'select id, pse__Default_Cost_Rate__c from Contact where JobName__c = :jobNameSelections';

		if ((businessLineSelection != null) && (businessLineSelection != '')) {
			soql += ' and OrganizationBusinessLine__c = :businessLineSelection';
		}

		if ((regionSelection != null) && (regionSelection != '')) {
			soql += ' and OrganizationRegion__c = :regionSelection';
		}

		List<Contact> contacts = null;

		try {
			contacts = Database.query(soql);
		} catch (Exception ex) {

		}

		Double acc = 0;
		Double ct = 0;

		for (Contact con : contacts) {
			if (con.pse__Default_Cost_Rate__c > 0) {
				acc += con.pse__Default_Cost_Rate__c;
				ct++;
			}
		}

		if (ct > 0) {
			averageCostRate = String.valueOf(acc);
		} else {
			averageCostRate = '$0';
		}

		if (ct > 0)
			return acc / ct;

		return 0.0;	
	}

	public void populateOrganizationStrings() {
		Map<String, String> businessLineMap = new Map<String, String>();
		Map<String, String> regionMap = new Map<String, String>();

		if ((jobNameSelections == null) || (jobNameSelections.trim().equals(''))) {
			List<OrganizationString__c> orgStrings = [select id, BusinessLineName__c, Region__c from OrganizationString__c where (BusinessLineName__c != null) or (Region__c != null)];

			for (OrganizationString__c orgString : orgStrings) {
				if (orgString.BusinessLineName__c != null)
					businessLineMap.put(orgString.BusinessLineName__c, orgString.id);

				if (orgString.Region__c != null)
					regionMap.put(orgString.Region__c, orgString.id);	
			}
		} else {
			List<Contact> contacts = [select id, OrganizationBusinessLine__c, OrganizationRegion__c from Contact where JobName__c = :jobNameSelections and ((OrganizationBusinessLine__c != null) or (OrganizationRegion__c != null))];

			for (Contact con : contacts) {
				if (con.OrganizationBusinessLine__c != null)
					businessLineMap.put(con.OrganizationBusinessLine__c, con.OrganizationBusinessLine__c);

				if (con.OrganizationRegion__c != null)
					regionMap.put(con.OrganizationRegion__c, con.OrganizationRegion__c);	
			}
		}

		List<String> businessLineList = new List<String>(businessLineMap.keySet());
		List<String> regionList = new List<String>(regionMap.keySet());

		businessLineList.sort();
		regionList.sort();

		businessLineChoices = new List<SelectOption>();

		businessLineChoices.add(new SelectOption('', 'Select Business Line (optional)'));

		for (String s : businessLineList) {
			businessLineChoices.add(new SelectOption(businessLineMap.get(s), s));
		}

		regionChoices = new List<SelectOption>();

		regionChoices.add(new SelectOption('', 'Select Region (optional)'));

		for (String s : regionList) {
			regionChoices.add(new SelectOption(regionMap.get(s), s));
		}
	}

	private void populateJobNameChoices() {
		jobNameChoices = new List<SelectOption>();

/*
		Schema.DescribeFieldResult fieldResult = Contact.JobName__c.getDescribe();
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
   		Map<String, String> mapt = new Map<String, String>();
   		List<String> listt = new List<String>();

   		for (Schema.PicklistEntry f : ple) {
   			mapt.put(f.getLabel(), f.getValue());
   			listt.add(f.getLabel());
   		}       

   		listt.sort();

   		for (String s : listt) {
      		jobNameChoices.add(new SelectOption(s, mapt.get(s)));
   		}
*/

/*
		List<Contact> contacts = [select id, JobName__c from Contact where JobName__c != '' limit 5000];

		Set<String> jobs = new Set<String>();

		for (Contact con : contacts) {
			jobs.add(con.JobName__c);
		}

		List<String> listt = new List<String>(jobs);
*/

		Map<String, ECO_Job_Name__c> jobNames = ECO_Job_Name__c.getAll();

		List<String> listt = new List<String>();

		for (ECO_Job_Name__c jobName : jobNames.values()) {
			listt.add(jobName.name__c);
		}

		listt.sort();

		jobNameJSON = '[';

		Boolean first = true;

		for (String s : listt) {
			if (s.indexOf('"') != -1)
				continue;  // TODO - probably shouldn't skip, maybe escape is a better option

			if (!first)
				jobNameJSON += ',';

			jobNameJSON += '"' + s + '"';

			first = false;

			//jobNameChoices.add(new SelectOption(s, s));
		}

		jobNameJSON += ']';
   	}
	
	private void fixActualsPerTaskHolder () {
		for (BudgetTask__c bt : theBudgetHolder.taskMap.get(selectedVersionId).values()) {
			if (!actualsHolder.taskPerTypeTotalMap.keySet().contains(bt.ProjectTask__c)) {
				actualsHolder.taskPerTypeTotalMap.put(bt.ProjectTask__c, new ECO_Service_Actuals.PerTaskActualsHolder());
			}
		}
	}
	
	public PageReference goToQuestionnaire () {
		PageReference pr = Page.ECO_BudgetQuestionnaire;
		pr.getParameters().put('retURL', '/apex/ECO_BudgetGrid2?id='+theProject.Id);
		pr.getParameters().put('id', theProject.Id);
		return pr;
	}
	
	public PageReference onLoad () {
		if (theProject.DateLastCompletedBudgetQuestionnaire__c == null) {
			return goToQuestionnaire();
		}
		
		if (isThisFirstBudget) {
			BudgetHeader__c bv = new BudgetHeader__c();
			bv.Project__c = theProject.Id;
			bv.BudgetName__c = 'Baseline';
			bv.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Baseline');
			bv.Status__c = ECO_DTO_BudgetHeader.STATUS_ESTIMATE;
			insert bv; 
			
			if ('Project Level'.equalsIgnoreCase(theProject.BudgetStrategy__c)) {
				BudgetTask__c newBTask = new BudgetTask__c();
				newBTask.BudgetHeader__c = bv.Id;
				newBTask.TaskName__c = 'Global Task';
				newBTask.IsHidden__c = true;
				insert newBTask;
			}
			
			selectedVersionId = bv.Id;
			
			copySecondmentsToFees();
		}
		
		refreshBudgetHolder();
		
		return null;
	}
	
	private void copySecondmentsToFees () {
		List<BudgetResource__c> newFeesToInsert = new List<BudgetResource__c>();
		for (RelocationSecondment__c rs : [SELECT Id
												, Name
												, EstimatedCost__c
												, HomeLocation__c
												, Name__c
												, Project__c
												, SecondmentLocation__c 
											FROM RelocationSecondment__c 
											WHERE Project__c = :theProject.Id]) {
			BudgetResource__c newFee = new BudgetResource__c();
			newFee.BudgetHeader__c = selectedVersionId;
			newFee.OverrideRawCost__c = rs.EstimatedCost__c;
			newFee.ResourceName__c = rs.Name__c + ' - ' + rs.SecondmentLocation__c;
			newFee.ResourceType__c = 'ODC/FEE';
			newFeesToInsert.add(newFee);
		}
		
		if (!newFeesToInsert.isEmpty()) {
			insert newFeesToInsert;
		}
	}
	
	public PageReference showCreateChangeOrder () {
		showAddChangeOrderBoolean = true;
		newBudgetHeader = new BudgetHeader__c();
		return null;
	}
	
	public PageReference copyContingencyFromRiskRegister () {
		System.savePoint sp = Database.setSavepoint();
		try {
			Id budgetHeaderId = theBudgetHolder.versionMap.get(selectedVersionId).Id;
			List<Risk__c> riskList = [SELECT Id 
											, Name
											, ContingencyDollars__c
										FROM Risk__c 
										WHERE Project__c = :theProject.Id];
			
			List<BudgetResource__c> budColsToInsert = new List<BudgetResource__c>();				
			List<BudgetAssignment__c> budAssignToInsert = new List<BudgetAssignment__c>();
			
			if (riskList.isEmpty()) {
				return null;
			}
			
			BudgetTask__c bt = new BudgetTask__c();
			bt.TaskName__c = 'Contingency From Risk Register';
			bt.BudgetHeader__c = budgetHeaderId;
			bt.IsHidden__c = false;
			insert bt;
			
			for (Risk__c r : riskList) {
				BudgetResource__c br = new BudgetResource__c();
				br.BudgetHeader__c = budgetHeaderId;
				br.ResourceName__c = r.Name;
				br.OverrideRatesOnLines__c = true;
				br.ResourceType__c = 'Contingency';
				br.OverrideUplift__c = 0;
				br.OverrideBillRate__c = 0;
				br.MarginType__c = 'Amount';
				budColsToInsert.add(br);
				
				BudgetAssignment__c ba = new BudgetAssignment__c();
				ba.BudgetTask__c = bt.Id;
				ba.BudgetResource__r = br;
				ba.Quantity__c = 1;
				ba.MarginType__c = 'Amount';
				ba.OverrideTotalCost__c = r.ContingencyDollars__c;
				budAssignToInsert.add(ba);
			}
			
			insert budColsToInsert;
			
			for (BudgetAssignment__c ba : budAssignToInsert) {
				ba.BudgetResource__c = ba.BudgetResource__r.Id;
			}
			
			insert budAssignToInsert;
			
			refreshBudgetHolder();
			
		} catch (Exception e) {
			Database.rollback(sp);
			ApexPages.addMessages(e);
		}
		
		return null;
	}
	
	public PageReference createChangeOrder () {
		
		system.savePoint sp = Database.setSavepoint();
		try {
			doSaveAction();  // Save this budget before we create a change order
			
			newBudgetHeader.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'Change Order');
			newBudgetHeader.Project__c = theProject.Id;
			newBudgetHeader.Status__c = ECO_DTO_BudgetHeader.STATUS_ESTIMATE;
			insert newBudgetHeader;
			
			if ('Project Level'.equalsIgnoreCase(theProject.BudgetStrategy__c)) {
				BudgetTask__c newBTask = new BudgetTask__c();
				newBTask.BudgetHeader__c = newBudgetHeader.Id;
				newBTask.TaskName__c = 'Global Task';
				newBTask.IsHidden__c = true;
				insert newBTask;
			}
			
			selectedVersionId = newBudgetHeader.Id;
			
			copySecondmentsToFees();
			
			refreshBudgetHolder();
			
		} catch (Exception e) {
			Database.rollback(sp);
			ApexPages.addMessages(e);
		}
		
		showAddChangeOrderBoolean = false;
		
		return null;
	}
	
	public PageReference submitForApproval () {
		System.savepoint sp = Database.setSavepoint();
		try {
			
			doSaveAction();
			
			Approval.ProcessSubmitRequest submittalRequest = new Approval.ProcessSubmitRequest();
	        
	        submittalRequest.setComments('Submitting request for approval.');
	        submittalRequest.setObjectId(submitForApprovalId);
	        submittalRequest.setSubmitterId(UserInfo.getUserId());
        	submittalRequest.setSkipEntryCriteria(false);
        	
        	system.debug('About to submit for approval:  '+submittalRequest);
        	
        	Approval.ProcessResult result = Approval.process(submittalRequest);
        	
        	if (!result.isSuccess()) {
        		throw new BudgetGridControllerException ('Approval Request was not successful:  '+result.getErrors());
        	}
        	
        	refreshBudgetHolder();
        	
		} catch (Exception e) {
			system.debug('Handling Exception');
			Database.rollBack(sp);
			ApexPages.addMessages(e);
		}
		
		return null;
	}
	
	public void createInternalChange()
	{
		//theBudgetHolder.versionMap.get(submitForApprovalId).Status__c = 'Submitted for Approved'; 
		//doSaveAction();
		
		Id newChangeManagerId = ECO_Service_ChangeManager.createNewInternalChangeManagerFromBudget(submitForApprovalId, theProject.Id);
		//theBudgetHolder.budgetHeaderChangeManagerMap.put(submitForApprovalId, newChangeManagerId);
		refreshBudgetHolder();
	}
	
	public void createExternalChange()
	{	
		//theBudgetHolder.versionMap.get(submitForApprovalId).Status__c = 'Submitted for Approved'; 
		//doSaveAction();
		
		Id newChangeManagerId = ECO_Service_ChangeManager.createNewExternalChangeManagerFromBudget(submitForApprovalId, theProject.Id);
		//theBudgetHolder.budgetHeaderChangeManagerMap.put(submitForApprovalId, newChangeManagerId);
		refreshBudgetHolder();
		//PageReference changeManagerPage = new PageReference('/apex/ECO_ChangeManagerDetail?Id=' + newChangeManagerId);
		//return changeManagerPage;
	}	
	
	public PageReference viewChangeManager()
	{
		PageReference changeManagerPage = new PageReference('/apex/ECO_ChangeManagerDetail?Id=' + selectedChangeManagerId + '&mode=Edit');
		return changeManagerPage;		
	}	
	
	public PageReference copyTasksAndAssignments () {
		system.savePoint sp = Database.setSavePoint();
		try {
			List<BudgetAssignment__c> budgetLinesToInsert = new List<BudgetAssignment__c>();
			Map<Id, BudgetTask__c> budgetTasksToInsertMap = new Map<Id, BudgetTask__c>(); // id is project task Id
			
			Map<String, BudgetResource__c> budgetColumnsToInsert = new Map<String, BudgetResource__c>();
			
			system.debug('Querying for PTAs!');
			
			for (pse__Project_Task__c pt : [SELECT Id
													, Name 
													, (SELECT Id FROM pse__Immediate_Sub_Tasks__r)
											FROM pse__Project_Task__c 
											WHERE pse__Project__c = :theProject.Id]) {
				
				system.debug('pt.pse__Immediate_Sub_Tasks__r.isEmpty():  '+pt.pse__Immediate_Sub_Tasks__r.isEmpty());
				
				if (!pt.pse__Immediate_Sub_Tasks__r.isEmpty()) {
					//continue; // not bottom level, keep going  // PER CHRISTINA
				}
				BudgetTask__c bt = new BudgetTask__c();
				bt.ProjectTask__c = pt.Id;
				bt.BudgetHeader__c = selectedVersionId;
				bt.TaskName__c = pt.Name;
				budgetTasksToInsertMap.put(pt.Id, bt);
			}
			
			for (pse__Project_Task_Assignment__c pta : [SELECT Id 
																, pse__External_Resource__c
																, pse__Resource__c
																, pse__Resource__r.Name
																, pse__Project_Task__c
														FROM pse__Project_Task_Assignment__c 
														WHERE pse__Project_Task__c IN :budgetTasksToInsertMap.keySet()]) {
				system.debug('pta.pse__Resource__c:  '+pta.pse__Resource__c);
				system.debug('pta.pse__External_Resource__c:  '+pta.pse__External_Resource__c);					
				String ptaKey = (pta.pse__Resource__c != null) ? String.valueOf(pta.pse__Resource__c): pta.pse__External_Resource__c;
				system.debug('ptaKey:  '+ptaKey);
				
				if (!budgetColumnsToInsert.keySet().contains(ptaKey)) {
					// Doesn't contain it yet, let's add it.
					BudgetResource__c newBCInMap = new BudgetResource__c();
					newBCInMap.BudgetHeader__c = selectedVersionId;
					newBCInMap.ResourceType__c = 'Labor/Person';
					newBCInMap.ResourceName__c = (pta.pse__Resource__c != null) ? pta.pse__Resource__r.Name : pta.pse__External_Resource__c;
					newBCInMap.OverrideRatesOnLines__c = true;
					newBCInMap.Resource__c = pta.pse__Resource__c;
					budgetColumnsToInsert.put(ptaKey, newBCInMap);
				}
				
				BudgetResource__c newBCOutMap = budgetColumnsToInsert.get(ptaKey);
				
				BudgetAssignment__c newBL = new BudgetAssignment__c();
				newBL.ProjectTaskAssignment__c = pta.Id;
				newBL.BudgetResource__r = newBCOutMap;
				if (budgetTasksToInsertMap.get(pta.pse__Project_Task__c) != null) {
					newBL.BudgetTask__r = budgetTasksToInsertMap.get(pta.pse__Project_Task__c);
				}
				budgetLinesToInsert.add(newBL);
			}
			
			system.debug('Updating Version:  '+theBudgetHolder.versionMap);
			update theBudgetHolder.versionMap.get(selectedVersionId);
			
			system.debug('Deleting Old Info Version');
			delete [SELECT Id 
					FROM BudgetAssignment__c 
					WHERE BudgetResource__r.BudgetHeader__c = :selectedVersionId];
			delete [SELECT Id
					FROM BudgetResource__c
					WHERE BudgetHeader__c = :selectedVersionId];
			delete [SELECT Id
					FROM BudgetTask__c
					WHERE BudgetHeader__c = :selectedVersionId];
			
			if (!budgetColumnsToInsert.isEmpty()) {
				insert budgetColumnsToInsert.values();
			}
			
			if (!budgetTasksToInsertMap.isEmpty()) {
				insert budgetTasksToInsertMap.values();
			}
				
			if (!budgetLinesToInsert.isEmpty()) {
				for (BudgetAssignment__c bl : budgetLinesToInsert) {
					bl.BudgetResource__c = bl.BudgetResource__r.Id;
					bl.BudgetTask__c = bl.BudgetTask__r.Id;
				}
				insert budgetLinesToInsert;
			}
			
			refreshBudgetHolder();
		} catch (Exception e) {
			system.debug('Handled Exception:  '+e.getMessage());
			system.debug('Handled Exception.getLineNumber:  '+e.getLineNumber());
			Database.rollback(sp);
			ApexPages.addMessages(e);
		}
		
		return null;
	}
	
	public PageReference removeSingleTask () {
		System.savepoint sp = Database.setSavepoint();
		try {
			system.debug('selectedTaskId:  '+selectedTaskId);
			delete new BudgetAssignment__c(Id = theBudgetHolder.versionToColumnToTaskToCellMap.get(selectedVersionId).get(selectedColumnId).get(selectedTaskId).Id);
		} catch (Exception e) {
			ApexPages.addMessages(e);
			Database.rollBack(sp);
		}
		
		refreshBudgetHolder();
					
		return null;
	}
	
	public PageReference removeEntireRow () {
		System.savepoint sp = Database.setSavepoint();
		try {
			//List<BudgetAssignment__c> blToDelete = new List<BudgetAssignment__c>();
			//Set<Id> ptIdsToDelete = new Set<Id>();
			
			delete new BudgetTask__c(Id = selectedTaskId);
			
			// Cascade delete does this for us.
			/*
			for (Map<Id, BudgetAssignment__c> innerMap : theBudgetHolder.versionToColumnToTaskToCellMap.get(selectedVersionId).values()) {
				BudgetAssignment__c innerBl = innerMap.get(selectedTaskId);
				if (innerBl != null && innerBl.ProjectTaskAssignment__c != null) {
					ptIdsToDelete.add(innerBl.ProjectTaskAssignment__r.pse__Project_Task__c);
				}
				if (innerBl.Id != null) {
					blToDelete.add(innerBl);
				}
			}
			
			system.debug('About to Delete!!  3'+blToDelete);
			
			if (!blToDelete.isEmpty()) {
				delete blToDelete;
			}
			*/
			
			
		} catch (Exception e) {
			Database.rollback(sp);
			ApexPages.addMessages(e);
		}
		
		refreshBudgetHolder();
		
		return null;
	}
	
	public PageReference removeEntireColumn () {
		
		delete new BudgetResource__c(Id = selectedColumnId);
		
		refreshBudgetHolder();
		
		return null;
	}
	
	/*public PageReference showAddResource () {
		showAddResourceBoolean = true;
		
		newBudgetColumn = new BudgetResource__c();
		newBudgetColumn.BudgetHeader__c = selectedVersionId;
		newBudgetColumn.OverrideRatesOnLines__c = true;
		
		newBudgetLine = new BudgetAssignment__c();
		newBudgetLine.BudgetResource__r = newBudgetColumn;
		
		newProjectTaskAssignment = new pse__Project_Task_Assignment__c();
		
		return null;
	}*/
	
	public PageReference showAddTask () {
		showAddTaskBoolean = true;
		
		newBudgetTask = new BudgetTask__c();
		newBudgetTask.BudgetHeader__c = selectedVersionId;
		
		return null;
	}

	private SelectOption getSortSelectOption(Id idx) {
		String name = theBudgetHolder.columnMap.get(selectedVersionId).get(idx).ColumnHeader__c;

		if (name == null)
			name = '*** Untitled ***';

		return new SelectOption(idx, name);	
	}

	private List<SelectOption> getSortSelectOptions(List<Id> ids) {
		List<SelectOption> result = new List<SelectOption>();

		for (Id idx : ids) {
			result.add(getSortSelectOption(idx));
		}

		return result;
	}

	public PageReference showSortColumns() {
		showSortColumnsBoolean = true;

		peopleColumnOptions = getSortSelectOptions(peopleColumns);
		subColumnOptions = getSortSelectOptions(subColumns);
		feeColumnOptions = getSortSelectOptions(feeColumns);
		contingencyColumnOptions = getSortSelectOptions(contingencyColumns);

		return null;
	}


	public PageReference saveSortColumns() {
		showSortColumnsBoolean = false;

		Set<String> allColumnIds = new Set<String>();

		allColumnIds.addAll(peopleColumnList);
		allColumnIds.addAll(subColumnList);
		allColumnIds.addAll(feeColumnList);
		allColumnIds.addAll(contingencyColumnList);

		Map<Id, BudgetResource__c> budgetResources = new Map<Id, BudgetResource__c>([select id, Sort_Order_Detail__c from BudgetResource__c where id in :allColumnIds]);

		Integer i = 1;

		for (String idx : peopleColumnList) {
			budgetResources.get(idx).Sort_Order_Detail__c = i++;
		}

		i = 1;

		for (String idx : subColumnList) {
			budgetResources.get(idx).Sort_Order_Detail__c = i++;
		}

		i = 1;

		for (String idx : feeColumnList) {
			budgetResources.get(idx).Sort_Order_Detail__c = i++;
		}

		i = 1;

		for (String idx : contingencyColumnList) {
			budgetResources.get(idx).Sort_Order_Detail__c = i++;
		}

		update budgetResources.values();

		refreshBudgetHolder();

		return null;
	}
	
	public PageReference saveNewTask () {
		System.savePoint sp = Database.setSavepoint();
		try {
			
			insert newBudgetTask;
			
			
		} catch (Exception e) {
			Database.rollback(sp);
		}
		
		showAddTaskBoolean = false;
		
		refreshBudgetHolder();
		
		return null;
	}
	
	
	public PageReference saveNewResource () {
		showAddResourcePerson = false;
		showAddResourceSub = false;
		showAddResourceFEEODC = false;
		showAddResourceContingency = false;

		if ('Labor/Person'.equalsIgnoreCase(newBudgetColumn.ResourceType__c)) {
			if (currentAddResourceTab.equals('tabs-1')) {
				newBudgetColumn.OverrideBillRate__c = theProject.DefaultBillRate__c;
				newBudgetColumn.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
				newBudgetColumn.JobName__c = null;
			} else if (currentAddResourceTab.equals('tabs-2')) {

			} else if (currentAddResourceTab.equals('tabs-3')) {
				newBudgetColumn.ResourceName__c = null;
				newBudgetColumn.ProjectTeamMember__c = null;
				newBudgetColumn.OverrideRawCost__c = computeAverageCostRate();
				newBudgetColumn.JobName__c = jobNameSelections;
				newBudgetColumn.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
			}

			insert newBudgetColumn;
		} else if ('Subcontractor'.equalsIgnoreCase(newBudgetColumn.ResourceType__c)) {
			newBudgetColumn.OverrideBillRate__c = theProject.DefaultBillRate__c;
			newBudgetColumn.OverrideUplift__c = theProject.DefaultUpliftSubs__c;
			insert newBudgetColumn;
		} else if ('ODC/FEE'.equalsIgnoreCase(newBudgetColumn.ResourceType__c)) {
			newBudgetColumn.MarginType__c = 'Amount';
			newBudgetColumn.OverrideBillRate__c = theProject.DefaultBillRate__c;
			newBudgetColumn.OverrideUplift__c = theProject.DefaultUpliftODCs__c;
			
			insert newBudgetColumn;
			/*
			BudgetTask__c bt = new BudgetTask__c();
			bt.IsHidden__c = true;
			bt.TaskName__c = 'Task Line for Resource:  '+newBudgetColumn.Id;
			bt.BudgetHeader__c = selectedVersionId;
			*/
			//insert bt;
			/*
			BudgetAssignment__c ba = new BudgetAssignment__c();
			ba.Quantity__c = 1;
			ba.BudgetResource__c = newBudgetColumn.Id;
			ba.BudgetTask__c = bt.Id;
			*/
			//insert ba;
			
		} else if ('Contingency'.equalsIgnoreCase(newBudgetColumn.ResourceType__c)) {
			newBudgetColumn.MarginType__c = 'Amount';
			newBudgetColumn.OverrideBillRate__c = 0;
			
			insert newBudgetColumn;
			/*
			BudgetTask__c bt = new BudgetTask__c();
			bt.IsHidden__c = true;
			bt.TaskName__c = 'Task Line for Resource:  '+newBudgetColumn.Id;
			bt.BudgetHeader__c = selectedVersionId;
			*/
			//insert bt;
			/*
			BudgetAssignment__c ba = new BudgetAssignment__c();
			ba.Quantity__c = 1;
			ba.BudgetResource__c = newBudgetColumn.Id;
			ba.BudgetTask__c = bt.Id;
			*/
			//insert ba;
			
		}
		
		if ('Project Level'.equalsIgnoreCase(theProject.BudgetStrategy__c)) {
			selectedTaskId = globalTaskId;
			selectedColumnId = newBudgetColumn.Id; 
			assignThisResourceToExistingTask();
		}
		
		refreshBudgetHolder();
		
		return null;
	}
	
	/*public PageReference saveNewAssignment () {
		return null;
	}*/
	
	public PageReference showAddLaborPerson () {
		newBudgetColumn = new BudgetResource__c();
		newBudgetColumn.BudgetHeader__c = selectedVersionId;
		newBudgetColumn.OverrideRatesOnLines__c = true;
		newBudgetColumn.ResourceType__c = 'Labor/Person';
		
		return doNextAddResource();
	}
	
	public PageReference showAddSub () {
		newBudgetColumn = new BudgetResource__c();
		newBudgetColumn.BudgetHeader__c = selectedVersionId;
		newBudgetColumn.OverrideRatesOnLines__c = true;
		newBudgetColumn.ResourceType__c = 'Subcontractor';
		
		return doNextAddResource();
	}
	
	public PageReference showAddFee () {
		newBudgetColumn = new BudgetResource__c();
		newBudgetColumn.BudgetHeader__c = selectedVersionId;
		newBudgetColumn.OverrideRatesOnLines__c = true;
		newBudgetColumn.ResourceType__c = 'ODC/FEE';
		
		return doNextAddResource();
	}
	
	public PageReference showAddContingency () {
		newBudgetColumn = new BudgetResource__c();
		newBudgetColumn.BudgetHeader__c = selectedVersionId;
		newBudgetColumn.OverrideRatesOnLines__c = true;
		newBudgetColumn.ResourceType__c = 'Contingency';
		
		return doNextAddResource();
	}
	
	public PageReference cloneResource () {
		System.savepoint sp = Database.setSavepoint();
		
		try {
			
			BudgetResource__c sourceResource = [SELECT Id
													, Name 
													, BudgetHeader__c
													, ExternalId__c
													, MarginType__c
													, ProjectTeamMember__c
													, ResourceType__c
													, SubsAndVendors__c 
													, TotalCost__c
													, TotalRevenue__c
													, OverrideBillRate__c
													, OverrideFringeMultiplier__c
													, OverrideOverheadMultiplier__c
													, OverrideRawCost__c
													, OverrideUplift__c 
													, FullyBurdenedCostRate__c 
													, CostRate__c
													, OverrideRatesOnLines__c 
													, ResourceName__c
													, ColumnHeader__c
													, ProjectTeamMember__r.Contact__c
													, SortOrder__c
													, Sort_Order_Detail__c
													, ForeignResource__c
													, JobName__c
													, (SELECT Id 
															, Name
															, ApprovalStatus__c
															, DefaultBillRate__c
															, DefaultFringeMultiplier__c
															, DefaultOverheadMultiplier__c
															, DefaultRawCost__c
															, DefaultUplift__c
															, FullyBurdenedCost__c
															, FullyBurdenedCostRate__c
															, MarginType__c
															, OverrideBillRate__c
															, OverrideFringeMultiplier__c
															, OverrideOverheadMultiplier__c
															, OverrideRawCost__c
															, OverrideUplift__c
															, MarginAmountQtyTimesRate__c 
															, MarginAmountCostTimesUplift__c
															, Quantity__c 
															, BudgetResource__c
															, BudgetResource__r.Id
															, BudgetResource__r.BudgetHeader__c
															, BudgetTask__c
															, CalculatedRevenue__c 
															, OverrideTotalCost__c 
															, OverrideTotalRevenue__c 
															, ProjectTaskAssignment__c
															, ProjectTaskAssignment__r.Id
															, ProjectTaskAssignment__r.Name
															, ProjectTaskAssignment__r.pse__Resource_Role__c
															, ProjectTaskAssignment__r.pse__Resource_Request__c
															, ProjectTaskAssignment__r.pse__Resource__c
															, ProjectTaskAssignment__r.pse__Resource__r.Name
															, ProjectTaskAssignment__r.pse__Project_Task_Start_Date__c
															, ProjectTaskAssignment__r.pse__Project_Task_End_Date__c
															, ProjectTaskAssignment__r.pse__Project_Task__c
															, ProjectTaskAssignment__r.pse__Project_Task__r.Id
															, ProjectTaskAssignment__r.pse__Project_Task__r.Name
															, ProjectTaskAssignment__r.pse__Project_Task__r.pse__Task_Number__c
															, ProjectTaskAssignment__r.pse__Project_Task__r.WorkTypeName__c
															, ProjectTaskAssignment__r.pse__Project_Task__r.LongProjTaskName__c
															, ProjectTaskAssignment__r.pse__Project_Task__r.IsBillable__c
															, ProjectTaskAssignment__r.pse__Project_Task__r.IsChargeable__c
															, ProjectTaskAssignment__r.pse__Project_Task__r.FinancialTask__c
															, ProjectTaskAssignment__r.pse__Project_ID__c
															, ProjectTaskAssignment__r.pse__Project__c
															, ProjectTaskAssignment__r.pse__External_Resource__c
															, ProjectTaskAssignment__r.ExpenditureType__c
															, ProjectTaskAssignment__r.pse__Assignment__c
															, ProjectTaskAssignment__r.ActualCost__c
														FROM BudgetAssignments__r)
											FROM BudgetResource__c 
											WHERE Id = :selectedColumnId];
											
			BudgetResource__c clonedResource = sourceResource.clone(false, false, false, false);
			List<BudgetAssignment__c> clonedAssignments = new List<BudgetAssignment__c>();
			
			insert clonedResource;
			
			for (BudgetAssignment__c ba : sourceResource.BudgetAssignments__r) {
				BudgetAssignment__c clonedAssignment = ba.clone(false, false, false, false);
				clonedAssignment.BudgetResource__c = clonedResource.Id;
				clonedAssignments.add(clonedAssignment);
			}
			
			if (!clonedAssignments.isEmpty()) {
				insert clonedAssignments;
			}
			
			refreshBudgetHolder();
			
		} catch (Exception e) {
			system.debug('Cloning Exception:  '+e.getMessage());
			system.debug('Cloning Exception Trace:  '+e.getStackTraceString());
			Database.rollBack(sp);
			ApexPages.addMessages(e);
		}
		
		return null;
	}
	
	public PageReference doNextAddResource () {
		showAddResourceBoolean = false;
		
		if ('Labor/Person'.equalsIgnoreCase(newBudgetColumn.ResourceType__c)) {
			showAddResourcePerson = true;	
		} else if ('Subcontractor'.equalsIgnoreCase(newBudgetColumn.ResourceType__c)) {
			showAddResourceSub = true;
		} else if ('ODC/FEE'.equalsIgnoreCase(newBudgetColumn.ResourceType__c)) {
			showAddResourceFEEODC = true;
		} else if ('Contingency'.equalsIgnoreCase(newBudgetColumn.ResourceType__c)) {
			showAddResourceContingency = true;
		}
		
		return null;	
	}
	
	public PageReference assignThisResourceToExistingTask () {
		system.savePoint sp = Database.setSavePoint();
		try {
			system.debug('selectedTaskId:  '+selectedTaskId);
			system.debug('selectedColumnId:  '+selectedColumnId);
			
			newBudgetColumn = theBudgetHolder.columnMap.get(selectedVersionId).get(selectedColumnId);
			
			newBudgetLine = new BudgetAssignment__c();
			newBudgetLine.BudgetResource__c = selectedColumnId;
			newBudgetLine.BudgetTask__c = selectedTaskId;
			
			insert newBudgetLine;
			
			refreshBudgetHolder();
		} catch (Exception e) {
			Database.rollback(sp);
			ApexPages.addMessages(e);
		}
		return null;
	}
	
	public PageReference showProjectTaskModal () {
		return null;
	}
	
	public PageReference simpleRefresh () {
		return null;
	}
	
	public PageReference refreshHolder () {
		refreshBudgetHolder();
		
		return null;
	}
	
	public PageReference quickSave () {
		doSaveAction();
		return null;
	}
	
	public PageReference save () {
		doSaveAction();
		return new PageReference('/'+theProject.Id);
	}
	
	private void refreshBudgetHolder () {
		theBudgetHolder = ECO_Service_Budget2.getBudgetInfoForProject(theProject);
		
		peopleColumns = new List<Id>();
		subColumns = new List<Id>();
		feeColumns = new List<Id>();
		contingencyColumns = new List<Id>();
		
		for (BudgetResource__c br : theBudgetHolder.columnMap.get(selectedVersionId).values()) {
			if ('Labor/Person'.equalsIgnoreCase(br.ResourceType__c)) {
				peopleColumns.add(br.Id);
			} else if ('Subcontractor'.equalsIgnoreCase(br.ResourceType__c)) {
				subColumns.add(br.Id);
			} else if ('ODC/FEE'.equalsIgnoreCase(br.ResourceType__c)) {
				feeColumns.add(br.Id);
			} else {
				contingencyColumns.add(br.Id);
			}
		}
		
		buildTotalsColumns();
		fixActualsPerTaskHolder();
		orderTasks();
		
		if ('Project Level'.equalsIgnoreCase(theProject.BudgetStrategy__c)) {
			globalTaskId = theBudgetHolder.taskMap.get(selectedVersionId).values()[0].Id;  // There should only ever be a single global task for Project Level budgets
		}
	}
	
	private void doSaveAction () {
		List<BudgetAssignment__c> budgetLinesToSave = new List<BudgetAssignment__c>();
		List<BudgetResource__c> budgetColumnsToSave = new List<BudgetResource__c>();
		List<BudgetTask__c> budgetTasksToSave = new List<BudgetTask__c>();

		system.debug('theBudgetHolder.columnMap:  '+theBudgetHolder.columnMap);

		Set<Id> projectTaskIds = new Set<Id>();
		Map<Id, String> projectTaskMap = new Map<Id, String>();

		for (Map<Id, BudgetTask__c> budgetTaskMap : theBudgetHolder.taskMap.values()) {
			for (BudgetTask__c task : budgetTaskMap.values()) {
				projectTaskIds.add(task.ProjectTask__c);
				projectTaskMap.put(task.ProjectTask__c, task.ProjectTask__r.EarnedValueCurve__c);
			}
		}

		List<pse__Project_Task__c> projectTasksToUpdate = [select id, EarnedValueCurve__c from pse__Project_Task__c where id in :projectTaskIds];

		for (pse__Project_Task__c projectTask : projectTasksToUpdate) {
			projectTask.EarnedValueCurve__c = projectTaskMap.get(projectTask.id);
		}

		update projectTasksToUpdate;
		
		for (Id outerKey : theBudgetHolder.columnMap.get(selectedVersionId).keySet()) {
			
			BudgetResource__c clonedBC = theBudgetHolder.columnMap.get(selectedVersionId).get(outerKey).clone(true, true, true, true);
			
			if (clonedBC.ResourceType__c == 'Labor/Person') {
				clonedBC.OverrideBillRate__c = (clonedBC.OverrideBillRate__c == null) ? theProject.DefaultBillRate__c : clonedBC.OverrideBillRate__c;
				clonedBC.OverrideUplift__c = (clonedBC.OverrideUplift__c == null) ? theProject.DefaultUpliftLabor__c : clonedBC.OverrideUplift__c;
			} else if (clonedBC.ResourceType__c == 'Subcontractor') {
				clonedBC.OverrideBillRate__c = (clonedBC.OverrideBillRate__c == null) ? theProject.DefaultBillRate__c : clonedBC.OverrideBillRate__c;
				clonedBC.OverrideUplift__c = (clonedBC.OverrideUplift__c == null) ? theProject.DefaultUpliftSubs__c : clonedBC.OverrideUplift__c;
			} else if (clonedBC.ResourceType__c == 'ODC/FEE') {
				clonedBC.OverrideBillRate__c = (clonedBC.OverrideBillRate__c == null) ? theProject.DefaultBillRate__c : clonedBC.OverrideBillRate__c;
				clonedBC.OverrideUplift__c = (clonedBC.OverrideUplift__c == null) ? theProject.DefaultUpliftODCs__c : clonedBC.OverrideUplift__c;
			}
			budgetColumnsToSave.add(clonedBC);

			for (BudgetAssignment__c bl : theBudgetHolder.versionToColumnToTaskToCellMap.get(selectedVersionId).get(outerKey).values()) {
				//for (BudgetAssignment__c bl : innerMostMap.values()) {
					
					if (bl.BudgetResource__c != null) {
						BudgetAssignment__c clonedBL = bl.clone(true, true, false, false);
						
						//TODO: This logic should probably be in a trigger... I tried doing it with pure formulas and the circular referential nature prevented it.  *fistwave*
						if (clonedBC.OverrideRatesOnLines__c) {
							clonedBL.OverrideRawCost__c 			= clonedBC.OverrideRawCost__c;
							clonedBL.OverrideOverheadMultiplier__c 	= clonedBC.OverrideOverheadMultiplier__c;
							clonedBL.OverrideFringeMultiplier__c 	= clonedBC.OverrideFringeMultiplier__c;
							clonedBL.OverrideBillRate__c 			= clonedBC.OverrideBillRate__c;
							clonedBL.OverrideUplift__c 				= clonedBC.OverrideUplift__c;
							clonedBL.MarginType__c					= clonedBC.MarginType__c;
						}
						
						budgetLinesToSave.add(clonedBL);
					}
				//}
			}
			
		}
		
		update theProject;
		
		update theBudgetHolder.versionMap.get(selectedVersionId);
		
		update theBudgetHolder.taskMap.get(selectedVersionId).values();
		
		// Refresh project since it has rollups too
		system.debug('theProject.TotalForecastCost__c before:  '+theProject.TotalForecastCost__c);
		theProject = ECO_Service_Projects.getProjectById(theProject.Id);
		system.debug('theProject.TotalForecastCost__c after:  '+theProject.TotalForecastCost__c);
		
		system.debug('Upserting Columns:  '+budgetColumnsToSave);
		if (!budgetColumnsToSave.isEmpty()) {
			upsert budgetColumnsToSave;
		}
		
		system.debug('Upserting Lines:  '+budgetLinesToSave);
		if (!budgetLinesToSave.isEmpty()) {
			upsert budgetLinesToSave;
		}

		refreshBudgetHolder();
	}
	
	public PageReference cancelModal () {
		showAddResourcePerson = false;
		showAddResourceSub = false;
		showAddResourceFEEODC = false;
		showAddResourceContingency = false;
		//showProjectTaskModalBoolean = false;
		
		newBudgetLine = new BudgetAssignment__c();
		newBudgetColumn = new BudgetResource__c();
		//newProjectTaskAssignment = new pse__Project_Task_Assignment__c();
		
		return null;
	}
	
	public class TotalsColumn {
		public TotalsColumn () {
			rows = new Map<Id, TotalsRow>();
		}
		
		public Map<Id, TotalsRow> rows {get;set;}  // Budget Task Id key
	}
	
	public class TotalsRow {
		public TotalsRow () {
			totalBudgetCost = 0;
			totalBudgetRevenue = 0;
			totalActualCost = 0;
			totalActualRevenue = 0;
		}
		
		public Decimal totalBudgetCost {get;set;}
		public Decimal totalBudgetRevenue {get;set;}
		public Decimal totalActualCost {get;set;}
		public Decimal totalActualRevenue {get;set;}
	}
	
	private void buildTotalsColumns () {
		personTotalColumn = new TotalsColumn();
		subTotalColumn = new TotalsColumn();
		feeTotalColumn = new TotalsColumn();
		contingencyTotalColumn = new TotalsColumn();
		totalTotalColumn = new TotalsColumn();
		
		system.debug('theBudgetHolder.versionToColumnToTaskToCellMap.get(selectedVersionId).values():  '+theBudgetHolder.versionToColumnToTaskToCellMap.get(selectedVersionId).values());
		system.debug('theBudgetHolder.taskMap.get(selectedVersionId).keySet():  '+theBudgetHolder.taskMap.get(selectedVersionId).keySet());
		
		for (Id taskId : theBudgetHolder.taskMap.get(selectedVersionId).keySet()) {
			totalTotalColumn.rows.put(taskId, new TotalsRow());
			personTotalColumn.rows.put(taskId, new TotalsRow());
			subTotalColumn.rows.put(taskId, new TotalsRow());
			feeTotalColumn.rows.put(taskId, new TotalsRow());
			contingencyTotalColumn.rows.put(taskId, new TotalsRow());
		}
		
		// outer loop will be one iteration per column
		for (Map<Id, BudgetAssignment__c> taskMap : theBudgetHolder.versionToColumnToTaskToCellMap.get(selectedVersionId).values()) {
			// inner loop will be one iteration per task, per column ^^
			for (Id taskId : taskMap.keySet()) {
				
				BudgetAssignment__c thisBA = taskMap.get(taskId);
				system.debug('taskId:  '+taskId);
				system.debug('thisBA:  '+thisBA);
				
				TotalsRow thisTotalsRow;
				/*
				if (!totalTotalColumn.rows.keySet().contains(taskId)) {
					totalTotalColumn.rows.put(taskId, new TotalsRow());
					personTotalColumn.rows.put(taskId, new TotalsRow());
					subTotalColumn.rows.put(taskId, new TotalsRow());
					feeTotalColumn.rows.put(taskId, new TotalsRow());
					contingencyTotalColumn.rows.put(taskId, new TotalsRow());
				}
				*/
				if ('Labor/Person'.equalsIgnoreCase(thisBA.ResourceType__c)) {
					thisTotalsRow = personTotalColumn.rows.get(taskId);
				} else if ('Subcontractor'.equalsIgnoreCase(thisBA.ResourceType__c)) {
					thisTotalsRow = subTotalColumn.rows.get(taskId);
				} else if ('ODC/FEE'.equalsIgnoreCase(thisBA.ResourceType__c)) {
					thisTotalsRow = feeTotalColumn.rows.get(taskId);
				} else { // contingency 
					thisTotalsRow = contingencyTotalColumn.rows.get(taskId);
				}
				
				thisTotalsRow.totalBudgetCost += (thisBA.FullyBurdenedCost__c != null) ? thisBA.FullyBurdenedCost__c : 0;
				thisTotalsRow.totalBudgetRevenue += (thisBA.CalculatedRevenue__c != null) ? thisBA.CalculatedRevenue__c : 0;
				
				totalTotalColumn.rows.get(taskId).totalBudgetCost = (thisBA.FullyBurdenedCost__c != null) ? thisBA.FullyBurdenedCost__c : 0;
				totalTotalColumn.rows.get(taskId).totalBudgetRevenue = (thisBA.CalculatedRevenue__c != null) ? thisBA.CalculatedRevenue__c : 0;
				
				system.debug('personTotalColumn:  '+personTotalColumn);
			}
		}
	}
	
	private void populateProjectTeam () {
		allProjectTeamMembers = new List<SelectOption>();
		
		for (ProjectTeamMember__c ptm : [SELECT Id 
												, Role__c
												, Name__c
										FROM ProjectTeamMember__c 
										WHERE Project__c = :theProject.Id ORDER BY Name__c]) {
			String roleName = (ptm.Role__c != null) ? ptm.Role__c : 'no role';
			SelectOption option = new SelectOption(ptm.Id, ptm.Name__c + ' (' + roleName + ')');
			allProjectTeamMembers.add(option);
		}
	}
	
	private void orderTasks () {
		
		Map<Id, TaskIdHolderForOrdering> orderedTaskMap = new Map<Id, TaskIdHolderForOrdering>();
		
		Boolean foundEverything = false;
		Boolean hasChildTasks = false;
		
		// This list is ordered specifically so we get all of the top level tasks first, then the next level, then the next level
		for (BudgetTask__c bt : theBudgetHolder.taskMap.get(selectedVersionId).values()) {
			if (bt.IsTopLevelTask__c) {
				// we know this is a top level, so just add it to the map
				orderedTaskMap.put(bt.Id, new TaskIdHolderForOrdering(bt.Id));
			} else {
				hasChildTasks = true;
				// we know this is a child of something, so let's find the parent level it needs to be added to
				foundEverything = findTaskLevel(bt, orderedTaskMap);
			}
		}
		
		orderedTaskList = new List<Id>();
		enterOrderedTasksToList(orderedTaskMap);
		
		system.debug('foundEverything:  '+foundEverything);
		system.debug('orderedTaskList:  '+orderedTaskList);
		
		if (hasChildTasks && !foundEverything) {
			throw new BudgetGridControllerException('Unable to sort all tasks.');
		}	
	}
	
	private void enterOrderedTasksToList (Map<Id, TaskIdHolderForOrdering> topMap) {
		for (TaskIdHolderForOrdering holder : topMap.values()) {
			
			orderedTaskList.add(holder.thisTaskId);
			
			if (!holder.childTasks.isEmpty()) {
				enterOrderedTasksToList(holder.childTasks);
			}
		}
	}
	
	private Boolean findTaskLevel (BudgetTask__c theBT, Map<Id, TaskIdHolderForOrdering> theMap) {
		Boolean foundOne = false;
		
		Map<Id, TaskIdHolderForOrdering> parentLevelMap = theMap;
		
		//while (!foundOne) {
			if (parentLevelMap.keySet().contains(theBT.ParentTask__c)) {
				parentLevelMap.get(theBT.ParentTask__c).childTasks.put(theBT.Id, new TaskIdHolderForOrdering(theBT.Id));
				foundOne = true;
			} else {
				foundOne = findTaskLevel(theBT, parentLevelMap.get(theBT.Id).childTasks);  // send in this thing's map
			}
		//}
		
		return foundOne;
	}
	
	private class TaskIdHolderForOrdering {
		public Id thisTaskId;
		public Map<Id, TaskIdHolderForOrdering> childTasks;
		
		public TaskIdHolderForOrdering (Id theTaskId) {
			thisTaskId = theTaskId;
			childTasks = new Map<Id, TaskIdHolderForOrdering>();
		}
	}
	
	public PageReference cancel () {
		
		return new PageReference('/'+theProject.Id);
	}
	
}