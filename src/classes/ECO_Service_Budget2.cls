public without sharing class ECO_Service_Budget2 {
	
	public static BudgetHolder getBudgetInfoForProject (pse__Proj__c theProject) {
		BudgetHolder returnHolder = new BudgetHolder();
		
		// Version Id -> Column Id -> Task Id -> BudgetAssignment__c
		returnHolder.versionToColumnToTaskToCellMap = new Map<Id, Map<Id, Map<Id, BudgetAssignment__c>>>();
		returnHolder.taskMap = new Map<Id, Map<Id, BudgetTask__c>>();  // Version to Map of BTs
		returnHolder.versionMap = new Map<Id, BudgetHeader__c>(); // Version to Version
		returnHolder.columnMap = new Map<Id, Map<Id, BudgetResource__c>>();  // Version to Map of BRs
		returnHolder.sortedMapList = new Map<Id, List<Id>>(); 
		returnHolder.budgetHeaderChangeManagerMap = new map<Id, Map<String, String>>();
		
		system.debug('About to Query for Budget Info!');
		
		returnHolder.versionMap = new Map<Id, BudgetHeader__c>([SELECT Id 
																	, BudgetName__c   
																	, TotalCost__c
																	, TotalRevenue__c
																	, TotalFeeAmount__c
																	, TotalLaborAmount__c
																	, TotalSubAmount__c
																	, TotalContingencyAmount__c
																	, TotalResourceAmount__c
																	, Status__c
																	, CreatedDate
																FROM BudgetHeader__c
																WHERE Project__c = :theProject.Id
																ORDER BY CreatedDate ASC]);
																
		for (BudgetHeader__c bh : returnHolder.versionMap.values()) {
			returnHolder.versionToColumnToTaskToCellMap.put(bh.Id, new Map<Id, Map<Id, BudgetAssignment__c>>());
			returnHolder.taskMap.put(bh.Id, new Map<Id, BudgetTask__c>());
			returnHolder.columnMap.put(bh.Id, new Map<Id, BudgetResource__c>());
			returnHolder.sortedMapList.put(bh.Id, new List<Id>());
			//build change manager maps
			returnHolder.budgetHeaderChangeManagerMap.put(bh.Id, new Map<String, String>());
			returnHolder.budgetHeaderChangeManagerMap.get(bh.Id).put('Internal Change', '');
			returnHolder.budgetHeaderChangeManagerMap.get(bh.Id).put('External Change', '');
		}
		
		system.debug('returnHolder.versionMap.keySet():  '+returnHolder.versionMap.keySet());
		system.debug('returnHolder.versionToColumnToTaskToCellMap.keySet():  '+returnHolder.versionToColumnToTaskToCellMap.keySet());
		
		for (BudgetResource__c bc : [SELECT Id
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
												, ResourceType__c
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
									WHERE BudgetHeader__r.Project__c = :theProject.Id
									ORDER BY SortOrder__c ASC
										, Sort_Order_Detail__c ASC]) {
			
			// Put this column in the map
			returnHolder.columnMap.get(bc.BudgetHeader__c).put(bc.Id, bc);
			
			if (!returnHolder.sortedMapList.keySet().contains(bc.BudgetHeader__c)) {
				returnHolder.sortedMapList.put(bc.BudgetHeader__c, new List<Id>());
			}
			
			returnHolder.sortedMapList.get(bc.BudgetHeader__c).add(bc.Id);
			
			if (!returnHolder.versionToColumnToTaskToCellMap.keySet().contains(bc.BudgetHeader__c)) {
				returnHolder.versionToColumnToTaskToCellMap.put(bc.BudgetHeader__c, new Map<Id, Map<Id, BudgetAssignment__c>>());
			}
			
			// May as well get the next inner map at this stage to minimize our get calls
			Map<Id, Map<Id, BudgetAssignment__c>> innerMap = returnHolder.versionToColumnToTaskToCellMap.get(bc.BudgetHeader__c);
			
			if (!innerMap.keySet().contains(bc.Id)) {
				// Doesn't contain this column, so let's new up our innermost map
				innerMap.put(bc.Id, new Map<Id, BudgetAssignment__c>());
			}
			
			// again, get the inner map here, way easier since we know all the kids will have the same parent
			Map<Id, BudgetAssignment__c> innerMostMap = innerMap.get(bc.Id);
			
			system.debug('bc.BudgetAssignments__r:  '+bc.BudgetAssignments__r);
			
			for (BudgetAssignment__c ba : bc.BudgetAssignments__r) {
				innerMostMap.put(ba.BudgetTask__c, ba);
			}
			
			
		} // end assignment loop
		
		for (BudgetTask__c bt : [SELECT Id 
										, Name
										, BudgetHeader__c
										, TaskName__c
										, ProjectTask__c
										, StartDate__c 
										, EndDate__c
										, ProjectTask__r.EarnedValueCurve__c
										, ParentTask__c
										, IsTopLevelTask__c
										, IsBottomLevelTask__c
										, HierarchyDepth__c
										, IsAssignable__c
										, (SELECT Id 
											, Name
											, BudgetHeader__c
											, TaskName__c
											, ProjectTask__c
											, StartDate__c 
											, EndDate__c
											, ParentTask__c
											, IsTopLevelTask__c
											, IsBottomLevelTask__c
											, HierarchyDepth__c
											, IsAssignable__c
										FROM ChildTasks__r)
								FROM BudgetTask__c 
								WHERE BudgetHeader__r.Project__c = :theProject.Id
									AND IsHidden__c = false
								ORDER BY HierarchyDepth__c ASC
									, ParentTask__c ASC]) {
			if (!returnHolder.taskMap.keySet().contains(bt.BudgetHeader__c)) {
				returnHolder.taskMap.put(bt.BudgetHeader__c, new Map<Id, BudgetTask__c>());
			}
			
			returnHolder.taskMap.get(bt.BudgetHeader__c).put(bt.Id, bt);
		}
		
		
		
		system.debug('Built Task Map:  '+returnHolder.taskMap);
		
		system.debug('returnHolder.versionMap bEFORE:  '+returnHolder.versionMap);
			
		
		if (returnHolder.versionMap.isEmpty()) {
			returnHolder.versionToColumnToTaskToCellMap.put(returnHolder.versionMap.values()[0].Id, new Map<Id, Map<Id, BudgetAssignment__c>>());
		}
		
		if (returnHolder.taskMap.isEmpty()) {
			returnHolder.taskMap.put(returnHolder.versionMap.values()[0].Id, new Map<Id, BudgetTask__c>());
		}
		
		system.debug('returnHolder.versionMap AFTER:  '+returnHolder.versionMap);
		/*
		// Now we need to make sure that after all of that, we have placeholder budgetlines for all cells.  We can't do that until now since now is the only place we have all task keys.
		for (Map<Id, Map<Id, BudgetAssignment__c>> innerMap : returnHolder.versionToColumnToTaskToCellMap.values()) {
			for (Map<Id, BudgetAssignment__c> innerMostMap : innerMap.values()) {
				// Now we have our innermost map, and we want to loop over task names to see if they exist
				for (Map<Id, BudgetTask__c> btMap : returnHolder.taskMap.values()) {
					for (Id taskId : btMap.keySet()) {
						if (!innerMostMap.keySet().contains(taskId)) {
							innerMostMap.put(taskId, new BudgetAssignment__c());
						}
					}
				}
			}
		}
		*/
		for (Id versionId : returnHolder.versionToColumnToTaskToCellMap.keySet()) {
			Map<Id, Map<Id, BudgetAssignment__c>> innerMap = returnHolder.versionToColumnToTaskToCellMap.get(versionId);
				
			for (Id columnId : innerMap.keySet()) {
//			for (Map<Id, BudgetAssignment__c> innerMostMap : innerMap.values()) {
				Map<Id, BudgetAssignment__c> innerMostMap = innerMap.get(columnId);

				for (Id taskId : returnHolder.taskMap.get(versionId).keySet()) {
					if (!innerMostMap.keySet().contains(taskId)) {
						BudgetAssignment__c budgetAssignmentNew = new BudgetAssignment__c();
						budgetAssignmentNew.BudgetResource__c = columnId;
						budgetAssignmentNew.BudgetTask__c = taskId;

						innerMostMap.put(taskId, budgetAssignmentNew);
					}
				}
//			}
			}
		}
		
		for(ChangeManager__c changeManager:[select Id, BudgetHeader__c, RecordType.Name from ChangeManager__c where Project__c = :theProject.Id and BudgetHeader__c != null])
		{
			returnHolder.budgetHeaderChangeManagerMap.get(changeManager.BudgetHeader__c).put(changeManager.RecordType.Name, changeManager.Id);
			//returnHolder.budgetHeaderChangeManagerMap.put(changeManager.BudgetHeader__c, changeManager.Id);	
		}
		return returnHolder;
	}
	
	public class BudgetHolder {
		public Map<Id, Map<Id, Map<Id, BudgetAssignment__c>>> versionToColumnToTaskToCellMap	{ get; set; }
		public Map<Id, BudgetHeader__c> versionMap											{ get; set; }
		public Map<Id, Map<Id, BudgetResource__c>> columnMap								{ get; set; }
		public Map<Id, Map<Id, BudgetTask__c>> taskMap										{ get; set; }
		public Map<id, List<Id>> sortedMapList												{ get; set; }
		public Map<Id, Map<String, String>> budgetHeaderChangeManagerMap					{ get; set; }
	}
	
	private class ECO_Service_BudgetException extends Exception {}
	
}