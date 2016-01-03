public with sharing class ECO_BudgetTaskService {
	public ECO_BudgetTaskService() {
		
	}

	public static List<ECO_DTO_BudgetTask> getBudgetTaskListFromProject(Id projectId) {
				List<BudgetTask__c> budgetTasks = [select 
					id,
					name,
					ProjectTask__c,
					ProjectTask__r.name,
					ParentTask__r.ProjectTask__c,
					ProjectTask__r.pse__Parent_Task__c,
					ParentTask__c,
					ProjectTask__r.ProjectTaskNumber__c,
					TaskName__c,
					TotalContingency__c,
					TotalCost__c,
					TotalFringe__c,
					TotalFullyBurdenedLaborRate__c,
					TotalLaborHours__c,
					TotalODCCost__c,
					TotalOverhead__c,
					TotalRawCost__c,
					TotalRevenue__c,
					TotalSubCost__c,
					TotalSubRevenue__c,
					TotalContingencyRevenue__c,
					TotalODCRevenue__c,
					TotalLaborCost__c,
					TotalLaborRevenue__c,
                    OverrideTotalRevenue__c                                
					from BudgetTask__c 
					where BudgetHeader__r.Project__c = :projectId 
					order by ProjectTask__r.ProjectTaskNumber__c, TaskName__c];
//					order by ProjectTask__r.pse__Task_Number__c];
//					order by ProjectTask__r.pse__Order__c];

		List<ECO_DTO_BudgetTask> tempTasks = new List<ECO_DTO_BudgetTask>();

		Map<Id, ECO_DTO_BudgetTask> taskMap = new Map<Id, ECO_DTO_BudgetTask>();

		Set<Id> taskIds = new Set<Id>();

		for (BudgetTask__c task : budgetTasks) {
			taskIds.add(task.id);

			ECO_DTO_BudgetTask newTask = new ECO_DTO_BudgetTask(task.ProjectTask__r);

			tempTasks.add(newTask);
			taskMap.put(newTask.id, newTask);
		}

		for (ECO_DTO_BudgetTask task : tempTasks) {
			if (task.parentTaskId != null) {
				ECO_DTO_BudgetTask parent = taskMap.get(task.parentTaskId);

				parent.addChild(task);
			}
		}

		List<ECO_DTO_BudgetTask> tasks = new List<ECO_DTO_BudgetTask>();

		for (ECO_DTO_BudgetTask task : tempTasks) {
			if (task.parentTaskId == null) {
				setIndentLevel(tasks, task, 0);
			}
		}

		List<BudgetAssignment__c> assignments = [select id, BudgetTask__r.ProjectTask__c, BudgetTask__c, TotalComputedCost__c from BudgetAssignment__c where BudgetTask__c in :taskIds];

		for (BudgetAssignment__c assignment : assignments) {
			ECO_DTO_BudgetTask theTask = taskMap.get(assignment.BudgetTask__r.ProjectTask__c);

			theTask.totalComputedCost += assignment.TotalComputedCost__c;
		}

		// TODO - need to check strategy before calling this line, possibly call a different method
		setBottomUpRollupTotals(tasks);

		return tasks;
	}

	public static List<ECO_DTO_BudgetTask> getBudgetTaskList(Id headerId) {
		List<BudgetTask__c> budgetTasks = [select 
					id,
					name,
					ProjectTask__c,
					ProjectTask__r.name,
					ParentTask__r.ProjectTask__c,
					ProjectTask__r.pse__Parent_Task__c,
					ParentTask__c,
					ProjectTask__r.ProjectTaskNumber__c,
					ProjectTask__r.WorkTypeName__c,
					ProjectTask__r.pse__Project__r.BudgetStrategy__c,
					TaskName__c,
					TotalContingency__c,
					TotalCost__c,
					TotalFringe__c,
					TotalFullyBurdenedLaborRate__c,
					TotalLaborHours__c,
					TotalODCCost__c,
					TotalOverhead__c,
					TotalRawCost__c,
					TotalRevenue__c,
					TotalSubCost__c,
					TotalSubRevenue__c,
					TotalContingencyRevenue__c,
					TotalODCRevenue__c,
					TotalLaborCost__c,
					TotalLaborRevenue__c,
                    OverrideTotalRevenue__c 
					from BudgetTask__c 
					where BudgetHeader__c = :headerId
					order by ProjectTask__r.ProjectTaskNumber__c, TaskName__c];
// 					order by ProjectTask__r.pse__Order__c];
//					order by ProjectTask__r.pse__Task_Number__c];

		List<ECO_DTO_BudgetTask> tempTasks = new List<ECO_DTO_BudgetTask>();

		Map<Id, ECO_DTO_BudgetTask> taskMap = new Map<Id, ECO_DTO_BudgetTask>();

		Set<Id> taskIds = new Set<Id>();

		for (BudgetTask__c task : budgetTasks) {
			taskIds.add(task.id);

			ECO_DTO_BudgetTask newTask = new ECO_DTO_BudgetTask(task);

			tempTasks.add(newTask);
			taskMap.put(newTask.id, newTask);
		}

		for (ECO_DTO_BudgetTask task : tempTasks) {
			if (task.parentTaskId != null) {
				ECO_DTO_BudgetTask parent = taskMap.get(task.parentTaskId);

				if (parent != null)
					parent.addChild(task);
			}
		}

		List<ECO_DTO_BudgetTask> tasks = new List<ECO_DTO_BudgetTask>();

		for (ECO_DTO_BudgetTask task : tempTasks) {
			if (task.parentTaskId == null) {
				setIndentLevel(tasks, task, 0);
			}
		}

		List<AggregateResult> arEACTotals = [SELECT BudgetTask__r.ProjectTask__c, 
													SUM(EACActualCost__c) EACActualCost__c, 
													SUM(EACActualQuantity__c) EACActualQuantity__c, 
													SUM(EACApprovedQuantity__c) EACApprovedQuantity__c, 
													SUM(EACApprovedTotalCost__c) EACApprovedTotalCost__c, 
													SUM(EACForecastQuantity__c) EACForecastQuantity__c, 
													SUM(EACForecastRevenue__c) EACForecastRevenue__c, 
													SUM(EACForecastTotalCost__c) EACForecastTotalCost__c
													FROM BudgetAssignment__c 
													WHERE BudgetTask__r.BudgetHeader__c = :headerId 
													GROUP BY BudgetTask__r.ProjectTask__c];

		for (AggregateResult ar : arEACTotals) {
			ECO_DTO_BudgetTask theTask = taskMap.get((Id)ar.get('ProjectTask__c'));

			theTask.totalEACActualCost = (Decimal)ar.get('EACActualCost__c');
			theTask.totalEACActualQuantity = (Decimal)ar.get('EACActualQuantity__c');
			theTask.totalEACApprovedQuantity = (Decimal)ar.get('EACApprovedQuantity__c');
			theTask.totalEACApprovedTotalCost = (Decimal)ar.get('EACApprovedTotalCost__c');
			theTask.totalEACForecastQuantity = (Decimal)ar.get('EACForecastQuantity__c');
			theTask.totalEACForecastRevenue = (Decimal)ar.get('EACForecastRevenue__c');
			theTask.totalEACForecastTotalCost = (Decimal)ar.get('EACForecastTotalCost__c');
		}

		List<BudgetAssignment__c> assignments = [select id, BudgetTask__r.ProjectTask__c, BudgetTask__c, TotalComputedCost__c from BudgetAssignment__c where BudgetTask__c in :taskIds];

		for (BudgetAssignment__c assignment : assignments) {
			ECO_DTO_BudgetTask theTask = taskMap.get(assignment.BudgetTask__r.ProjectTask__c);

			theTask.totalComputedCost += assignment.TotalComputedCost__c;
		}

		// TODO - need to check strategy before calling this line, possibly call a different method
		setBottomUpRollupTotals(tasks);

		return tasks;
	}

	private static void setIndentLevel(List<ECO_DTO_BudgetTask> tasks, ECO_DTO_BudgetTask task, Integer level) {
		task.indentLevel = level;

		tasks.add(task);

		if (task.parentTaskId != null) {
			if (task.parentClasses == null) {
				task.parentClasses = task.parentTaskId;
			} else {
				task.parentClasses += ' ' + task.parentTaskId;
			}
		}

		for (ECO_DTO_BudgetTask child : task.children) {
			setIndentLevel(tasks, child, level + 1);
		}
	}

	public static Decimal sumColumn(List<ECO_DTO_BudgetTask> budgetTasks, String name) {
		Decimal result = 0;

		for (ECO_DTO_BudgetTask task : budgetTasks) {
			if (task.children.size() > 0)
				continue;

//			result += (Decimal) task.obudgettask.get(name);
			result += (Decimal) task.getValueByName(name);
		}

		return result;
	}

	public static ECO_DTO_BudgetTask getTotalRow(List<ECO_DTO_BudgetTask> budgetTasks) {
		ECO_DTO_BudgetTask totalRow = new ECO_DTO_BudgetTask();

		totalRow.totalContingency = sumColumn(budgetTasks, 'totalContingency');
		totalRow.totalContingencyRevenue = sumColumn(budgetTasks, 'totalContingencyRevenue');
		totalRow.totalCost = sumColumn(budgetTasks, 'totalCost');
		totalRow.totalComputedCost = sumColumn(budgetTasks, 'totalComputedCost');
		totalRow.totalFringe = sumColumn(budgetTasks, 'totalFringe');
		totalRow.totalFullyBurdenedLaborRate = sumColumn(budgetTasks, 'totalFullyBurdenedLaborRate');
		totalRow.totalLaborHours = sumColumn(budgetTasks, 'totalLaborHours');
		totalRow.totalODCCost = sumColumn(budgetTasks, 'totalODCCost');
		totalRow.totalODCRevenue = sumColumn(budgetTasks, 'totalODCRevenue');
		totalRow.totalOverhead = sumColumn(budgetTasks, 'totalOverhead');
		totalRow.totalRawCost = sumColumn(budgetTasks, 'totalRawCost');
		totalRow.totalRevenue = sumColumn(budgetTasks, 'totalRevenue');
		totalRow.totalSubCost = sumColumn(budgetTasks, 'totalSubCost');
		totalRow.totalSubRevenue = sumColumn(budgetTasks, 'totalSubRevenue');
		totalRow.totalLabourCost = sumColumn(budgetTasks, 'totalLabourCost');
		totalRow.totalLabourRevenue = sumColumn(budgetTasks, 'totalLabourRevenue');

		return totalRow;
	}

	public static void setBottomUpRollupTotals(List<ECO_DTO_BudgetTask> budgetTasks) {
		for (Integer i = budgetTasks.size() - 1; i >= 0; i--) {
			ECO_DTO_BudgetTask task = budgetTasks.get(i);

			if (task.children.size() > 0) {
				task.totalContingency = task.getSubtaskTotal('totalContingency', false);
				task.totalContingencyRevenue = task.getSubtaskTotal('totalContingencyRevenue', false);
				task.totalCost = task.getSubtaskTotal('totalCost', false);
				task.totalComputedCost = task.getSubtaskTotal('totalComputedCost', false);
				task.totalFringe = task.getSubtaskTotal('totalFringe', false);
				task.totalFullyBurdenedLaborRate = task.getSubtaskTotal('totalFullyBurdenedLaborRate', false);
				task.totalLaborHours = task.getSubtaskTotal('totalLaborHours', false);
				task.totalODCCost = task.getSubtaskTotal('totalODCCost', false);
				task.totalODCRevenue = task.getSubtaskTotal('totalODCRevenue', false);
				task.totalOverhead = task.getSubtaskTotal('totalOverhead', false);
				task.totalRawCost = task.getSubtaskTotal('totalRawCost', false);
				task.totalRevenue = task.getSubtaskTotal('totalRevenue', false);
				task.totalSubCost = task.getSubtaskTotal('totalSubCost', false);
				task.totalSubRevenue = task.getSubtaskTotal('totalSubRevenue', false);
				task.totalLabourCost = task.getSubtaskTotal('totalLabourCost', false);
				task.totalLabourRevenue = task.getSubtaskTotal('totalLabourRevenue', false);

				task.totalEACActualCost = task.getSubtaskTotal('totalEACActualCost', false);
				task.totalEACActualQuantity = task.getSubtaskTotal('totalEACActualQuantity', false);
				task.totalEACApprovedQuantity = task.getSubtaskTotal('totalEACApprovedQuantity', false);
				task.totalEACApprovedTotalCost = task.getSubtaskTotal('totalEACApprovedTotalCost', false);
				task.totalEACForecastQuantity = task.getSubtaskTotal('totalEACForecastQuantity', false);
				task.totalEACForecastRevenue = task.getSubtaskTotal('totalEACForecastRevenue', false);
				task.totalEACForecastTotalCost = task.getSubtaskTotal('totalEACForecastTotalCost', false);
				
			}
		}
	}

	public static Decimal sumContingencies(Id  projectId) {
		List<BudgetHeader__c> budgetHeaders = [Select TotalContingencyAmount__c, Project__c From BudgetHeader__c Where Project__c = :projectId];
		Decimal val = 0;

		for(BudgetHeader__c bh : budgetHeaders ) {
			val += bh.TotalContingencyAmount__c;
		}
		return val;
	}

	public static Decimal sumRiskRegister(Id projectId) {
		List<Risk__c> risks =  [Select PostmitigationContingencyTotal__c, Project__c From Risk__c Where Project__c = :projectId];

		Decimal val = 0;

		for(Risk__c risk : risks ) {
			val += risk.PostmitigationContingencyTotal__c;
		}

		return val;
	} 
}