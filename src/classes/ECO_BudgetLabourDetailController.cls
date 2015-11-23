public with sharing class ECO_BudgetLabourDetailController {
	public static final Integer PAGE_SIZE = 5;

	public Id budgetHeaderId {get;set;}
    
    public ECO_DTO_BudgetLabourWrapper budgetLabourWrapper{get; set;}

    public ECO_DTO_BudgetTask totalRow {get; set;}
    
    public Integer currentPage {get; set;}
    public Integer lastPage {get; set;}

    public Integer totalRecords {get; set;}

    public Boolean enablePageFirst {get; set;}
    public Boolean enablePagePrevious {get; set;}
    public Boolean enablePageNext {get; set;}
    public Boolean enablePageLast {get; set;}

    public ECO_BudgetLabourDetailController (ApexPages.StandardController con) {
		budgetHeaderId = con.getId();
        System.debug('budgetHeaderId: ' + budgetHeaderId);
        System.debug('con: ' + con);
        
        budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'Labor/Person');
        
        totalRow = ECO_BudgetTaskService.getTotalRow(budgetLabourWrapper.dtoBudgetTasks);

        initPage();
    }

    private void initPage() {
        currentPage = 0;

        if (ApexPages.currentPage().getParameters().get('pg') != null)
        	currentPage = Integer.valueOf(ApexPages.currentPage().getParameters().get('pg'));

        totalRecords = budgetLabourWrapper.dtoBudgetLabourDetails.size();

        lastPage = (totalRecords - 1) / PAGE_SIZE;
        
        if (lastPage < 0)
        	lastPage = 0;

		List<ECO_DTO_BudgetLabourDetail> newdtoBudgetLabourDetails = new List<ECO_DTO_BudgetLabourDetail>();

		Integer i = currentPage * PAGE_SIZE;
		
		while ((i < totalRecords) && (newdtoBudgetLabourDetails.size() < PAGE_SIZE)) {
			newdtoBudgetLabourDetails.add(budgetLabourWrapper.dtoBudgetLabourDetails.get(i));
			
			i++;
		}

		budgetLabourWrapper.dtoBudgetLabourDetails = newdtoBudgetLabourDetails;

		enablePageFirst = currentPage > 0;
		enablePagePrevious = currentPage > 0;
		enablePageNext = currentPage < lastPage;
		enablePageLast  = currentPage < lastPage;
    }

    public PageReference movePage() {
		PageReference pageReference = new PageReference('/apex/ECO_BudgetLabourDetail');
        
        pageReference.getParameters().put('id', budgetHeaderId);
        pageReference.getParameters().put('pg', String.valueOf(currentPage));
		pageReference.setRedirect(true);
        
        return pageReference;
    }

    public PageReference pageFirst() {
    	currentPage = 0;

    	return movePage();
    }

    public PageReference pagePrevious() {
    	currentPage--;

    	return movePage();
    }

    public PageReference pageNext() {
    	currentPage++;

    	return movePage();
    }

    public PageReference pageLast() {
    	currentPage = lastPage;

    	return movePage();
    }
    
    public PageReference cloneResource () {
		System.savepoint sp = Database.setSavepoint();
		
        Id budgetLabourId = System.currentPageReference().getParameters().get('budgetLabourId');
        
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
                                                	, TotalHours__c
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
											WHERE Id = :budgetLabourId AND ResourceType__c =: 'Labor/Person'];
											
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
			//budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'Labor/Person');
			//budgetLabourWrapper.dtoBudgetLabourDetails.add(new ECO_DTO_BudgetLabourDetail(clonedResource, clonedAssignments));
			
		} catch (Exception e) {
			system.debug('Cloning Exception:  '+e.getMessage());
			system.debug('Cloning Exception Trace:  '+e.getStackTraceString());
			Database.rollBack(sp);
			ApexPages.addMessages(e);
		}
        
        PageReference pageReference = new PageReference('/apex/ECO_BudgetLabourDetail');
        pageReference.getParameters().put('Id', budgetHeaderId );
		pageReference.setRedirect(True);
		
        return pageReference;
	}
    
    public PageReference removeEntireColumn () {
		Id budgetLabourId = System.currentPageReference().getParameters().get('budgetLabourId');
		delete new BudgetResource__c(Id = budgetLabourId);
		
		//budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'Labor/Person');
		//budgetLabourWrapper.removeBudgetLabourDetail(budgetLabourId);
        
		PageReference pageReference = new PageReference('/apex/ECO_BudgetLabourDetail');
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
        
        PageReference pageReference = new PageReference('/apex/ECO_BudgetLabourDetail');
        pageReference.getParameters().put('Id', budgetHeaderId );
		pageReference.setRedirect(True);
        
        return pageReference;
    }
}