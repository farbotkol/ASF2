public class ECO_DTO_BudgetLabourWrapper {
	public List<ECO_DTO_BudgetLabourDetail> dtoBudgetLabourDetails{get; set;}
    
    public  List<ECO_DTO_BudgetTask> dtoBudgetTasks {get; set;}
    
    public  ECO_DTO_BudgetTask dtoBudgetTaskTotalRow {get; set;}
    
    public Map<String, List<BudgetAssignment__c>> mapAssignmentsByNameAndTask{get; set;}
    
    public  Map<String, Decimal> mapTotalByLaborDetailAndTask {get; set;}
    
    public  Map<String, Decimal> mapTotalCostBySubDetailAndTask {get; set;}
    
    public  Map<String, Decimal> mapTotalQuantityByODCDetailAndTask {get; set;}

    public  Map<String, Decimal> mapTotalComputedCostByODCDetailAndTask {get; set;}

    public  Map<String, Decimal> mapTotalRevenueBySubDetailAndTask {get; set;}
    
    public  Map<String, EACTotals> mapEACTotalsByLaborDetailAndTask {get; set;}

    public Map<Id, LaborRates> mapLaborRatesByResourceId {get; set;}

    public  EACTotals grandTotals { get; set;}

    public Id budgetHeaderId {get; set;}

    public String projectCurrency {get; set;}

    public Boolean hasFieldTasks {get; set;}

    public Integer getTotalLaborHours{
        get{return (Integer)calculateBudgetLabourTotals('TotalHours__c');}
    }
    
    public Decimal getTotalCost{
        get{return calculateBudgetLabourTotals('TotalCost__c');}
    }
    
    public Decimal getTotalRevenue{
        get{return calculateBudgetLabourTotals('TotalRevenue__c');}
    }
    
    public Decimal calculateBudgetLabourTotals(String fieldName) {
        Decimal total = 0.0;
        for(ECO_DTO_BudgetLabourDetail dtoBudgetLabour : dtoBudgetLabourDetails) {
            // System.debug('total:' + total);
            total = total + (Decimal) dtoBudgetLabour.oBudgetResource.get(fieldName);
        }
        return total;
    }
    
    public ECO_DTO_BudgetLabourWrapper(Id projectId) {
        mapAssignmentsByNameAndTask = new Map <String, List<BudgetAssignment__c>>();
        
        system.debug('ECO_DTO_BudgetLabourWrapper Constructor BEGIN');
        dtoBudgetLabourDetails = new List<ECO_DTO_BudgetLabourDetail>();
        dtoBudgetTasks = new List<ECO_DTO_BudgetTask>();
        
        List<BudgetResource__c> budgetResources = [SELECT
                                                      Id,
                                                      ResourceType__c,
                                                      ColumnHeader__c,
                                                      JobName__c,
                                                      ExpenditureType__c,
                                                      CostRate__c,
                                                      UnitType__c,
                                                      UnitCost__c,
                                                      MarkupPercentage__c,
                                                      OverrideRawCost__c,
                                                      OverrideFringeMultiplier__c,
                                                      OverrideOverheadMultiplier__c,
                                                      OverrideFringeMultiplierField__c,
                                                      OverrideOverheadMultiplierField__c,
                                                      AppliedBillRate__c,
                                                      MarginType__c,
                                                      CostCalcType__c,
                                                      OverrideBillRate__c,
                                                      OverrideUplift__c,
                                                      TotalQuantity__c,
                                                      TotalCost__c,
                                                      TotalHours__c,
                                                      TotalRevenue__c,
                                                      BudgetHeader__c,
                                                      IsQuoted__c,
                                                      IsEstimated__c,
                                                      IsBillable__c,
                                                      (SELECT Id,
                                                          	BudgetResource__c,
                                                          	BudgetTask__c,
                                                          	Quantity__c,
                                                          	TotalComputedCost__c,
                                                          	OverrideTotalCost__c,
                                                          	OverrideTotalRevenue__c,
                                                       		CalculatedRevenue__c,
                                                          WorkTypeName__c
                                                         from BudgetAssignments__r)
                                                    FROM
                                                      BudgetResource__c
                                                    WHERE
                                                      BudgetHeader__r.Project__c = :projectId AND (BudgetHeader__r.Status__c = 'Forecast' OR BudgetHeader__r.Status__c = 'Forecast')];
        
        for(BudgetResource__c budgetResource : budgetResources) {
            ECO_DTO_BudgetLabourDetail dtoBudgetLabourDetail = new ECO_DTO_BudgetLabourDetail(budgetResource, budgetResource.BudgetAssignments__r);
      		dtoBudgetLabourDetails.add(dtoBudgetLabourDetail);
            String uniqueId = dtoBudgetLabourDetail.uniqueId;
			     List<BudgetAssignment__c> budgetAssignments = mapAssignmentsByNameAndTask.get(uniqueId);
            
            if(budgetAssignments == null) {
                budgetAssignments = new List<BudgetAssignment__c> ();	
                mapAssignmentsByNameAndTask.put(uniqueId,budgetAssignments);                
            }
            
            budgetAssignments.addAll(budgetResource.BudgetAssignments__r);
        }
        
        System.debug('BudgetResource complete');
        
       // dtoBudgetTasks = ECO_BudgetTaskService.getBudgetTaskListFromProject(projectId);
        
        system.debug('BudgetTaskService Complete');
        
        createEmptyBudgetAssignments();
        
       // system.debug('BudgetTaskService Complete');
        
        calculateTopLevelTasksTotalForLaborPerson();
        calculateTopLevelTasksTotalCostForSubPerson();
        calculateTopLevelTasksTotalRevenueForSubPerson();      
        calculateTopLevelTasksTotalQuantityForODCResource();
        calculateTopLevelTasksTotalComputedCostForODCResource();
        
//        calculateGrandTotal();
    }

    public static List<BudgetResource__c> budgetResourceSelector(Id budgetHeaderId, String resourceType) {
      List<BudgetResource__c> budgetResources = [SELECT
                                                      Id,
                                                      ResourceType__c,
                                                      ColumnHeader__c,
                                                      JobName__c,
                                                        ExpenditureType__c,
                                                      CostRate__c,
                                                        UnitType__c,
                                                        UnitCost__c,
                                                        MarkupPercentage__c,
                                                      OverrideRawCost__c,
                                                      OverrideFringeMultiplier__c,
                                                      OverrideOverheadMultiplier__c,
                                                      OverrideFringeMultiplierField__c,
                                                      OverrideOverheadMultiplierField__c,
                                                      AppliedBillRate__c,
                                                      MarginType__c,
                                                        CostCalcType__c,
                                                      OverrideBillRate__c,
                                                      OverrideUplift__c,
                                                        TotalQuantity__c,
                                                      TotalCost__c,
                                                      TotalHours__c,
                                                      TotalRevenue__c,
                                                      BudgetHeader__c,
                                                      IsQuoted__c,
                                                      IsEstimated__c,
                                                      IsBillable__c,
                                                      (SELECT Id,
                                                          BudgetResource__c,
                                                          BudgetTask__c,
                                                          Quantity__c,
                                                            TotalComputedCost__c,
                                                            EACActualQuantity__c,
                                                            EACApprovedQuantity__c,
                                                            EACForecastQuantity__c, 
                                                            EACActualCost__c,
                                                            EACApprovedTotalCost__c,
                                                            EACForecastTotalCost__c,
                                                          EACForecastRevenue__c,
                                                          OverrideTotalCost__c,
                                                          OverrideTotalRevenue__c,
                                                          CalculatedRevenue__c,
                                                          WorkTypeName__c
                                                         from BudgetAssignments__r)
                                                    FROM
                                                      BudgetResource__c
                                                    WHERE
                                                      BudgetHeader__c =:budgetHeaderId AND ResourceType__c =: resourceType];

      return budgetResources;                                                
    }

    public ECO_DTO_BudgetLabourWrapper(ApexPages.StandardSetController brSsc, Id budgetHeaderId) {
        system.debug('ECO_DTO_BudgetLabourWrapper Constructor BEGIN');
        this.budgetHeaderId = budgetHeaderId;
        dtoBudgetTasks = new List<ECO_DTO_BudgetTask>();
        dtoBudgetTasks = ECO_BudgetTaskService.getBudgetTaskList(budgetHeaderId);
        List<BudgetResource__c> budgetResources = brSsc.getRecords();

      reset(budgetResources);
    }

    public ECO_DTO_BudgetLabourWrapper(Id budgetHeaderId, String resourceType) {
        system.debug('ECO_DTO_BudgetLabourWrapper Constructor BEGIN');
        this.budgetHeaderId = budgetHeaderId;
        dtoBudgetTasks = new List<ECO_DTO_BudgetTask>();
        dtoBudgetTasks = ECO_BudgetTaskService.getBudgetTaskList(budgetHeaderId);
        List<BudgetResource__c> budgetResources = budgetResourceSelector(budgetHeaderId, resourceType);

      reset(budgetResources);
    }
    
    public void reset(List<BudgetResource__c> budgetResources) {
        BudgetHeader__c budgetHeader = [Select Id, Project__c, Project__r.ProjectFunctionalCurrencyCode__c From BudgetHeader__c Where Id = :budgetHeaderId];
        hasFieldTasks = false;
        projectCurrency = budgetHeader.Project__r.ProjectFunctionalCurrencyCode__c;
        dtoBudgetLabourDetails = new List<ECO_DTO_BudgetLabourDetail>();
        
        for(BudgetResource__c budgetResource : budgetResources) {
          system.debug(LoggingLevel.INFO, '# of BudgetAssignments__r: ' + budgetResource.BudgetAssignments__r.size());
          ECO_DTO_BudgetLabourDetail dtoBudgetLabourDetail = new ECO_DTO_BudgetLabourDetail(budgetResource, budgetResource.BudgetAssignments__r);
          dtoBudgetLabourDetails.add(dtoBudgetLabourDetail);            
        }
        
        System.debug('BudgetResource complete');
        
        for(ECO_DTO_BudgetTask budgetTask : dtoBudgetTasks) {
          if (budgetTask.obudgetTask.ProjectTask__r.WorkTypeName__c == 'Field Office') {
            hasFieldTasks = true;
          }
        }
        
        createEmptyBudgetAssignments();
        
     //   system.debug('BudgetTaskService Complete');
        
        calculateTopLevelTasksTotalForLaborPerson();
        calculateTopLevelTasksTotalCostForSubPerson();
        calculateTopLevelTasksTotalRevenueForSubPerson();
        calculateTopLevelTasksEACForLaborPerson();
        calculateTopLevelTasksTotalQuantityForODCResource();
        calculateTopLevelTasksTotalComputedCostForODCResource();
        calculateTopLevelTasksEACForLaborPerson();

        calculateRates();
    }

    public void calculateRates() {
      mapLaborRatesByResourceId = new Map<Id, LaborRates>();
        for(ECO_DTO_BudgetLabourDetail labour : dtoBudgetLabourDetails) {
          EACTotals colTotals = mapEACTotalsByLaborDetailAndTask.get('' + labour.oBudgetResource.Id + 'Total');

          mapLaborRatesByResourceId.put(labour.oBudgetResource.Id, new LaborRates(colTotals));

        }
    }

    public void calculateTopLevelTasksEACForLaborPerson() {
      mapEACTotalsByLaborDetailAndTask = new Map<String, EACTotals>();
      grandTotals = new EACTotals();
      
        for(ECO_DTO_BudgetLabourDetail labour : dtoBudgetLabourDetails) {
          for(ECO_DTO_BudgetTask budgetTask : dtoBudgetTasks) {
                if(budgetTask.children.size() > 0 || budgetTask.indentLevel == 0) {
                    EACTotals totals = new EACTotals();
                    totals.EACActualQuantity = getSubtaskTotal(budgetTask, labour, 'EACActualQuantity__c', false);
                    totals.EACApprovedQuantity = getSubtaskTotal(budgetTask, labour, 'EACApprovedQuantity__c', false);
                    totals.EACForecastQuantity = getSubtaskTotal(budgetTask, labour, 'EACForecastQuantity__c', false);
                    
                    totals.EACActualCost = getSubtaskTotal(budgetTask, labour, 'EACActualCost__c', false);
                    totals.EACCurrentApprovedCost = getSubtaskTotal(budgetTask, labour, 'EACApprovedTotalCost__c', false);
                    totals.EACCurrentForecastCost = getSubtaskTotal(budgetTask, labour, 'EACForecastTotalCost__c', false);
                    totals.EACForecastRevenue = getSubtaskTotal(budgetTask, labour, 'OverrideTotalRevenue__c', false) + getSubtaskTotal(budgetTask, labour, 'EACForecastRevenue__c', false);
                    totals.EACCostToComplete = getSubtaskTotal(budgetTask, labour, 'OverrideTotalCost__c', false) + getSubtaskTotal(budgetTask, labour, 'EACForecastTotalCost__c', false);
                    totals.Quantity = getSubtaskTotal(budgetTask, labour, 'Quantity__c', false);  
					totals.EACEstimateToComplete = getSubtaskTotal(budgetTask, labour, 'OverrideTotalCost__c', false);
                    
                    mapEACTotalsByLaborDetailAndTask.put('' + labour.oBudgetResource.Id + budgetTask.obudgetTask.Id, totals);

                    if(budgetTask.indentLevel == 0) {
                      EACTotals colTotals = mapEACTotalsByLaborDetailAndTask.get('' + labour.oBudgetResource.Id + 'Total');

                      if(colTotals == null) {
                        colTotals = new EACTotals();
                        mapEACTotalsByLaborDetailAndTask.put('' + labour.oBudgetResource.Id + 'Total', colTotals);
                      }

                      colTotals.add(totals);
                      grandTotals.add(totals);
                    }
                } 
            }    
        }
    }

    private void calculateTopLevelTasksTotalForLaborPerson() {
        mapTotalByLaborDetailAndTask = new Map<String, Decimal>();
        for(ECO_DTO_BudgetLabourDetail labour : dtoBudgetLabourDetails) {
        	for(ECO_DTO_BudgetTask budgetTask : dtoBudgetTasks) {

                if(budgetTask.children.size() > 0 || budgetTask.indentLevel == 0) {
                    mapTotalByLaborDetailAndTask.put('' + labour.oBudgetResource.Id + budgetTask.obudgetTask.Id, getSubtaskTotal(budgetTask, labour, 'Quantity__c', false));
                }
        	}    
        }
    }
    
    private void calculateTopLevelTasksTotalCostForSubPerson() {
        mapTotalCostBySubDetailAndTask = new Map<String, Decimal>();
        for(ECO_DTO_BudgetLabourDetail labour : dtoBudgetLabourDetails) {
        	for(ECO_DTO_BudgetTask budgetTask : dtoBudgetTasks) {
                if(budgetTask.children.size() > 0 || budgetTask.indentLevel == 0) {
                    mapTotalCostBySubDetailAndTask.put('' + labour.oBudgetResource.Id + budgetTask.obudgetTask.Id, getSubtaskTotal(budgetTask, labour, 'OverrideTotalCost__c', false));
                }
        	}    
        }
    }

    private void calculateTopLevelTasksTotalQuantityForODCResource() {
        mapTotalQuantityByODCDetailAndTask = new Map<String, Decimal>();
        for(ECO_DTO_BudgetLabourDetail labour : dtoBudgetLabourDetails) {
          for(ECO_DTO_BudgetTask budgetTask : dtoBudgetTasks) {
                if(budgetTask.children.size() > 0 || budgetTask.indentLevel == 0) {
                    mapTotalQuantityByODCDetailAndTask.put('' + labour.oBudgetResource.Id + budgetTask.obudgetTask.Id, getSubtaskTotal(budgetTask, labour, 'Quantity__c', false));
                }
          }    
        }
    }

    private void calculateTopLevelTasksTotalComputedCostForODCResource() {
        mapTotalComputedCostByODCDetailAndTask = new Map<String, Decimal>();
        for(ECO_DTO_BudgetLabourDetail labour : dtoBudgetLabourDetails) {
          for(ECO_DTO_BudgetTask budgetTask : dtoBudgetTasks) {
                if(budgetTask.children.size() > 0 || budgetTask.indentLevel == 0) {
                    mapTotalComputedCostByODCDetailAndTask.put('' + labour.oBudgetResource.Id + budgetTask.obudgetTask.Id, getSubtaskTotal(budgetTask, labour, 'TotalComputedCost__c', false));
                }
          }    
        }
    }
    
    private void calculateTopLevelTasksTotalRevenueForSubPerson() {
        mapTotalRevenueBySubDetailAndTask = new Map<String, Decimal>();
        for(ECO_DTO_BudgetLabourDetail labour : dtoBudgetLabourDetails) {
        	for(ECO_DTO_BudgetTask budgetTask : dtoBudgetTasks) {
                if(budgetTask.children.size() > 0 || budgetTask.indentLevel == 0) {
                    if(labour.marginType == 'Amount'){
                       // System.debug('Total Calculated Revenue Amount: ' + getSubtaskTotal(budgetTask, labour, 'CalculatedRevenue__c', false));
                    	mapTotalRevenueBySubDetailAndTask.put('' + labour.oBudgetResource.Id + budgetTask.obudgetTask.Id, getSubtaskTotal(budgetTask, labour, 'OverrideTotalRevenue__c', false));
                	}
                    else if(labour.marginType == 'Percent') {
                       // System.debug('Total Calculated Revenue: ' + getSubtaskTotal(budgetTask, labour, 'CalculatedRevenue__c', false));
						mapTotalRevenueBySubDetailAndTask.put('' + labour.oBudgetResource.Id + budgetTask.obudgetTask.Id, getSubtaskTotal(budgetTask, labour, 'CalculatedRevenue__c', false));                        
                    }
                }
        	}    
        }
    }

    private void calculateGrandTotal() {
      Map<Id, ECO_DTO_BudgetTask> taskMap1 = new Map<Id, ECO_DTO_BudgetTask>();

      for (ECO_DTO_BudgetTask budgetTask : dtoBudgetTasks) {
          taskMap1.put(budgetTask.oBudgetTask.id, budgetTask);
      }

      for (ECO_DTO_BudgetLabourDetail labour : dtoBudgetLabourDetails) {
        for (BudgetAssignment__c assignment : labour.mAssignmentMap.values()) {
          ECO_DTO_BudgetTask theTask = taskMap1.get(assignment.BudgetTask__c);

          if (theTask == null)
            continue;

          theTask.totalComputedCost += (assignment.TotalComputedCost__c == null) ? 0 : assignment.TotalComputedCost__c;
        }
      }

      for (Integer i = dtoBudgetTasks.size() - 1; i >= 0; i--) {
        ECO_DTO_BudgetTask theTask = dtoBudgetTasks.get(i);

        if (theTask.children.size() > 0)
          theTask.totalComputedCost = theTask.getSubtaskTotal('TotalComputedCost__c');
      }
    }


	public Decimal getSubtaskTotal(ECO_DTO_BudgetTask budgetTask, ECO_DTO_BudgetLabourDetail labour, String fieldName, boolean includeThis) {
		Decimal result = 0;


		if (includeThis || (budgetTask.children.size() == 0)) {
            result += labour.mAssignmentMap.get(budgetTask.obudgetTask.Id).get(fieldName) == Null ? 0.0 : (Decimal) labour.mAssignmentMap.get(budgetTask.obudgetTask.Id).get(fieldName);
		}

		for (ECO_DTO_BudgetTask child : budgetTask.children) {
            result += getSubtaskTotal(child, labour, fieldName, true);
		}

		return result;
	}
    
    private void createEmptyBudgetAssignments() {
    	for(ECO_DTO_BudgetLabourDetail dtoBudgetLabourDetail : dtoBudgetLabourDetails) {
            for(ECO_DTO_BudgetTask dtoBudgetTask : dtoBudgetTasks) {
                BudgetAssignment__c budgetAssignment = dtoBudgetLabourDetail.mAssignmentMap.get(dtoBudgetTask.obudgetTask.Id);
                if( budgetAssignment == Null) {
                    budgetAssignment = new BudgetAssignment__c();
                    budgetAssignment.BudgetTask__c = dtoBudgetTask.obudgetTask.Id;
                    budgetAssignment.WorkTypeName__c = dtoBudgetTask.oBudgetTask.ProjectTask__r.WorkTypeName__c;
                    budgetAssignment.BudgetResource__c = dtoBudgetLabourDetail.oBudgetResource.Id;
                    budgetAssignment.Quantity__c = 0;
                    budgetAssignment.EACActualQuantity__c = 0;
                    
                    budgetAssignment.EACApprovedQuantity__c = 0;
                    budgetAssignment.EACForecastQuantity__c = 0;

                    budgetAssignment.EACActualCost__c = 0.0;
                    budgetAssignment.EACApprovedTotalCost__c = 0.0;
                    budgetAssignment.EACForecastTotalCost__c = 0.0;
                    budgetAssignment.OverrideTotalRevenue__c = 0.0;
                    
                    dtoBudgetLabourDetail.mAssignmentMap.put(dtoBudgetTask.obudgetTask.Id, budgetAssignment);
                    dtoBudgetLabourDetail.mapForecastRevenue.put(dtoBudgetTask.obudgetTask.Id, 0);
                    dtoBudgetLabourDetail.mapCostToComplete.put(dtoBudgetTask.obudgetTask.Id, 0);
                    //dtoBudgetLabourDetail.mapRevisedForecast.put(dtoBudgetTask.obudgetTask.Id, 0);                    
                }
            } 
        }
    }
    
    public void removeBudgetLabourDetail(Id budgetResourceId) {
        for(Integer i = 0; i < dtoBudgetLabourDetails.size(); i++) {
            if(dtoBudgetLabourDetails[i].oBudgetResource.Id == budgetResourceId) {
                dtoBudgetLabourDetails.remove(i);
            }
        }
    }

    public class LaborRates {
      public Decimal EACActualRate { get; set;}
      public Decimal EACApprovedRate {get; set; }
      public Decimal EACCurrentForecastRate {get; set; }
      public Decimal ETCRate { get; set;}
      public Decimal RevisedForecastRate {get; set; }

      public LaborRates(EACTotals colTotals) {
        if (colTotals == null) return;

        this.EACActualRate = calcRate(colTotals.EACActualCost, colTotals.EACActualQuantity);
        this.EACApprovedRate = calcRate(colTotals.EACCurrentApprovedCost, colTotals.EACApprovedQuantity); 
        this.EACCurrentForecastRate = calcRate(colTotals.EACCurrentForecastCost, colTotals.EACForecastQuantity); 
        this.ETCRate = calcRate(colTotals.EACCurrentForecastCost - colTotals.EACActualCost + colTotals.EACEstimateToComplete,
                                colTotals.EACForecastQuantity - colTotals.EACActualQuantity + colTotals.Quantity);

        this.RevisedForecastRate = calcRate(colTotals.EACCurrentForecastCost + colTotals.EACEstimateToComplete,
                                            colTotals.EACForecastQuantity + colTotals.Quantity); 
      }

      public Decimal calcRate(Decimal cost, Decimal quantity) {
        Decimal retVal;
        if(quantity != 0) {
            retVal = cost / quantity;
          } else {
            retVal = 0;
          }

          return retVal.setScale(2);
      }
    }

    public class EACTotals {

    	public Decimal EACActualQuantity {get {return setScaling(EACActualQuantity);} set;}
      	public Decimal EACApprovedQuantity {get {return setScaling(EACApprovedQuantity);} set;}
      	public Decimal EACForecastQuantity {get {return setScaling(EACForecastQuantity);} set;}
        
      	public Decimal EACActualCost {get {return setScaling(EACActualCost);} set;}
        public Decimal EACCurrentApprovedCost {get {return setScaling(EACCurrentApprovedCost);} set;}
        public Decimal EACCurrentForecastCost {get {return setScaling(EACCurrentForecastCost);} set;}
        public Decimal EACForecastRevenue {get {return setScaling(EACForecastRevenue);} set;}
        
        public Decimal EACEstimateToComplete {get {return setScaling(EACEstimateToComplete);} set;}
        public Decimal EACCostToComplete {get {return setScaling(EACCostToComplete);} set;}

        public Decimal Quantity { get {return setScaling(Quantity);} set; }

      	public EACTotals() {
        	EACActualQuantity = 0;
        	EACApprovedQuantity = 0;
        	EACForecastQuantity = 0;
        	EACActualCost = 0.0;
          	EACCurrentApprovedCost = 0.0;
          	EACCurrentForecastCost = 0.0;
          	EACForecastRevenue = 0.0;
          	Quantity = 0.0;
            EACEstimateToComplete = 0.0;
            EACCostToComplete = 0.0;
      	}

        public Decimal setScaling(Decimal val) {
          if (val != null) val = val.setScale(2);

          return val;
        }

        public void add(EACTotals totalsToAdd) {
            this.EACActualQuantity += totalsToAdd.EACActualQuantity ;
            this.EACApprovedQuantity += totalsToAdd.EACApprovedQuantity;
            this.EACForecastQuantity += totalsToAdd.EACForecastQuantity;
            this.EACActualCost += totalsToAdd.EACActualCost;
            this.EACCurrentApprovedCost += totalsToAdd.EACCurrentApprovedCost;
            this.EACCurrentForecastCost += totalsToAdd.EACCurrentForecastCost;
            this.EACForecastRevenue += totalsToAdd.EACForecastRevenue;
            this.Quantity += totalsToAdd.Quantity;
            this.EACEstimateToComplete += totalstoAdd.EACEstimateToComplete;
            this.EACCostToComplete += totalstoAdd.EACCostToComplete;
        }
    }
}