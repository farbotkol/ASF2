public with sharing class ECO_BudgetODCDetailController {
    public Id budgetHeaderId {get;set;}
    
     public ECO_DTO_BudgetLabourWrapper budgetLabourWrapper{get; set;}
     
    public List<SelectOption> expenditureTypes {get; set;}
    public List<SelectOption> unitTypes {get; set;}

    public ECO_DTO_BudgetTask totalRow {get; set;}
    
    public ECO_BudgetODCDetailController (ApexPages.StandardController con) {
		budgetHeaderId = con.getId();
        System.debug('budgetHeaderId: ' + budgetHeaderId);
        System.debug('con: ' + con);
        
        budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'ODC/FEE');

        totalRow = ECO_BudgetTaskService.getTotalRow(budgetLabourWrapper.dtoBudgetTasks);

		setupExpenditureTypes();      
		setupUnitTypes();  
    }

    public PageReference rerender() {
    	return null;
    }
    
	private void setupExpenditureTypes() {
		expenditureTypes = new List<SelectOption>();

		Schema.DescribeFieldResult fieldResult = BudgetResource__c.ExpenditureType__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
		for (Schema.PicklistEntry f : ple) {
			expenditureTypes.add(new SelectOption(f.getLabel(), f.getValue()));
		}       
	}

	private void setupUnitTypes() {
		unitTypes = new List<SelectOption>();

		Schema.DescribeFieldResult fieldResult = BudgetResource__c.CostCalcType__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
		for (Schema.PicklistEntry f : ple) {
			unitTypes.add(new SelectOption(f.getLabel(), f.getValue()));
		}       
	}

    public PageReference cloneResource () {
		System.savepoint sp = Database.setSavepoint();
		
        Id budgetSubId = System.currentPageReference().getParameters().get('budgetSubId');
        
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
													, CostCalcType__c
													, ResourceName__c
													, ColumnHeader__c
													, ProjectTeamMember__r.Contact__c
													, SortOrder__c
													, Sort_Order_Detail__c
													, ForeignResource__c
													, JobName__c
                                                	, TotalHours__c
                                                	, IsQuoted__c
                                                	, IsEstimated__c
                                                	, IsBillable__c
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
															, BudgetTask__c
															, CalculatedRevenue__c 
															, OverrideTotalCost__c 
															, OverrideTotalRevenue__c 
															, ProjectTaskAssignment__c
														FROM BudgetAssignments__r)
											FROM BudgetResource__c 
											WHERE Id = :budgetSubId AND ResourceType__c =: 'ODC/FEE'];
											
			BudgetResource__c clonedResource = sourceResource.clone(false, false, false, false);
			List<BudgetAssignment__c> clonedAssignments = new List<BudgetAssignment__c>();

			clonedResource.costCalcType__c = sourceResource.costCalcType__c;
			
			insert clonedResource;
			
			for (BudgetAssignment__c ba : sourceResource.BudgetAssignments__r) {
				BudgetAssignment__c clonedAssignment = ba.clone(false, false, false, false);
				clonedAssignment.BudgetResource__c = clonedResource.Id;
				clonedAssignments.add(clonedAssignment);
			}
			
			if (!clonedAssignments.isEmpty()) {
				insert clonedAssignments;
			}
			//budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'Subcontractor');
			//budgetLabourWrapper.dtoBudgetLabourDetails.add(new ECO_DTO_BudgetLabourDetail(clonedResource, clonedAssignments));
			
		} catch (Exception e) {
			system.debug('Cloning Exception:  '+e.getMessage());
			system.debug('Cloning Exception Trace:  '+e.getStackTraceString());
			Database.rollBack(sp);
			ApexPages.addMessages(e);
		}
        
        PageReference pageReference = new PageReference('/apex/ECO_BudgetODCDetail');
        pageReference.getParameters().put('Id', budgetHeaderId );
		pageReference.setRedirect(True);
		
        return pageReference;
	}
    
    public PageReference removeEntireColumn () {
		Id budgetSubId = System.currentPageReference().getParameters().get('budgetSubId');
		delete new BudgetResource__c(Id = budgetSubId);
		
		//budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'Subcontractor');
		//budgetLabourWrapper.removeBudgetLabourDetail(budgetSubId);
        
		PageReference pageReference = new PageReference('/apex/ECO_BudgetODCDetail');
        pageReference.getParameters().put('Id', budgetHeaderId );
		pageReference.setRedirect(True);
        
        return pageReference;
	}
    
    public PageReference save() {
        List<BudgetResource__c> budgetResourceToUpdate = new List<BudgetResource__c>();
        List<BudgetAssignment__c> budgetAssignmentsToUpdate = new List<BudgetAssignment__c>();
        
        for(ECO_DTO_BudgetLabourDetail dtoBudgetDetail : budgetLabourWrapper.dtoBudgetLabourDetails) {
      		budgetResourceToUpdate.add(dtoBudgetDetail.oBudgetResource);
            budgetAssignmentsToUpdate.addAll(dtoBudgetDetail.mAssignmentMap.values());
        }
        
        upsert budgetResourceToUpdate;
        upsert budgetAssignmentsToUpdate;
        
        PageReference pageReference = new PageReference('/apex/ECO_BudgetODCDetail');
        pageReference.getParameters().put('Id', budgetHeaderId );
		pageReference.setRedirect(True);
        
        return pageReference;
    }

}