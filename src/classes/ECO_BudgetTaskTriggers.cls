public without sharing class ECO_BudgetTaskTriggers {
	public static Boolean run = true;
	
	public static void rollUpBudgetTaskValues (Map<Id, BudgetTask__c> btOld, Map<Id, BudgetTask__c> btNew) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('BT_rollup')) {
			return;
		}
		
		Set<Id> projectTaskIds = new Set<Id>();
		if (btOld != null) {
			for (BudgetTask__c bt : btOld.values()) {
				projectTaskIds.add(bt.ProjectTask__c);
			}
		}
		if (btNew != null) {
			for (BudgetTask__c bt : btNew.values()) {
				projectTaskIds.add(bt.ProjectTask__c);
			}
		}
												
		List<pse__Project_Task__c> projectTasksToUpdate = new List<pse__Project_Task__c>();
		
		for (AggregateResult ar : [SELECT ProjectTask__c
										, SUM(TotalApprovedCost__c) totalApprovedCostAmount
                                   		, SUM(TotalEstimateCost__c) totalEstimateCostAmount
									FROM BudgetTask__c
									WHERE ProjectTask__c IN :projectTaskIds
										AND ProjectTask__c != null
									GROUP BY ProjectTask__c]) {
										
			system.debug('ar:  '+ar);
			
			pse__Project_Task__c ptToUpdate = new pse__Project_Task__c();
			ptToUpdate.Id = (Id)ar.get('ProjectTask__c');
			ptToUpdate.TotalApprovedCost__c = (Decimal)ar.get('totalApprovedCostAmount');
            ptToUpdate.TotalEstimateCost__c = (Decimal)ar.get('totalEstimateCostAmount');
			projectTasksToUpdate.add(ptToUpdate);
		}
		
		if (!projectTasksToUpdate.isEmpty()) {
			update projectTasksToUpdate;
		}
	}
	
	public static void calculateDepth (List<BudgetTask__c> newBTasksList) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('BT_hierarchy')) {
			return;
		}
		
		Map<Id, Integer> parentIdToNewDepthMap = new Map<Id, Integer>();
		
		for (BudgetTask__c bt : newBTasksList) {
			if (bt.ParentTask__c != null) {
				parentIdToNewDepthMap.put(bt.ParentTask__c, null);
			}
		}
		
		for (BudgetTask__c bt : [SELECT Id 
										, HierarchyDepth__c
								FROM BudgetTask__c 
								WHERE Id IN :parentIdToNewDepthMap.keySet()]) {
			
			parentIdToNewDepthMap.put(bt.Id, Integer.valueOf(bt.HierarchyDepth__c) + 1);
		}
		
		for (BudgetTask__c bt : newBTasksList) {
			if (bt.ParentTask__c == null) {
				// this is a parent task
				bt.HierarchyDepth__c = 0;
				bt.HierarchyIds__c = bt.Id;
			} else {
				bt.HierarchyDepth__c = parentIdToNewDepthMap.get(bt.ParentTask__c);
				bt.HierarchyIds__c = ''+bt.Id;
			}
		}
	}
	
	// Must run after everything, delete, undelete, etc
	public static void calculateBottomTaskFlag (List<BudgetTask__c> newBTaskList, List<BudgetTask__c> oldBTaskList) {
		if (!run || !ECO_TriggerSettings.getIsTriggerEnabled('BT_bottomFlag')) {
			return;
		}
		
		Set<Id> allTaskIds = new Set<Id>();
		
		if (newBTaskList != null) {
			for (BudgetTask__c bt : newBTaskList) {
				allTaskIds.add(bt.Id);
				allTaskIds.add(bt.ParentTask__c);
			}
		}
		
		if (oldBTaskList != null) {
			for (BudgetTask__c bt : oldBTaskList) {
				allTaskIds.add(bt.Id);
				allTaskIds.add(bt.ParentTask__c);
			}
		}
		
		List<BudgetTask__c> BTasksToUpdate = new List<BudgetTask__c>();
		
		for (BudgetTask__c bt : [SELECT Id
										, (SELECT Id FROM ChildTasks__r)
								FROM BudgetTask__c
								WHERE Id IN :allTaskIds]) {
			if (bt.ChildTasks__r.isEmpty()) {
				bt.IsBottomLevelTask__c = true;
				bt.HasChildren__c = false;
			} else {
				bt.IsBottomLevelTask__c = false;
				bt.HasChildren__c = true;
			}
			
			BTasksToUpdate.add(bt);
		}
		
		run = false;
		update BTasksToUpdate;
		run = true;
	}
}