@isTest
private class ECO_BudgetHeaderSummaryControllerTest {
    static testMethod void testBudgetHeaderSummaryController() {
        Account account = AccountTestData.createAccounts(1)[0];
        insert account;
        
        pse__Proj__c project = PSEProjectTestData.createProjects(New List<Account>{account}, 1)[0];
        insert project;
        
        List<pse__Project_Task__c> projectTasks = PSEProjectTaskTestData.createProjectTasks(New List<pse__Proj__c>{project}, 5);
        insert projectTasks;
        
        List<BudgetHeader__c> budgetHeaders = BudgetHeaderTestData.createBudgetHeaders(new List<pse__Proj__c>{project}, 4);
        budgetHeaders[1].Status__c = DTO_BudgetHeader.STATUS_FORECAST;
        budgetHeaders[2].Status__c = DTO_BudgetHeader.STATUS_WORKATRISK;
        insert budgetHeaders;
        
        User testUser = ECO_Utils_Testing.createTestUser('Standard User');
		insert testUser;
        
        System.runAs(testUser) {
        	ECO_BudgetHeaderSummaryController controller = new ECO_BudgetHeaderSummaryController(new ApexPages.StandardController(project));
            Decimal BudgetTotalRawLabour = controller.budgetWrapper.getBudgetTotalRawLabour;
            Decimal ForecastTotalRawLabour = controller.budgetWrapper.getForecastTotalRawLabour;
            Decimal WorkAtRiskTotalRawLabour = controller.budgetWrapper.getWorkAtRiskTotalRawLabour;
            Decimal BudgetTotalFringe = controller.budgetWrapper.getBudgetTotalFringe;
            Decimal ForecastTotalFringe = controller.budgetWrapper.getForecastTotalFringe;
            Decimal WorkAtRiskTotalFringe = controller.budgetWrapper.getWorkAtRiskTotalFringe;
            Decimal BudgetTotalOverhead = controller.budgetWrapper.getBudgetTotalOverhead;
            Decimal ForecastTotalOverhead = controller.budgetWrapper.getForecastTotalOverhead;
            Decimal WorkAtRiskTotalOverhead = controller.budgetWrapper.getWorkAtRiskTotalOverhead;
            Decimal BudgetTotalSubAmount = controller.budgetWrapper.getBudgetTotalSubAmount;
            Decimal ForecastTotalSubAmount = controller.budgetWrapper.getForecastTotalSubAmount;
            Decimal WorkAtRiskTotalSubAmount = controller.budgetWrapper.getWorkAtRiskTotalSubAmount;
            Decimal BudgetTotalFeeAmount = controller.budgetWrapper.getBudgetTotalFeeAmount;
            Decimal ForecastTotalFeeAmount = controller.budgetWrapper.getForecastTotalFeeAmount;
            Decimal WorkAtRiskTotalFeeAmount = controller.budgetWrapper.getWorkAtRiskTotalFeeAmount;
            Decimal BudgetTotalCost = controller.budgetWrapper.getBudgetTotalCost;
            Decimal ForecastTotalCost = controller.budgetWrapper.getForecastTotalCost;
            Decimal WorkAtRiskTotalCost = controller.budgetWrapper.getWorkAtRiskTotalCost;
            Decimal BudgetTotalRevenue = controller.budgetWrapper.getBudgetTotalRevenue;
            Decimal ForecastTotalRevenue = controller.budgetWrapper.getForecastTotalRevenue;
            Decimal WorkAtRiskTotalRevenue = controller.budgetWrapper.getWorkAtRiskTotalRevenue;
            Decimal BudgetTotalNetServiceRevenue = controller.budgetWrapper.getBudgetTotalNetServiceRevenue;
            Decimal ForecastTotalNetServiceRevenue = controller.budgetWrapper.getForecastTotalNetServiceRevenue;
            Decimal WorkAtRiskTotalNetServiceRevenue = controller.budgetWrapper.getWorkAtRiskTotalNetServiceRevenue;
            Decimal BudgetTotalGrossMargin = controller.budgetWrapper.getBudgetTotalGrossMargin;
            Decimal ForecastTotalGrossMargin = controller.budgetWrapper.getForecastTotalGrossMargin;
            Decimal WorkAtRiskTotalGrossMargin = controller.budgetWrapper.getWorkAtRiskTotalGrossMargin;
            Decimal BudgetTotalNetMargin = controller.budgetWrapper.getBudgetTotalNetMargin;
            Decimal ForecastTotalNetMargin = controller.budgetWrapper.getForecastTotalNetMargin;
            Decimal WorkAtRiskTotalNetMargin = controller.budgetWrapper.getWorkAtRiskTotalNetMargin;
            Decimal BudgetTotalGMNSR = controller.budgetWrapper.getBudgetTotalGMNSR;
            Decimal ForecastTotalGMNSR = controller.budgetWrapper.getForecastTotalGMNSR;
            Decimal WorkAtRiskTotalGMNSR = controller.budgetWrapper.getWorkAtRiskTotalGMNSR;
            Decimal BudgetTotalNMNSR = controller.budgetWrapper.getBudgetTotalNMNSR;
            Decimal ForecastTotalNMNSR = controller.budgetWrapper.getForecastTotalNMNSR;
            Decimal WorkAtRiskTotalNMNSR = controller.budgetWrapper.getWorkAtRiskTotalNMNSR;
            
            String budgetName = controller.budgetWrapper.dtoBudgetHeaders[0].budgetName;
            DateTime createdDate = controller.budgetWrapper.dtoBudgetHeaders[0].CreatedDate;
            String Status = controller.budgetWrapper.dtoBudgetHeaders[0].status;
            Decimal dTotalCost = controller.budgetWrapper.dtoBudgetHeaders[0].dTotalCost;
            Decimal dTotalRevenue = controller.budgetWrapper.dtoBudgetHeaders[0].dTotalRevenue;
            Decimal dTotalApprovedCost = controller.budgetWrapper.dtoBudgetHeaders[0].dTotalApprovedCost;
            Decimal dTotalApprovedRevenue = controller.budgetWrapper.dtoBudgetHeaders[0].dTotalApprovedRevenue;
            Decimal dTotalForecastCost = controller.budgetWrapper.dtoBudgetHeaders[0].dTotalForecastCost;
            Decimal dTotalForecastRevenue = controller.budgetWrapper.dtoBudgetHeaders[0].dTotalForecastRevenue;
            Decimal dTotalWorkAtRiskCost = controller.budgetWrapper.dtoBudgetHeaders[0].dTotalWorkAtRiskCost;
			Decimal dTotalWorkAtRiskRevenue = controller.budgetWrapper.dtoBudgetHeaders[0].dTotalWorkAtRiskRevenue;            
        }
    }
}