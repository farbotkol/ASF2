public with sharing class ECO_BudgetContingencyController {
    public static final Integer PAGE_SIZE = 5;

    public Id budgetHeaderId {get;set;}
    
    public ECO_DTO_BudgetLabourWrapper budgetLabourWrapper{get; set;}

    public String projectCurrency {get; set;}

    public Decimal totalRisk {get; set;}
    public Decimal totalPostMitigationCost {get; set;}
    public Decimal totalMitigationCost {get; set;}
    public Decimal totalBudgetContingencies {get; set;}

    public Decimal totalApprovedContingencyCosts {get; set;}
    public Decimal totalForecastContingencyCosts {get; set;}

    public ECO_DTO_BudgetTask totalRow {get; set;}

    public Integer currentPage {get; set;}
    public Integer lastPage {get; set;}

    public Integer totalRecords {get; set;}

    public Boolean enablePageFirst {get; set;}
    public Boolean enablePagePrevious {get; set;}
    public Boolean enablePageNext {get; set;}
    public Boolean enablePageLast {get; set;}

    public ECO_BudgetContingencyController(ApexPages.StandardController con) {
        budgetHeaderId = con.getId();
        System.debug('budgetHeaderId: ' + budgetHeaderId);
        System.debug('con: ' + con);
        
        budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'Contingency');

        BudgetHeader__c budgetHeader = [Select Id, Project__c, Project__r.ProjectFunctionalCurrencyCode__c From BudgetHeader__c Where Id = :budgetHeaderId];

        projectCurrency = budgetHeader.Project__r.ProjectFunctionalCurrencyCode__c;
        //Double conversionRate = [SELECT conversionrate FROM currencytype WHERE isocode = :projectCurrency LIMIT 1].conversionRate;
        
        calcRiskTotals(budgetHeader.Project__c);


        //totalRisk = ECO_BudgetTaskService.sumRiskRegister(budgetHeader.Project__c) ;
        totalBudgetContingencies = ECO_BudgetTaskService.sumContingencies(budgetHeader.Project__c);
        
        //totalRisk = totalRisk != null ? totalRisk : 0;
        // totalBudgetContingencies = totalBudgetContingencies != null ? totalBudgetContingencies : 0;
        system.debug('totalPostMitigationCost: ' + totalPostMitigationCost);
        system.debug('totalBudgetContingencies: ' + totalBudgetContingencies);

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
        PageReference pageReference = new PageReference('/apex/ECO_BudgetContingency');
        
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

    public void calcRiskTotals(Id projectId) {
        List<Risk__c> risks =  [Select MitigationCostTotal__c,PostmitigationContingencyTotal__c, Project__c From Risk__c Where Project__c = :projectId];

        List<BudgetHeader__c> budgets = [Select Id, Status__c, TotalContingencyAmount__c From BudgetHeader__c Where Project__c = :projectId];

        Decimal sumTotalMitigationCost = 0;
        Decimal sumTotalPostMitigationCost = 0;
        totalApprovedContingencyCosts = 0;
        totalForecastContingencyCosts = 0;

        for(Risk__c risk : risks ) {
            sumTotalMitigationCost += risk.MitigationCostTotal__c == null ? 0 : risk.MitigationCostTotal__c;
            sumTotalPostMitigationCost += risk.PostmitigationContingencyTotal__c == null ? 0 : risk.PostmitigationContingencyTotal__c;
        }

        totalMitigationCost = sumTotalMitigationCost;
        totalPostMitigationCost = sumTotalPostMitigationCost;

        for (BudgetHeader__c bh : budgets) {
            if (bh.Id != budgetHeaderId) {
                if (bh.Status__c == 'Approved') {
                    totalApprovedContingencyCosts += bh.TotalContingencyAmount__c;                    
                } else if (bh.Status__c == 'Forecast') {
                    totalForecastContingencyCosts += bh.TotalContingencyAmount__c;
                }
            }
        }

        totalForecastContingencyCosts += totalApprovedContingencyCosts;
    }

    public PageReference cloneResource() {
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
                                            WHERE Id = :budgetSubId AND ResourceType__c =: 'Contingency'];
                                            
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
            //budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'Subcontractor');
            //budgetLabourWrapper.dtoBudgetLabourDetails.add(new ECO_DTO_BudgetLabourDetail(clonedResource, clonedAssignments));
            
        } catch (Exception e) {
            system.debug('Cloning Exception:  '+e.getMessage());
            system.debug('Cloning Exception Trace:  '+e.getStackTraceString());
            Database.rollBack(sp);
            ApexPages.addMessages(e);
        }
        
        PageReference pageReference = ApexPages.currentPage();
        pageReference.getParameters().put('Id', budgetHeaderId );
        pageReference.setRedirect(True);
        
        return pageReference;
    }

    public PageReference removeEntireColumn () {
        Id budgetSubId = System.currentPageReference().getParameters().get('budgetSubId');
        delete new BudgetResource__c(Id = budgetSubId);
        
        //budgetLabourWrapper = new ECO_DTO_BudgetLabourWrapper(budgetHeaderId, 'Subcontractor');
        //budgetLabourWrapper.removeBudgetLabourDetail(budgetSubId);
        
        PageReference pageReference = ApexPages.currentPage();
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
        
        system.debug('Resource: ' + budgetAssignmentsToUpdate[0].BudgetResource__c);
        system.debug('Task: ' + budgetAssignmentsToUpdate[0].BudgetTask__c);
        upsert budgetResourceToUpdate;
        upsert budgetAssignmentsToUpdate;
        
        PageReference pageReference = ApexPages.currentPage();
        pageReference.getParameters().put('Id', budgetHeaderId );
        pageReference.setRedirect(True);
        
        return pageReference;
    }
}