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
//					order by ProjectTask__r.ProjectTaskNumber__c, TaskName__c];
					order by ProjectTask__r.pse__Order__c];

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
//					order by ProjectTask__r.ProjectTaskNumber__c, TaskName__c];
					order by ProjectTask__r.pse__Order__c];

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

	public class EacException extends Exception {}

    // Return Id of new budget header created
	public static Id createInitECO(Id sProjectId) {
		//ECO_DTO_BudgetLabourWrapper budgetLabourWrapper = new budgetLabourWrapper(projectId);
		BudgetHeader__c oBudgetHeader = new BudgetHeader__c();
        oBudgetHeader.RecordTypeId = ECO_Utils_Meta.getRecordTypeId(BudgetHeader__c.sObjectType, 'EAC');
        oBudgetHeader.Project__c = sProjectId;
        oBudgetHeader.Status__c = ECO_DTO_BudgetHeader.STATUS_ESTIMATE;
        
        list<BudgetHeader__c> lBudgetHeader = new list<BudgetHeader__c>([SELECT Id FROM BudgetHeader__c WHERE Project__c = :sProjectId]);
        
        oBudgetHeader.BudgetName__c = 'EAC ' + lBudgetHeader.size();
        insert oBudgetHeader;
        
        system.debug(LoggingLevel.ERROR, 'bh Id : ' + oBudgetHeader.Id);
        
        map<Id, BudgetTask__c> mBudgetTask = new map<Id, BudgetTask__c>();
 		map<Id, BudgetResource__c> mapResourceByPTMId = new Map <Id, BudgetResource__c> ();
        map<Id, BudgetResource__c> mapResourceBySubId = new Map <Id, BudgetResource__c> ();
        map<String, BudgetResource__c> mapResourceByContingencyName = new Map <String, BudgetResource__c> ();

        // Stores BAs so we can set the BudgetResource__c Id after the records are inserted
        map<Id, List<BudgetAssignment__c>> mapAssignmentsByPTMId = new Map <Id, List<BudgetAssignment__c>> ();
        map<Id, List<BudgetAssignment__c>> mapAssignmentsBySubId = new Map <Id, List<BudgetAssignment__c>> ();
        map<String, List<BudgetAssignment__c>> mapAssignmentsByContingencyName = new Map <String, List<BudgetAssignment__c>> ();
        
        
        map<String, BudgetAssignment__c> mapAssignmentByUniqueId = new Map <String, BudgetAssignment__c> ();

        map<String, BudgetResource__c> mapResourcesByPersonId = new Map<String, BudgetResource__c>();

        map<String, ProjectTeamMember__c> mapPTMByPersonId = new map<String, ProjectTeamMember__c> ();


        Set<Id> PTMIdsInBudget= new Set<Id>();

        for (pse__Project_Task__c oProjectTask : [SELECT Id, Name 
                                                  FROM pse__Project_Task__c 
                                                  WHERE pse__Project__c = :sProjectId]) {
                                                      
                                                      BudgetTask__c oBudgetTask = new BudgetTask__c();
                                                      oBudgetTask.ProjectTask__c = oProjectTask.Id;
                                                      oBudgetTask.BudgetHeader__c = oBudgetHeader.Id;
                                                      oBudgetTask.TaskName__c = oProjectTask.Name;
                                                      mBudgetTask.put(oProjectTask.Id, oBudgetTask);
                                                  }
        

        if (!mBudgetTask.isEmpty()) {
            insert mBudgetTask.values();
        }
        
      	// Link Person Ids from PTMs
        for (ProjectTeamMember__c ptm : [Select Id, OraclePersonId__c, Project__c From ProjectTeamMember__c Where Project__c = :sProjectId]) {
        	mapPTMByPersonId.put(ptm.OraclePersonId__c, ptm);
        }

        AggregateResult[] arTotals = [Select Sum(Quantity__c) Quantity__c, Sum(FullyBurdenedCost__c) FullyBurdenedCost__c, BudgetTask__r.ProjectTask__c, BudgetResource__r.ProjectTeamMember__c, BudgetTask__r.BudgetHeader__r.Status__c
                                      From BudgetAssignment__c 
                                      Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'Labor/Person' AND
                                      		(BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved') 
                                      GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.ProjectTeamMember__c, BudgetTask__r.BudgetHeader__r.Status__c
                                     ];
        
        AggregateResult[] arSubs = [Select Sum(OverrideTotalCost__c) OverrideTotalCost__c, BudgetTask__r.ProjectTask__c, BudgetResource__r.VendorSite__c, BudgetTask__r.BudgetHeader__r.Status__c 
                                      From BudgetAssignment__c 
                                      Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c = 'Subcontractor' AND
                                      		(BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved') 
                                      GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.VendorSite__c, BudgetTask__r.BudgetHeader__r.Status__c
                                     ];

     	AggregateResult[] arContingency = [Select Sum(OverrideTotalCost__c) OverrideTotalCost__c, BudgetTask__r.ProjectTask__c, BudgetResource__r.JobName__c, BudgetTask__r.BudgetHeader__r.Status__c 
                                      From BudgetAssignment__c 
                                      Where BudgetTask__r.ProjectTask__r.pse__Project__c = :sProjectId AND ResourceType__c='Contingency' AND  
                                      		(BudgetTask__r.BudgetHeader__r.Status__c = 'Forecast' OR BudgetTask__r.BudgetHeader__r.Status__c = 'Approved') 
                                      GROUP BY BudgetTask__r.ProjectTask__c, BudgetResource__r.JobName__c, BudgetTask__r.BudgetHeader__r.Status__c
                                     ];
       

        for (AggregateResult ar : arContingency) {
        	Id projectTaskId = (Id)ar.get('ProjectTask__c');
            String contName = (String)ar.get('JobName__c');
            
            if (contName == null || projectTaskId == null) continue;
            String status = (String)ar.get('Status__c');
            Decimal quantity = (Decimal)ar.get('OverrideTotalCost__c');
            Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
            BudgetResource__c budgetResource = mapResourceByContingencyName.get(contName);
            
            if (budgetResource == null) {
                budgetResource = new BudgetResource__c();
                budgetResource.BudgetHeader__c = oBudgetHeader.id;
                budgetResource.OverrideRatesOnLines__c = true;
                budgetResource.ResourceType__c = 'Contingency';
                // TODO: ???
                // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
                // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
                budgetResource.JobName__c = contName;

                mapResourceByContingencyName.put(contName, budgetResource);
            }
                        
            List<BudgetAssignment__c> oAssignments = mapAssignmentsByContingencyName.get(contName);
            
            if(oAssignments == null) {
                oAssignments = new List<BudgetAssignment__c> ();
                mapAssignmentsByContingencyName.put(contName, oAssignments);               
            }
            
            String uniqueId = contName + '' + projectTaskId;
            BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
            if (ba == null) {
            	ba = new BudgetAssignment__c();
                mapAssignmentByUniqueId.put(uniqueId, ba);
                oAssignments.add(ba); // make sure we only the BA once
            }
            
            ba.BudgetTask__c = budgetTaskId;
            if (status == 'Approved') {
         		ba.EACApprovedTotalCost__c  = quantity;
            } else if (status == 'Forecast') {
            	ba.EACForecastTotalCost__c  = quantity;
            }          
            
        }

        for (AggregateResult ar : arSubs) {
        	Id projectTaskId = (Id)ar.get('ProjectTask__c');
            Id subId = (Id)ar.get('VendorSite__c');
            
            if (subId == null || projectTaskId == null) continue;
            String status = (String)ar.get('Status__c');
            Decimal quantity = (Decimal)ar.get('OverrideTotalCost__c');
            Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
            BudgetResource__c budgetResource = mapResourceBySubId.get(subId);
            
            if (budgetResource == null) {
                budgetResource = new BudgetResource__c();
                budgetResource.BudgetHeader__c = oBudgetHeader.id;
                budgetResource.OverrideRatesOnLines__c = true;
                budgetResource.ResourceType__c = 'Subcontractor';
                // TODO: ???
                // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
                // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
                budgetResource.JobName__c = null;

                budgetResource.VendorSite__c  = subId;
                mapResourceBySubId.put(subId, budgetResource);
            }
                        
            List<BudgetAssignment__c> oAssignments = mapAssignmentsBySubId.get(subId);
            
            if(oAssignments == null) {
                oAssignments = new List<BudgetAssignment__c> ();
                mapAssignmentsBySubId.put(subID, oAssignments);               
            }
            
            String uniqueId = subId + '' + projectTaskId;
            BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
            if (ba == null) {
            	ba = new BudgetAssignment__c();
                mapAssignmentByUniqueId.put(uniqueId, ba);
                oAssignments.add(ba); // make sure we only the BA once
            }
            
            ba.BudgetTask__c = budgetTaskId;
            if (status == 'Approved') {
         		ba.EACApprovedTotalCost__c  = quantity;
            } else if (status == 'Forecast') {
            	ba.EACForecastTotalCost__c  = quantity;
            }          
            
        }
        
        AggregateResult[] arLaborActuals = [SELECT PersonId__c, SUM(Quantity__c) Quantity__c, SUM(ProjectFunctionalRawCost__c) totalRawCost, ProjectTask__c,VendorId__c FROM ExpendItem__c Where Project__c = :sProjectId AND UOM__c = 'Hours' GROUP BY ProjectTask__c, VendorId__c, PersonId__c
                                     ];



        for (AggregateResult ar : arTotals) {
        	Id ptmId = (Id)ar.get('ProjectTeamMember__c');

            if (ptmId != null) PTMIdsInBudget.add(ptmId);
        }

        Set<String> personIdsToAdd = new Set<String>();

        List<ProjectTeamMember__c> ptmsToAdd = new List<ProjectTeamMember__c>();

        for (AggregateResult ar : arLaborActuals) {
        	String personId = (String)ar.get('PersonId__c');

        	if (personId == null) {
        		throw new EacException('PersonId is null on Expenditure Item');
        	}
        	
        	ProjectTeamMember__c ptm = mapPTMByPersonId.get(personId);

        	if (!PTMIdsInBudget.contains(ptm.Id)) {
        		personIdsToAdd.add(personId);
        	}


        }


        if (!personIdsToAdd.isEmpty()) {
        	ProjectRole__c prl = [select id from ProjectRole__c where Name = 'Task Manager'];

	        for (Contact con : [Select Id, pse__Salesforce_User__r.PersonId__c From Contact Where pse__Salesforce_User__r.PersonId__c in :personIdsToAdd]) {
				ProjectTeamMember__c ptm = new ProjectTeamMember__c();
				ptm.contact__c = con.Id;
				ptm.project__c = sProjectId;
				ptm.ProjectRole__c = prl.id;

				ptmsToAdd.add(ptm);
				mapPTMByPersonId.put(con.pse__Salesforce_User__r.PersonId__c, ptm);
	        }

	        insert ptmsToAdd;
		}

		for (AggregateResult ar : arLaborActuals) {
			String personId = (String)ar.get('PersonId__c');
        	Decimal quantity = (Decimal)ar.get('Quantity__c');
        	Decimal totalRawCost = (Decimal)ar.get('totalRawCost');
        	Id projectTaskId = (Id)ar.get('ProjectTask__c');
            Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
            
            Id ptmId = mapPTMByPersonId.get(personId).Id;
            BudgetResource__c budgetResource = mapResourceByPTMId.get(ptmId);
            
            if (budgetResource == null) {
                budgetResource = new BudgetResource__c();
                budgetResource.BudgetHeader__c = oBudgetHeader.id;
                budgetResource.OverrideRatesOnLines__c = true;
                budgetResource.ResourceType__c = 'Labor/Person';
                // TODO: ???
                // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
                // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
                budgetResource.JobName__c = null;

                budgetResource.ProjectTeamMember__c = ptmId;
                mapResourceByPTMId.put(ptmId, budgetResource);
            }
                        
            List<BudgetAssignment__c> oAssignments = mapAssignmentsByPTMId.get(ptmId);
            
            if(oAssignments == null) {
                oAssignments = new List<BudgetAssignment__c> ();
                mapAssignmentsByPTMId.put(ptmID, oAssignments);               
            }
            
            String uniqueId = ptmId + '' + projectTaskId;
            BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
            if (ba == null) {
            	ba = new BudgetAssignment__c();
                mapAssignmentByUniqueId.put(uniqueId, ba);
                oAssignments.add(ba); // make sure we only the BA once
            }
            
            ba.BudgetTask__c = budgetTaskId;
            ba.EACActualQuantity__c = quantity;
            ba.EACActualCost__c = totalRawCost;
		}

        for (AggregateResult ar : arTotals) {
        	Id projectTaskId = (Id)ar.get('ProjectTask__c');
            Id ptmId = (Id)ar.get('ProjectTeamMember__c');
            
            if (projectTaskId == null) continue;

            if (ptmId != null) PTMIdsInBudget.add(ptmId);

            String status = (String)ar.get('Status__c');
            Decimal quantity = (Decimal)ar.get('Quantity__c');
            Decimal totalCost = (Decimal)ar.get('FullyBurdenedCost__c');
            totalCost = totalCost == null ? 0 : totalCost;

            Id budgetTaskId = mBudgetTask.get(projectTaskId).Id;
            BudgetResource__c budgetResource = mapResourceByPTMId.get(ptmId);
            
            if (budgetResource == null) {
                budgetResource = new BudgetResource__c();
                budgetResource.BudgetHeader__c = oBudgetHeader.id;
                budgetResource.OverrideRatesOnLines__c = true;
                budgetResource.ResourceType__c = 'Labor/Person';
                // TODO: ???
                // budgetResource.OverrideBillRate__c = theProject.DefaultBillRate__c;
                // budgetResource.OverrideUplift__c = theProject.DefaultUpliftLabor__c;
                budgetResource.JobName__c = null;

                budgetResource.ProjectTeamMember__c = ptmId;
                mapResourceByPTMId.put(ptmId, budgetResource);
            }
                        
            List<BudgetAssignment__c> oAssignments = mapAssignmentsByPTMId.get(ptmId);
            
            if(oAssignments == null) {
                oAssignments = new List<BudgetAssignment__c> ();
                mapAssignmentsByPTMId.put(ptmID, oAssignments);               
            }
            
            String uniqueId = ptmId + '' + projectTaskId;
            BudgetAssignment__c ba = mapAssignmentByUniqueId.get(uniqueId);
            if (ba == null) {
            	ba = new BudgetAssignment__c();
                mapAssignmentByUniqueId.put(uniqueId, ba);
                oAssignments.add(ba); // make sure we only the BA once
            }
            
            ba.BudgetTask__c = budgetTaskId;
            if (status == 'Approved') {
         		ba.EACApprovedQuantity__c = quantity;
         		ba.EACApprovedTotalCost__c = totalCost;
            } else if (status == 'Forecast') {
            	ba.EACForecastQuantity__c = quantity;
            	ba.EACForecastTotalCost__c = totalCost;
            }          
            
        }
       
        // Insert All budgetResources
        List<BudgetResource__c> allBudgets = new List<BudgetResource__c>();
        allBudgets.addAll(mapResourceByPTMId.values());
        allBudgets.addAll(mapResourceByContingencyName.values());
        allBudgets.addAll(mapResourceBySubId.values());
        insert allBudgets;
        
		//insert mapResourceBySubId.values();
        //insert mapResourceByContingencyName.values();

        for (String contName : mapResourceByContingencyName.keySet()) {
            Id brId = mapResourceByContingencyName.get(contName).Id;
            
            for(BudgetAssignment__c ba : mapAssignmentsByContingencyName.get(contName)) {
                ba.BudgetResource__c = brId;
            }
        }

        for (Id subId : mapResourceBySubId.keySet()) {
            Id brId = mapResourceBySubId.get(subId).Id;
            
            for(BudgetAssignment__c ba : mapAssignmentsBySubId.get(subId)) {
                ba.BudgetResource__c = brId;
            }
        }
        
        for (Id ptmId : mapResourceByPTMId.keySet()) {
            Id brId = mapResourceByPTMId.get(ptmId).Id;
            
            for(BudgetAssignment__c ba : mapAssignmentsByPTMId.get(ptmId)) {
                ba.BudgetResource__c = brId;
            }
        }
        
        // Insert All Budget Asssignments
        insert mapAssignmentByUniqueId.values();
        
        return oBudgetHeader.Id;
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